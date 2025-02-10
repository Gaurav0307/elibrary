import 'package:elibrary/common/constants/asset_constants.dart';
import 'package:elibrary/common/constants/string_constants.dart';
import 'package:elibrary/views/screens/branches_screen.dart';
import 'package:elibrary/views/screens/downloads_screen.dart';
import 'package:elibrary/views/screens/liked_videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          title: Text(
            StringConstants.appName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 225.0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetConstants.student,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Student Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text(
                    StringConstants.downloads,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () {
                    Get.to(() => const DownloadsScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text(
                    StringConstants.likedVideos,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () {
                    Get.to(() => const LikedVideosScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    StringConstants.history,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                  onTap: () {},
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    StringConstants.logout,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        body: BranchesScreen(),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            StringConstants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: const Text(StringConstants.doYouWantToExitTheApp),
          actions: <Widget>[
            TextButton(
              child: const Text(
                StringConstants.no,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //Will not exit the App
              },
            ),
            TextButton(
              child: const Text(
                StringConstants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                SystemNavigator.pop();
                Navigator.of(context).pop(); //Will exit the App
              },
            )
          ],
        );
      },
    );
  }
}
