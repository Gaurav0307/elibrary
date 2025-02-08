import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exceptions.dart';

class DioClient {
  static const int TIME_OUT_DURATION = 20;
  final Dio dio = Dio();

  //GET
  Future<dynamic> get(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await dio
          .get(baseUrl + api)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = FormData.fromMap(payloadObj);
    try {
      var response = await dio
          .post(
            baseUrl + api,
            data: payload,
            options: Options(
              method: 'POST',
              headers: headers,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 501;
              },
            ),
          )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      log("Dio Exception :-> $e");
    }
  }

  //DELETE

  //OTHER

  dynamic _processResponse(response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
      case 422:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.request!.url.toString());
    }
  }
}
