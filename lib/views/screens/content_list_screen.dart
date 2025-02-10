import 'package:elibrary/common/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/services/file_downloader.dart';
import 'file_viewer.dart';

class ContentListScreen extends StatefulWidget {
  final String branchName;
  final String year;
  final String content;
  const ContentListScreen(
      {super.key,
      required this.branchName,
      required this.year,
      required this.content});

  @override
  State<ContentListScreen> createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  final _documents = [
    {
      'name': 'Android Programming Cookbook',
      'link':
          'https://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf'
    },
  ];

  final _images = [
    {
      'name': 'Arches National Park',
      'link':
          'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg'
    },
    {
      'name': 'Canyonlands National Park',
      'link':
          'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg'
    },
    {
      'name': 'Death Valley National Park',
      'link':
          'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg'
    },
    {
      'name': 'Gates of the Arctic National Park and Preserve',
      'link':
          'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg'
    }
  ];

  final _videos = [
    {
      'name': 'Big Buck Bunny',
      'link':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
    },
    {
      'name': 'Elephant Dream',
      'link':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
    }
  ];

  var allData = [];

  List<MyDownloader> myDownloaderList = [];

  @override
  void initState() {
    // TODO: implement initState
    if (widget.content == StringConstants.notes ||
        widget.content == StringConstants.questionPapers ||
        widget.content == StringConstants.subjects ||
        widget.content == StringConstants.syllabus) {
      allData = [..._documents, ..._images];
    } else {
      allData = [..._videos];
    }
    myDownloaderList = List.generate(allData.length, (index) => MyDownloader());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: ListTile(
          title: Text(
            widget.branchName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "${widget.year} (${widget.content})",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        itemCount: allData.length,
        itemBuilder: (_, index) {
          return Obx(
            () {
              String name = allData[index]['name']!;
              String url = allData[index]['link']!;
              return Card(
                elevation: 5.0,
                child: ListTile(
                  onTap: () async {
                    if (myDownloaderList[index].isDownloaded(url)) {
                      String filePath = await myDownloaderList[index]
                          .getDownloadedFilePath(url);
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
                      if (myDownloaderList[index].status.value ==
                          "downloading") {
                        myDownloaderList[index].cancelDownload();
                      } else if (!myDownloaderList[index].isDownloaded(url)) {
                        myDownloaderList[index].download(url, name);
                      } else if (myDownloaderList[index].status.value ==
                              "completed" ||
                          myDownloaderList[index].isDownloaded(url)) {
                        myDownloaderList[index].deleteDownload(url);
                      }
                    },
                    icon: myDownloaderList[index].status.value == "downloading"
                        ? FittedBox(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.downloading,
                                  color: Colors.green,
                                ),
                                Text(
                                  "${myDownloaderList[index].progress.floor()}%",
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : myDownloaderList[index].status.value ==
                                    "downloaded" ||
                                myDownloaderList[index].isDownloaded(url)
                            ? const FittedBox(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "Delete\nDownload",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 6.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const FittedBox(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: Colors.lightBlue,
                                    ),
                                    Text(
                                      "Download",
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
              );
            },
          );
        },
      ),
    );
  }
}
