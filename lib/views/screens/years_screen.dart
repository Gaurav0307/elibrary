import 'package:elibrary/views/screens/contents_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearsScreen extends StatefulWidget {
  final String branchName;
  const YearsScreen({super.key, required this.branchName});

  @override
  State<YearsScreen> createState() => _YearsScreenState();
}

class _YearsScreenState extends State<YearsScreen> {
  List<String> years = [
    "First Year",
    "Second Year",
    "Third Year",
    "Fourth Year",
  ];

  // List of rainbow colors
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(
          widget.branchName,
          // StringConstants.years,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        itemCount: years.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 8.0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              leading: CircleAvatar(
                backgroundColor: colors[index],
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(
                years[index],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Get.to(
                  () => ContentsScreen(
                    branchName: widget.branchName,
                    year: years[index],
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
