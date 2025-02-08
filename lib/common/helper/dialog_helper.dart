import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  //show error dialog
  static void showErrorDialog({
    String title = 'Error',
    String? description = 'Something went wrong',
  }) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              Text(
                description ?? '',
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show toast

  //show snack bar
  static void showErrorSnackBar({
    String title = 'Error',
    String? description = 'Something went wrong',
  }) {
    Get.snackbar(
      "",
      "",
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.black54,
      icon: const Icon(
        Icons.clear,
        color: Colors.orange,
        size: 40,
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        "$description",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  static void showSnackBar({
    String title = 'Info',
    String? description = 'Description',
  }) {
    Get.snackbar(
      "",
      "",
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.black54,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.blue,
        size: 40,
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        "$description",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  //show loading
  static void showLoading([String? message]) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
