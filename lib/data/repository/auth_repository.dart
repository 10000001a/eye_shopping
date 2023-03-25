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

  Future<SignInResponseDto> signIn({
    required SignInRequestDto signInRequestDto,
  }) async {
    final dynamic data = await _authApi.signIn(
      signInRequestDto: signInRequestDto,
    );

    return SignInResponseDto.fromMap(data);
  }

  Future<SignInResponseDto> signInWithGoogle({
    required SignInWithGoogleRequestDto signInWithGoogleRequestDto,
  }) async {
    final dynamic data = await _authApi.signInWithGoogle(
      signInWithGoogleRequestDto: signInWithGoogleRequestDto,
    );

    return SignInResponseDto.fromMap(data);
  }
}
