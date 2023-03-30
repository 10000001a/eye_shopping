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

  Future<dynamic> signUp({
    required SignUpRequestDto signUpRequestDto,
  }) async {
    try {
      print('a');

      final Response<dynamic> response = await _dio.post(
        'auth/signup',
        data: signUpRequestDto.toMap(),
      );

      print(response.toString());

      print('b');
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  Future<dynamic> signIn({
    required SignInRequestDto signInRequestDto,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/auth/signin',
        data: signInRequestDto.toMap(),
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

  Future<dynamic> refresh({
    required SignInRequestDto signInRequestDto,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/auth/reissue',
        data: signInRequestDto,
      );

      return response.data;
    } on DioError {
      rethrow;
    }
  }
}
