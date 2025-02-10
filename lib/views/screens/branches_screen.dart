import 'package:elibrary/views/screens/years_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/asset_constants.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  List<String> branchNames = [
    "Computer Science",
    "Civil",
    "Mechanical",
    "Electrical",
  ];
  List<String> branchImages = [
    AssetConstants.computerEng,
    AssetConstants.civilEng,
    AssetConstants.mechanicalEng,
    AssetConstants.electricalEng,
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      itemCount: branchNames.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 8.0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            leading: Image.asset(branchImages[index]),
            title: Text(
              branchNames[index],
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(
                () => YearsScreen(
                  branchName: branchNames[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
