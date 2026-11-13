import 'dart:io';
import 'package:dio/dio.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:hash_code/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../storage/token_manger.dart';
import 'api_checker.dart';
import 'multipart.dart';
import 'network_info.dart';
import '../../widgets/no_internet_screen.dart';
import 'response_model.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String token = await TokenManager.getToken() ?? "";
        options.headers["Authorization"] = "Bearer $token";
        options.headers["Content-Type"] = "application/json";

        // Detailed request logging
        Logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        Logger.d('|🌐 API REQUEST');
        Logger.d('|📍 URL: ${options.baseUrl}${options.path}');
        Logger.d('|🔧 Method: ${options.method}');
        Logger.d('|🔑 Token: ${token.isNotEmpty ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "No Token"}');
        Logger.d('|📋 Headers: ${options.headers}');
        if (options.queryParameters.isNotEmpty) {
          Logger.d('|🔍 Query Parameters: ${options.queryParameters}');
        }
        if (options.data != null) {
          Logger.d('|📦 Body: ${options.data}');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Detailed response logging
        Logger.d('|✅ API RESPONSE');
        Logger.d('|📍 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
        Logger.d('|📊 Status Code: ${response.statusCode}');
        Logger.d('|📨 Response: ${response.data}');
        Logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        return handler.next(response);
      },
      onError: (error, handler) {
        // Detailed error logging
        Logger.e('|❌ API ERROR');
        Logger.e('|📍 URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
        Logger.e('|🔧 Method: ${error.requestOptions.method}');
        Logger.e('|⚠️ Error Type: ${error.type}');
        Logger.e('|💬 Error Message: ${error.message}');
        if (error.response != null) {
          Logger.e('|📊 Status Code: ${error.response?.statusCode}');
          Logger.e('|📨 Response: ${error.response?.data}');
        }
        Logger.e('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        return handler.next(error);
      },
    ));
  }

  Future<bool> _checkInternetConnection({bool showDialog = false}) async {
    final isConnected = await NetworkInfo.checkConnectivity();
    if (!isConnected && showDialog) {
      Get.to(() => const NoInternetScreen());
    }
    return isConnected;
  }

  Future<ResponseModel> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool handleError = AppConstants.handleError,
        bool showToaster = AppConstants.showToaster,
        bool showErrorScreen = AppConstants.isHandleErrorScreen,
        bool showInternetScreen = AppConstants.isHandleInternetScreen,
      }) async {

    if (showInternetScreen && !(await _checkInternetConnection(showDialog: showInternetScreen))) {
      return const ResponseModel(isSuccess: false, message: 'No internet connection');
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (handleError) {
        final result = ApiChecker.checkResponse(response, showToaster: showToaster);
        return ResponseModel.fromJson(result.data, statusCode: result.statusCode);
      } else {
        return ApiChecker.checkApi(response, showToaster: showToaster);
      }
    } catch (e) {
      return ApiChecker.handleError(e, showErrorScreen: showErrorScreen);
    }
  }

  Future<ResponseModel> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool handleError = AppConstants.handleError,
        bool showToaster = AppConstants.showToaster,
        bool showErrorScreen = AppConstants.isHandleErrorScreen,
        bool showInternetScreen = AppConstants.isHandleInternetScreen,
      }) async {
    if (showInternetScreen && !(await _checkInternetConnection(showDialog: showInternetScreen))) {
      return const ResponseModel(isSuccess: false, message: 'No internet connection');
    }

    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (handleError) {
        final result = ApiChecker.checkResponse(response, showToaster: showToaster);
        return ResponseModel.fromJson(result.data, statusCode: result.statusCode);
      } else {
        return ApiChecker.checkApi(response, showToaster: showToaster);
      }
    } catch (e) {
      return ApiChecker.handleError(e, showErrorScreen: showErrorScreen);
    }
  }

  Future<ResponseModel> postMultipartData(
      String path,
      Map<String, String> body,
      List<MultipartBody> multipartBody,
      List<MultipartDocument> otherFile, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool fromChat = false,
        bool handleError = AppConstants.handleError,
        bool showToaster = AppConstants.showToaster,
        bool showErrorScreen = AppConstants.isHandleErrorScreen,
        bool showInternetScreen = AppConstants.isHandleInternetScreen,
      }) async {
    if (showInternetScreen && !(await _checkInternetConnection(showDialog: showInternetScreen))) {
      return const ResponseModel(isSuccess: false, message: 'No internet connection');
    }

    try {
      Logger.d('ApiClient() => POST Multipart request: $path');

      dio.FormData formData = dio.FormData();

      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (kIsWeb) {
            List<int> bytes = await multipart.file!.readAsBytes();
            formData.files.add(MapEntry(
              multipart.key,
              dio.MultipartFile.fromBytes(
                bytes,
                filename: basename(multipart.file!.path),
                contentType: MediaType('image', 'jpg'),
              ),
            ));
          } else {
            File file = File(multipart.file!.path);
            formData.files.add(MapEntry(
              multipart.key,
              await dio.MultipartFile.fromFile(file.path, filename: basename(file.path)),
            ));
          }
        }
      }

      if (otherFile.isNotEmpty) {
        for (MultipartDocument file in otherFile) {
          if (kIsWeb) {
            if (fromChat) {
              PlatformFile platformFile = file.file!.files.first;
              formData.files.add(MapEntry(
                'image[]',
                dio.MultipartFile.fromBytes(platformFile.bytes!, filename: platformFile.name),
              ));
            } else {
              var fileBytes = file.file!.files.first.bytes!;
              formData.files.add(MapEntry(
                file.key,
                dio.MultipartFile.fromBytes(fileBytes, filename: file.file!.files.first.name),
              ));
            }
          } else {
            File other = File(file.file!.files.single.path!);
            formData.files.add(MapEntry(
              file.key,
              await dio.MultipartFile.fromFile(other.path, filename: basename(other.path)),
            ));
          }
        }
      }

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Logger.d('ApiClient() => POST Multipart response: ${response.data}');

      if (handleError) {
        final result = ApiChecker.checkResponse(response, showToaster: showToaster);
        return ResponseModel.fromJson(result.data, statusCode: result.statusCode);
      } else {
        return ApiChecker.checkApi(response, showToaster: showToaster);
      }
    } catch (e) {
      Logger.e('ApiClient() => POST Multipart error: $e');
      return ApiChecker.handleError(e, showErrorScreen: showErrorScreen);
    }
  }

  Future<ResponseModel> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool handleError = AppConstants.handleError,
        bool showToaster = AppConstants.showToaster,
        bool showErrorScreen = AppConstants.isHandleErrorScreen,
        bool showInternetScreen = AppConstants.isHandleInternetScreen,
      }) async {
    if (showInternetScreen && !(await _checkInternetConnection(showDialog: showInternetScreen))) {
      return const ResponseModel(isSuccess: false, message: 'No internet connection');
    }

    try {
      Logger.d('ApiClient() => PUT request: $path, data: $data');
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      Logger.d('ApiClient() => PUT response: ${response.data}');

      if (handleError) {
        final result = ApiChecker.checkResponse(response, showToaster: showToaster);
        return ResponseModel.fromJson(result.data, statusCode: result.statusCode);
      } else {
        return ApiChecker.checkApi(response, showToaster: showToaster);
      }
    } catch (e) {
      Logger.e('ApiClient() => PUT error: $e');
      return ApiChecker.handleError(e, showErrorScreen: showErrorScreen);
    }
  }

  Future<ResponseModel> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        bool handleError = AppConstants.handleError,
        bool showToaster = AppConstants.showToaster,
        bool showErrorScreen = AppConstants.isHandleErrorScreen,
        bool showInternetScreen = AppConstants.isHandleInternetScreen,
      }) async {
    if (showInternetScreen && !(await _checkInternetConnection(showDialog: showInternetScreen))) {
      return const ResponseModel(isSuccess: false, message: 'No internet connection');
    }

    try {
      Logger.d('ApiClient() => DELETE request: $path');
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      Logger.d('ApiClient() => DELETE response: ${response.data}');

      if (handleError) {
        final result = ApiChecker.checkResponse(response, showToaster: showToaster);
        return ResponseModel.fromJson(result.data, statusCode: result.statusCode);
      } else {
        return ApiChecker.checkApi(response, showToaster: showToaster);
      }
    } catch (e) {
      Logger.e('ApiClient() => DELETE error: $e');
      return ApiChecker.handleError(e, showErrorScreen: showErrorScreen);
    }
  }
}
