import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/constants/api_constants.dart';
import '../common/constants/storage_constants.dart';
import '../common/global/global.dart';
import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';
import '../common/services/base_client.dart';
import '../common/utils/utility_methods.dart';
import 'base_controller.dart';

class AuthController extends GetxController with BaseController {
  var isLoading = false.obs;

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
    String college,
  ) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.graphQL;

    var headers = {
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "query": r"""
      mutation Register($first_name: String!, $last_name: String!, $email: String!, $password: String!, $phone: String!, $collage: String!) {
        register(first_name: $first_name, last_name: $last_name, email: $email, password: $password, phone: $phone, collage: $collage) {
          message
        }
      }
      """, // Use `r"""` to prevent Dart from interpreting `$` as a variable.,
      "variables": {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "collage": college
      },
      "operationName": "Register"
    };

    var responseJson = await BaseClient()
        .post(baseUrl, endpoint, headers, jsonEncode(body))
        .catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Register API Response :-> $responseJson");
    }

    if (responseJson.toString() == 'null') {
      isLoading.value = false;

      return false;
    } else {
      isLoading.value = false;

      var message = jsonDecode(responseJson)["data"]["register"]["message"];

      if (message.toString() != 'null') {
        if (message.toString().contains("email")) {
          var newMessage = jsonDecode(message.toString())["email"][0];
          showMessage(description: newMessage.toString());
          return false;
        } else {
          showMessage(description: message.toString());
          return true;
        }
      } else {
        return false;
      }
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.graphQL;

    var headers = {
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "query": r"""
      mutation Login($email: String!, $password: String!) {
        login(email: $email, password: $password) {
          token
          email
          username
          expires_in
          userID
        }
      }
      """,
      "variables": {"email": email, "password": password},
      "operationName": "Login"
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, headers, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);

          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else if (error is UnAuthorizedException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Login API Response :-> $responseJson");
    }

    if (responseJson == null) {
      isLoading.value = false;

      return false;
    } else {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      token = jsonDecode(responseJson)["token"].toString();
      userId = jsonDecode(responseJson)["userId"].toString();

      if (token != 'null') {
        sharedPreferences?.setString(StorageConstants.token, token);
        sharedPreferences?.setString(StorageConstants.userId, userId);

        await UtilityMethods.loadInitialData();

        isLoading.value = false;

        return true;
      } else {
        isLoading.value = false;

        return false;
      }
    }
  }
}
