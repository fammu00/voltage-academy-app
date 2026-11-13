import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:hash_code/core/services/storage/token_manger.dart';
import 'package:get/get.dart' as getx;
import '../../../routes/route_helper.dart';
import '../../constants/app_constants.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/logger.dart';
import '../storage/shared_prefs.dart';
import 'response_model.dart';
import '../../widgets/error_screen.dart';

class ApiChecker {
  static Response checkResponse(Response response, {bool showToaster = false}) {
    switch (response.statusCode) {
      case 200:
        if (response.data['res'] == 'success') {
          return response;
        } else {
          if (showToaster) _showErrorMessage(response);
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: response.data['msg'] ?? 'Something went wrong',
          );
        }
      case 401:
        _showErrorMessage(response, 'Unauthorized');
        _logout();
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Unauthorized',
        );
      case 403:
        _showErrorMessage(response, 'Forbidden');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Forbidden',
        );
      case 404:
        _showErrorMessage(response, 'Not Found');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Not Found',
        );
      case 422:
        _showValidationErrors(response);
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Validation Error',
        );
      case 500:
        _showErrorMessage(response, 'Server Error');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Server Error',
        );
      default:
        _showErrorMessage(response);
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Something went wrong',
        );
    }
  }

  static ResponseModel handleError(dynamic error, {bool showErrorScreen = false}) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Connection Timeout',
              message: 'The connection has timed out. Please try again.',
            );
          } else {
            CustomSnackbar.showError('Connection timeout');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Connection timeout',
            statusCode: 408,
          );

        case DioExceptionType.sendTimeout:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Send Timeout',
              message: 'Request sending timed out. Please try again.',
            );
          } else {
            CustomSnackbar.showError('Send timeout');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Send timeout',
            statusCode: 408,
          );

        case DioExceptionType.receiveTimeout:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Receive Timeout',
              message: 'Server response timed out. Please try again.',
            );
          } else {
            CustomSnackbar.showError('Receive timeout');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Receive timeout',
            statusCode: 408,
          );

        case DioExceptionType.badCertificate:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Security Error',
              message: 'There was a security certificate error. Please try again.',
            );
          } else {
            CustomSnackbar.showError('Bad certificate');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Bad certificate',
            statusCode: 495,
          );

        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            CustomSnackbar.showError('Session expired. Please login again.');
            _logout();
            return const ResponseModel(
              isSuccess: false,
              message: 'Unauthorized',
              statusCode: 401,
            );
          }

          if (error.response?.data != null) {
            try {
              final responseModel = ResponseModel.fromJson(
                error.response!.data,
                statusCode: error.response!.statusCode,
              );

              if (showErrorScreen) {
                _showErrorScreen(
                  title: 'Error',
                  message: responseModel.errors != null && responseModel.errors!.isNotEmpty
                      ? responseModel.errors!.first.message ?? responseModel.message
                      : responseModel.message,
                );
              } else {
                if (responseModel.errors != null && responseModel.errors!.isNotEmpty) {
                  CustomSnackbar.showError(
                    responseModel.errors!.first.message ?? 'Something went wrong',
                  );
                } else {
                  CustomSnackbar.showError(responseModel.message);
                }
              }

              return responseModel;
            } catch (e) {
              if (showErrorScreen) {
                _showErrorScreen(
                  title: 'Error',
                  message: 'Something went wrong. Please try again.',
                );
              } else {
                CustomSnackbar.showError('Something went wrong');
              }
              return ResponseModel(
                isSuccess: false,
                message: 'Something went wrong',
                statusCode: error.response?.statusCode,
              );
            }
          } else {
            if (showErrorScreen) {
              _showErrorScreen(
                title: 'Bad Response',
                message: 'Received an invalid response from server.',
              );
            } else {
              CustomSnackbar.showError('Bad response');
            }
            return ResponseModel(
              isSuccess: false,
              message: 'Bad response',
              statusCode: error.response?.statusCode,
            );
          }

        case DioExceptionType.cancel:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Request Cancelled',
              message: 'The request was cancelled.',
            );
          } else {
            CustomSnackbar.showError('Request cancelled');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Request cancelled',
            statusCode: 499,
          );

        case DioExceptionType.connectionError:
        // Don't show error screen for connection errors,
        // NoInternetScreen handles this
          CustomSnackbar.showError('No internet connection');
          return const ResponseModel(
            isSuccess: false,
            message: 'No internet connection',
          );

        case DioExceptionType.unknown:
          if (showErrorScreen) {
            _showErrorScreen(
              title: 'Unknown Error',
              message: 'An unexpected error occurred. Please try again.',
            );
          } else {
            CustomSnackbar.showError('Something went wrong');
          }
          return const ResponseModel(
            isSuccess: false,
            message: 'Something went wrong',
            statusCode: 500,
          );
      }

      Logger.e('DioError: ${error.message}');
    } else {
      Logger.e('Error: $error');
      if (showErrorScreen) {
        _showErrorScreen(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
        );
      } else {
        CustomSnackbar.showError('Something went wrong');
      }
    }

    return const ResponseModel(
      isSuccess: false,
      message: 'Something went wrong',
      statusCode: 500,
    );
  }

  static ResponseModel checkApi(Response response, {bool showToaster = false}) {
    final statusCode = response.statusCode ?? 500;

    if (statusCode == 401) {
      if (showToaster) {
        CustomSnackbar.showError('Session expired. Please login again.');
      }
      _logout();
      return const ResponseModel(
        isSuccess: false,
        message: 'Unauthorized',
        statusCode: 401,
      );
    }

    if (statusCode != 200) {
      if (response.data != null) {
        try {
          final responseModel = ResponseModel.fromJson(response.data, statusCode: statusCode);

          if (showToaster) {
            if (responseModel.errors != null && responseModel.errors!.isNotEmpty) {
              CustomSnackbar.showError(
                responseModel.errors!.first.message ?? 'Something went wrong',
              );
            } else {
              CustomSnackbar.showError(responseModel.message);
            }
          }

          return responseModel;
        } catch (e) {
          if (showToaster) {
            CustomSnackbar.showError('Something went wrong');
          }
          return ResponseModel(
            isSuccess: false,
            message: 'Something went wrong',
            statusCode: statusCode,
          );
        }
      } else {
        if (showToaster) {
          CustomSnackbar.showError('Something went wrong');
        }
        return ResponseModel(
          isSuccess: false,
          message: 'Something went wrong',
          statusCode: statusCode,
        );
      }
    }

    if (response.data is Map && (response.data['res']?.toString().toLowerCase() != 'success')) {
      final message = response.data['msg']?.toString() ?? 'Something went wrong';
      if (showToaster) CustomSnackbar.showError(message);

      return ResponseModel(
        isSuccess: false,
        message: message,
        body: response.data['data'],
        statusCode: statusCode,
      );
    }

    return ResponseModel.fromJson(response.data, statusCode: statusCode);
  }

  static void _showErrorMessage(Response response, [String? defaultMessage]) {
    final message = response.data['msg'] ?? defaultMessage ?? 'Something went wrong';
    CustomSnackbar.showError(message);
  }

  static void _showValidationErrors(Response response) {
    if (response.data != null) {
      try {
        final responseModel = ResponseModel.fromJson(response.data, statusCode: response.statusCode);
        if (responseModel.errors != null && responseModel.errors!.isNotEmpty) {
          CustomSnackbar.showError(responseModel.errors!.first.message ?? 'Validation Error');
        } else if (response.data['msg'] != null) {
          CustomSnackbar.showError(response.data['msg']);
        } else {
          CustomSnackbar.showError('Validation Error');
        }
      } catch (e) {
        if (response.data['msg'] != null) {
          CustomSnackbar.showError(response.data['msg']);
        } else {
          CustomSnackbar.showError('Validation Error');
        }
      }
    } else {
      CustomSnackbar.showError('Validation Error');
    }
  }

  static void _showErrorScreen({
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    getx.Get.to(
          () => ErrorScreen(
        title: title,
        message: message,
        onRetry: onRetry ?? () => getx.Get.back(),
        showBackButton: true,
      ),
    );
  }

  static void _logout() {
    SharedPrefs.remove(AppConstants.userData);
    SharedPrefs.setBool(AppConstants.isLoggedIn, false);
    TokenManager.clearToken();
    getx.Get.offAllNamed(RouteHelper.getSplashRoute());
  }
}