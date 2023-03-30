import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/auth_dto.dart';
import '../network/auth_api.dart';

Provider<AuthRepository> authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepository(authApi: ref.watch(authApiProvider)),
);

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository({
    required AuthApi authApi,
  }) : _authApi = authApi;

  Future<AuthResponseDto> signUp({
    required SignUpRequestDto signUpRequestDto,
  }) async {
    final Map<String, dynamic> data = await _authApi.signUp(
      signUpRequestDto: signUpRequestDto,
    );

    return AuthResponseDto.fromMap(data);
  }

  Future<AuthResponseDto> signIn({
    required SignInRequestDto signInRequestDto,
  }) async {
    final Map<String, dynamic> data = await _authApi.signIn(
      signInRequestDto: signInRequestDto,
    );

    return AuthResponseDto.fromMap(data);
  }

  Future<AuthResponseDto> signInWithGoogle({
    required SignInWithGoogleRequestDto signInWithGoogleRequestDto,
  }) async {
    final dynamic data = await _authApi.signInWithGoogle(
      signInWithGoogleRequestDto: signInWithGoogleRequestDto,
    );

    return AuthResponseDto.fromMap(data);
  }

  Future<AuthResponseDto> refresh({
    required SignInRequestDto signInRequestDto,
  }) async {
    final Map<String, dynamic> data = await _authApi.refresh(
      signInRequestDto: signInRequestDto,
    );

    return AuthResponseDto.fromMap(data);
  }
}
