import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/dio_client.dart';
import '../dto/auth_dto.dart';

Provider<AuthApi> authApiProvider = Provider<AuthApi>(
  (Ref ref) => AuthApi(
    dio: DioClient(),
  ),
);

class AuthApi {
  final DioClient _dio;

  AuthApi({
    required DioClient dio,
  }) : _dio = dio;

  Future<dynamic> signIn({
    required SignInRequestDto signInRequestDto,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/auth/sign-in',
        data: signInRequestDto,
      );

      return response.data;
    } on DioError {
      rethrow;
    }
  }

  Future<dynamic> signInWithGoogle({
    required SignInWithGoogleRequestDto signInWithGoogleRequestDto,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/auth/sign-in-with-google',
        data: signInWithGoogleRequestDto,
      );

      return response.data;
    } on DioError {
      rethrow;
    }
  }
}
