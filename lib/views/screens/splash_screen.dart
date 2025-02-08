import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:elibrary/views/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/utils/utility_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    loadData();

    super.initState();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 5));

    await UtilityMethods.loadInitialData();

    if (token.isNotEmpty) {
      // Get.to(() => const HomeScreen());
    } else {
      Get.to(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      // onPopInvoked: (didPop) async {
      //   if (didPop) {
      //     return;
      //   }
      //   await _onBackPressed();
      // },
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            color: ColorConstants.theBlack,
            image: DecorationImage(
              image: AssetImage(AssetConstants.backgroundImage1),
              fit: BoxFit.fitHeight,
              opacity: 0.5,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 35,
                  color: ColorConstants.theWhite,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 12.0,
                      color: ColorConstants.theWhite,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      StringConstants.appName,
                      speed: const Duration(milliseconds: 200),
                    ),
                    FlickerAnimatedText(StringConstants.appName),
                    FlickerAnimatedText(StringConstants.appName),
                  ],
                  onTap: () {
                    if (kDebugMode) {
                      print("Tap Event");
                    }
                  },
                ),
              ),
            ),
          ),
        ),
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
