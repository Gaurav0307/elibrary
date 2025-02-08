import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'app_exceptions.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 20;
  static http.Client? _client;

  BaseClient() {
    _client ??= http.Client();
  }

  //GET
  Future<dynamic> get(
    String baseUrl,
    String api,
    Map<String, String>? headers,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http
          .get(uri, headers: headers)
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
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      var response = await http
          .post(uri, headers: headers, body: payload)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  Future<dynamic> postMultipart(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, File>? files,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('POST', uri);

      if (files != null) {
        for (var file in files.entries) {
          final multipartFile = await http.MultipartFile.fromPath(
            file.key,
            file.value.path,
            filename: file.value.path.split("/").last,
          );

          debugPrint("File Path :-> ${file.value.path}");

          request.files.add(multipartFile);
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> postMultipartWeb(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, Uint8List>? files,
    String? fileName,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('POST', uri);

      if (files != null) {
        for (var file in files.entries) {
          final multipartFile = http.MultipartFile.fromBytes(
            file.key,
            file.value,
            filename: fileName,
          );

          debugPrint("File Path :-> $fileName");

          request.files.add(multipartFile);
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> postMultipartMultiFile(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, List<File>>? files,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('POST', uri);

      if (files != null) {
        for (var _file in files.entries) {
          for (var file in _file.value) {
            final multipartFile = await http.MultipartFile.fromPath(
              _file.key,
              file.path,
              filename: file.path.split("/").last,
            );

            debugPrint("File Path :-> ${file.path}");

            request.files.add(multipartFile);
          }
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> postMultipartMultiFileWeb(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, List<Uint8List>>? files,
    List<String>? fileNames,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('POST', uri);

      if (files != null) {
        int i = 0;
        for (var _file in files.entries) {
          for (var file in _file.value) {
            final multipartFile = http.MultipartFile.fromBytes(
              _file.key,
              file,
              filename: fileNames?[i],
            );

            debugPrint("File Path :-> ${fileNames?[i]}");

            request.files.add(multipartFile);
            i++;
          }
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  //DELETE
  Future<dynamic> delete(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);
    try {
      var response = await http
          .delete(uri, headers: headers, body: payload)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //PUT
  Future<dynamic> put(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      var response = await http
          .put(uri, headers: headers, body: payload)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      log("-> ${response.statusCode}");
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  Future<dynamic> putMultipart(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, File>? files,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('PUT', uri);

      if (files != null) {
        for (var file in files.entries) {
          final multipartFile = await http.MultipartFile.fromPath(
            file.key,
            file.value.path,
            filename: file.value.path.split("/").last,
          );

          debugPrint("File Path :-> ${file.value.path}");

          request.files.add(multipartFile);
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> putMultipartWeb(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, Uint8List>? files,
    String? fileName,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('PUT', uri);

      if (files != null) {
        for (var file in files.entries) {
          final multipartFile = http.MultipartFile.fromBytes(
            file.key,
            file.value,
            filename: fileName,
          );

          debugPrint("File Path :-> $fileName");

          request.files.add(multipartFile);
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> putMultipartMultiFile(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, List<File>>? files,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('PUT', uri);

      if (files != null) {
        for (var _file in files.entries) {
          for (var file in _file.value) {
            final multipartFile = await http.MultipartFile.fromPath(
              _file.key,
              file.path,
              filename: file.path.split("/").last,
            );

            debugPrint("File Path :-> ${file.path}");

            request.files.add(multipartFile);
          }
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  Future<dynamic> putMultipartMultiFileWeb(
    String baseUrl,
    String api,
    Map<String, String>? headers,
    dynamic payloadObj,
    Map<String, List<Uint8List>>? files,
    List<String>? fileNames,
  ) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = payloadObj;
    try {
      final request = http.MultipartRequest('PUT', uri);

      if (files != null) {
        int i = 0;
        for (var _file in files.entries) {
          for (var file in _file.value) {
            final multipartFile = http.MultipartFile.fromBytes(
              _file.key,
              file,
              filename: fileNames?[i],
            );

            debugPrint("File Path :-> ${fileNames?[i]}");

            request.files.add(multipartFile);
            i++;
          }
        }
      }

      if (payload != null) {
        request.fields.addAll(payload);
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse1(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (e) {
      if (kDebugMode) {
        print("Exception :-> $e");
      }
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
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

  dynamic _processResponse1(http.StreamedResponse response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(await response.stream.toBytes());
        return responseJson;
      case 400:
      case 422:
      case 409:
        throw BadRequestException(utf8.decode(await response.stream.toBytes()),
            response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(await response.stream.toBytes()),
            response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.request!.url.toString());
    }
  }
}
