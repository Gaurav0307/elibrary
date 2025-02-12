import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

var allDownloads = <TaskRecord>[].obs;

class MyDownloader {
  var progress = 0.0.obs;
  var status = "".obs;

  DownloadTask? _downloadTask;
  // var allDownloads = <TaskRecord>[].obs;

  MyDownloader() {
    /// optional: configure the downloader with platform specific settings.
    FileDownloader().configure(
      globalConfig: [
        (
          Config.requestTimeout,
          const Duration(seconds: 100),
        ),
      ],
      androidConfig: [
        (
          Config.useCacheDir,
          Config.whenAble,
        ),
      ],
      iOSConfig: [
        (
          Config.localize,
          {'Cancel': 'StopIt'},
        ),
      ],
    ).then(
      (result) => debugPrint('Configuration result = $result'),
    );

    _getPermission(PermissionType.notifications);

    /// Registering a callback and configure notifications
    FileDownloader()
        .registerCallbacks(
            taskNotificationTapCallback: _myNotificationTapCallback)
        .configureNotificationForGroup(
          FileDownloader.defaultGroup,
          // For the main download button
          // which uses 'enqueue' and a default group
          running: const TaskNotification(
            'Downloading {displayName}',
            'File: {filename} \n{progress} ({networkSpeed}) - {timeRemaining} remaining',
          ),
          complete: const TaskNotification(
            'Downloaded {displayName} - {filename}',
            'Download complete',
          ),
          error: const TaskNotification(
            'Download {displayName}',
            'Download failed',
          ),
          paused: const TaskNotification(
            'Download {displayName}',
            'Paused {metadata}',
          ),
          progressBar: true,
        )
        .configureNotificationForGroup(
          'bunch',
          running: const TaskNotification(
            '{numFinished} out of {numTotal}',
            'Progress = {progress}',
          ),
          complete: const TaskNotification(
            "Done!",
            "Loaded {numTotal} files",
          ),
          error: const TaskNotification(
            'Error',
            '{numFailed}/{numTotal} failed',
          ),
          progressBar: true,
          groupNotificationId: 'notGroup',
        )
        .configureNotification(
          // for the 'Download & Open' dog picture
          // which uses 'download' which is not the .defaultGroup
          // but the .await group so won't use the above config
          complete: const TaskNotification(
            'Download {displayName}',
            'Download complete',
          ),
          tapOpensFile: true, // dog can also open directly from tap
        );

    /// Listen to updates and process
    // FileDownloader().updates.listen((update) {
    //   switch (update) {
    //     case TaskStatusUpdate():
    //       // process the TaskStatusUpdate
    //       switch (update.status) {
    //         case TaskStatus.complete:
    //           status = "completed";
    //           debugPrint('Task ${update.task.taskId} success!');
    //
    //         case TaskStatus.canceled:
    //           status = "canceled";
    //           debugPrint('Download was canceled');
    //
    //         case TaskStatus.paused:
    //           status = "paused";
    //           debugPrint('Download was paused');
    //
    //         case TaskStatus.running:
    //           status = "downloading";
    //           debugPrint('Downloading...');
    //
    //         default:
    //           debugPrint('Download not successful');
    //       }
    //
    //     case TaskProgressUpdate():
    //       // process the TaskProgressUpdate
    //       progress = update.progress.floorToDouble();
    //   }
    // });

    /// activates the database and ensures proper restart after suspend/kill
    FileDownloader().start();

    loadDownloads();
  }

  /// Process the user tapping on a notification by printing a message
  void _myNotificationTapCallback(
      Task task, NotificationType notificationType) {
    debugPrint(
        'Tapped notification $notificationType for taskId ${task.taskId}');
  }

  Future<void> download(String url, String displayName) async {
    if (!isDownloading(url)) {
      var fileName =
          "${DateTime.timestamp().microsecondsSinceEpoch}.${url.split(".").last}";

      /// define the download task (subset of parameters shown)
      _downloadTask = DownloadTask(
        url: url,
        filename: fileName,
        displayName: displayName,
        directory: 'my_downloads',
        updates: Updates.statusAndProgress,
        // request status and progress updates
        requiresWiFi: false,
        retries: 5,
        allowPause: true,
        metaData: '$displayName - $fileName',
      );

      /// Start download, and wait for result. Show progress and status changes while downloading
      final result = await FileDownloader().download(
        _downloadTask!,
        onProgress: (progress_) {
          progress.value = (progress_ * 100).floorToDouble();
          debugPrint('Progress: $progress%');
        },
        onStatus: (status_) {
          if (status_ == TaskStatus.running) {
            status.value = "downloading";
          } else if (status_ == TaskStatus.paused) {
            status.value = "paused";
          } else if (status_ == TaskStatus.canceled) {
            status.value = "canceled";
          } else if (status_ == TaskStatus.complete) {
            status.value = "completed";
          }

          debugPrint('Status: $status_');
        },
        onElapsedTime: (duration) => debugPrint(""),
        elapsedTimeInterval: const Duration(seconds: 20),
      );

      /// Act on the result
      switch (result.status) {
        case TaskStatus.complete:
          debugPrint('Success!');

        case TaskStatus.canceled:
          debugPrint('Download was canceled');

        case TaskStatus.paused:
          debugPrint('Download was paused');

        default:
          debugPrint('Download not successful');
      }

      loadDownloads();
    }
  }

  Future<void> pauseDownload() async {
    await FileDownloader().pause(_downloadTask!);
  }

  Future<void> resumeDownload() async {
    await FileDownloader().resume(_downloadTask!);
  }

  // Future<void> cancelDownload() async {
  //   await FileDownloader().cancelTaskWithId(_downloadTask!.taskId);
  //   deleteDownload(_downloadTask!.url);
  // }

  Future<void> cancelDownload(String url) async {
    String taskId = await getTaskId(url);
    await FileDownloader().cancelTaskWithId(taskId);
    deleteDownload(url);
  }

  Future<String> getTaskId(String url) async {
    allDownloads.value = await FileDownloader().database.allRecords();
    String taskId = "";
    for (TaskRecord download in allDownloads) {
      if (download.task.url == url) {
        taskId = download.task.taskId;
      }
    }

    return taskId;
  }

  Future<void> deleteDownload(String url) async {
    allDownloads.value = await FileDownloader().database.allRecords();
    String taskId = "";
    String file = "";
    for (TaskRecord download in allDownloads) {
      if (download.task.url == url) {
        taskId = download.task.taskId;
        file = "${download.task.directory}/${download.task.filename}";
        if (taskId.isNotEmpty) {
          debugPrint("File (deleteDownload): $file");
          await FileDownloader().database.deleteRecordWithId(taskId);
          await _deleteFile(file);
        }
      }
    }

    loadDownloads();
  }

  Future<void> _deleteFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted: $filePath');
      } else {
        debugPrint('File not found: $filePath');
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  bool isDownloading(String url) {
    bool isDownloading = false;
    for (TaskRecord download in allDownloads) {
      if (download.task.url == url && download.status == TaskStatus.running) {
        isDownloading = true;
        debugPrint(
          "File Path (isDownloading): ${download.task.directory}/${download.task.filename}",
        );
      }
    }

    return isDownloading;
  }

  bool isDownloaded(String url) {
    bool isDownloaded = false;
    for (TaskRecord download in allDownloads) {
      if (download.task.url == url && download.status == TaskStatus.complete) {
        isDownloaded = true;
        debugPrint(
          "File Path (isDownloaded): ${download.task.directory}/${download.task.filename}",
        );
      }
    }

    return isDownloaded;
  }

  Future<String> getDownloadedFilePath(String url) async {
    String downloadedFilePath = "";
    for (TaskRecord download in allDownloads) {
      if (download.task.url == url && download.status == TaskStatus.complete) {
        final file = "${download.task.directory}/${download.task.filename}";
        final directory = await getApplicationDocumentsDirectory();
        downloadedFilePath = '${directory.path}/$file';

        debugPrint("File Path (getDownloadedFilePath): $downloadedFilePath");
      }
    }

    return downloadedFilePath;
  }

  Future<void> loadDownloads() async {
    allDownloads.value = await FileDownloader().database.allRecords();
    debugPrint("All Downloads: ${allDownloads.string}");
  }

  /// Attempt to get permissions if not already granted
  Future<void> _getPermission(PermissionType permissionType) async {
    var status = await FileDownloader().permissions.status(permissionType);
    if (status != PermissionStatus.granted) {
      if (await FileDownloader()
          .permissions
          .shouldShowRationale(permissionType)) {
        debugPrint('Showing some rationale');
      }
      status = await FileDownloader().permissions.request(permissionType);
      debugPrint('Permission for $permissionType was $status');
    }
  }
}
