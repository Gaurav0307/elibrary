import 'package:elibrary/views/screens/content_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/string_constants.dart';

class ContentsScreen extends StatefulWidget {
  final String branchName;
  final String year;
  const ContentsScreen(
      {super.key, required this.branchName, required this.year});

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  List<String> contentNames = [
    StringConstants.notes,
    StringConstants.questionPapers,
    StringConstants.videos,
    StringConstants.subjects,
    StringConstants.syllabus,
  ];
  List<String> contentImages = [
    AssetConstants.notes,
    AssetConstants.questionPapers,
    AssetConstants.videos,
    AssetConstants.subjects,
    AssetConstants.syllabus,
  ];

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
            widget.year,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        itemCount: contentNames.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 8.0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              leading: Image.asset(contentImages[index]),
              title: Text(
                contentNames[index],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Get.to(
                  () => ContentListScreen(
                    branchName: widget.branchName,
                    year: widget.year,
                    content: contentNames[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
