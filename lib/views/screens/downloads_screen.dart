import 'package:elibrary/common/constants/string_constants.dart';
import 'package:elibrary/views/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/services/file_downloader.dart';
import 'file_viewer.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  MyDownloader myDownloader = MyDownloader();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await myDownloader.loadDownloads();
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(
          StringConstants.downloads,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => Visibility(
          visible: !loading,
          replacement: Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ),
          child: Visibility(
            visible: allDownloads.isNotEmpty,
            replacement: NoData(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              itemCount: allDownloads.length,
              itemBuilder: (_, index) {
                String name = allDownloads[index].task.displayName;
                String url = allDownloads[index].task.url;
                // bool isCompleted = myDownloader.isDownloaded(url);
                return Visibility(
                  // visible: isCompleted,
                  replacement: SizedBox.shrink(),
                  child: Card(
                    elevation: 5.0,
                    child: ListTile(
                      onTap: () async {
                        if (myDownloader.isDownloaded(url)) {
                          String filePath =
                              await myDownloader.getDownloadedFilePath(url);
                          Get.to(() => FileViewer(filePath: filePath));
                        } else {
                          Get.to(() => FileViewer(filePath: url));
                        }
                      },
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black87),
                        ),
                        child: url.toLowerCase().endsWith("jpg") ||
                                url.toLowerCase().endsWith("jpeg")
                            ? const Icon(Icons.photo_library)
                            : url.toLowerCase().endsWith("mp4") ||
                                    url.toLowerCase().endsWith("mpeg4")
                                ? const Icon(Icons.video_collection)
                                : const Icon(Icons.picture_as_pdf),
                      ),
                      title: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        url,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (myDownloader.status.value == "downloading" ||
                              myDownloader.isDownloading(url)) {
                            myDownloader.cancelDownload(url);
                          } else if (!myDownloader.isDownloaded(url)) {
                            myDownloader.download(url, name);
                          } else if (myDownloader.status.value == "completed" ||
                              myDownloader.isDownloaded(url)) {
                            myDownloader.deleteDownload(url);
                          }
                        },
                        icon: myDownloader.status.value == "downloading" ||
                                myDownloader.isDownloading(url)
                            ? FittedBox(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.downloading,
                                      color: Colors.green,
                                    ),
                                    if (myDownloader.progress > 0)
                                      Text(
                                        "${myDownloader.progress.floor()}%",
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    else
                                      Text(
                                        StringConstants.downloading,
                                        style: const TextStyle(
                                          fontSize: 5.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                  ],
                                ),
                              )
                            : myDownloader.status.value == "downloaded" ||
                                    myDownloader.isDownloaded(url)
                                ? FittedBox(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          StringConstants.deleteDownload,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 6.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : FittedBox(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.download,
                                          color: Colors.lightBlue,
                                        ),
                                        Text(
                                          StringConstants.download,
                                          style: TextStyle(
                                            fontSize: 6.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
