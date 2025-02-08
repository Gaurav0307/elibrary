import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_constants.dart';
import '../global/global.dart';

class UtilityMethods {
  static Future<void> loadInitialData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    token = sharedPreferences!.getString(StorageConstants.token) ?? "";
    userId = sharedPreferences!.getString(StorageConstants.userId) ?? "";

    if (token.isNotEmpty && userId.isNotEmpty) {
      await Future.wait([
        // Get.put(UserController()).getUserDetails(),
        // Get.put(UserController()).getUsers(),
      ]);
    }
  }

  // Function to convert a string to a DateTime object
  static DateTime convertStringToDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  // Function to format a DateTime object to a string in "dd/MM/yyyy" format
  String formatDateTimeToString1(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  String formatDateTimeToString(DateTime? dateTime) {
    if (dateTime == null) {
      return 'DD/MM/YYYY';
    }
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatDateTimeToString3(DateTime? dateTime) {
    if (dateTime == null) {
      return 'DD/MM/YYYY HH:MM a';
    }
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }

  // Function to format a DateTime object to a string in "dd MMM. yyyy" format
  String formatDateTimeToString2(DateTime dateTime) {
    String month = '';
    switch (dateTime.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
      default:
        month = 'N/A';
    }

    return "${dateTime.day.toString().padLeft(2, '0')} $month. ${dateTime.year}";
  }

  String dateTimeStringToFormattedDateString1(String dateTimeString) {
    return formatDateTimeToString1(convertStringToDateTime(dateTimeString));
  }

  String dateTimeStringToFormattedDateString2(String dateTimeString) {
    return formatDateTimeToString2(convertStringToDateTime(dateTimeString));
  }

  bool isDateOlderThanThreeDays(String dateString) {
    // Define the date format corresponding to the input string
    DateFormat format = DateFormat('MM/dd/yyyy hh:mm:ss a');
    // Parse the string to a DateTime object
    DateTime dateTime = format.parse(dateString);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(dateTime);
    return difference.inDays > 3;
  }

  static Future<bool> checkStoragePermission(TargetPlatform platform) async {
    if (platform == TargetPlatform.android) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        return true;
      }
      final status1 = await Permission.storage.status;
      if (status1 != PermissionStatus.granted) {
        final result1 = await Permission.storage.request();
        if (result1 == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Future<File?> moveFileToTempDirectory(File file) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();

      // Generate a unique filename based on the current timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = 'image_$timestamp.${file.path.split(".").last}';

      // Create a new File object in the temporary directory
      final tempFile = File('${tempDir.path}/$uniqueFileName');

      // Copy the selected file to the temporary directory
      await file.copy(tempFile.path);

      // You can now use `tempFile` for further processing or displaying the file
      debugPrint('File moved to temporary directory: ${tempFile.path}');

      return tempFile;
    } catch (e) {
      debugPrint('Error moving file: $e');
    }

    return null;
  }

  static Future<void> moveFileToDownloadsDirectory(
      File file, BuildContext context) async {
    try {
      var savePath = file.path;
      var fileName = file.path.split("/").last;

      await File(savePath).copy('/storage/emulated/0/Download/$fileName');
      await File(savePath).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Download finished. Please check Download folder of your device."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed!\nException - $e"),
        ),
      );
    }
  }

  static Future<String?> videoThumbnail(String videoPath) async {
    String? thumbnailPath;
    try {
      XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 50,
      );
      thumbnailPath = thumbnailFile.path;
    } catch (e) {
      debugPrint("$e");
    }

    return thumbnailPath ?? "";
  }

  static download(BuildContext context, String fileUrl) async {
    TargetPlatform platform = Theme.of(context).platform;

    final hasPermission = await checkStoragePermission(platform);

    if (hasPermission) {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${fileUrl.split("/").last}";
      final directory = await getApplicationDocumentsDirectory();
      final savePath = "${directory.path}/$fileName";

      try {
        BuildContext? dialogContext;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;
            return const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 30),
                  Text("Downloading..."),
                ],
              ),
            );
          },
        );

        await Dio().download(
          fileUrl,
          savePath,
          options: Options(
            headers: {HttpHeaders.acceptEncodingHeader: "*"},
          ),
          onReceiveProgress: (received, total) {},
        );

        await File(savePath).copy('/storage/emulated/0/Download/$fileName');
        await File(savePath).delete();

        Navigator.pop(dialogContext!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Download finished. Please check Download folder of your device."),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Download failed!\nException - $e"),
          ),
        );
      }
    } else {
      if (kDebugMode) {
        print("Permission Denied!");
      }
    }
  }

  static String capitalizeWords(String text) {
    // Split the input text into words
    List<String> words = text.split(' ');

    // Capitalize the first letter of each word
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  static bool isBlank(String text) {
    // Check if the text consists of only blank spaces
    return text.trim().isEmpty;
  }

  static String getNameInitials({required String name}) {
    String initials = '';

    List<String> words = name.contains(" ") ? name.split(" ") : [name];

    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0];
      }
    }

    return initials.toUpperCase();
  }

  static getRandomColors() {
    // List of rainbow colors
    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    // Generate a random index
    final randomIndex = Random().nextInt(colors.length);

    // Return a random color from the rainbowColors list
    return colors[randomIndex];
  }

  static getProperFileUrl(String fileUrl) {
    String updatedFileUrl = fileUrl.contains("\\")
        ? "$apiBaseUrl/${fileUrl.replaceAll("\\", "/")}"
        : "$apiBaseUrl/$fileUrl";
    return updatedFileUrl;
  }
}
