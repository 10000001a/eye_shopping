import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dto/auth_dto.dart';
import '../../../data/repository/auth_repository.dart';
import '../../model/auth.dart';

final Provider<SignInUseCase> signInUseCaseProvider = Provider<SignInUseCase>(
  (Ref ref) => SignInUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

class SignInUseCase {
  final AuthRepository _authRepository;

  const SignInUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<TokenModel> call({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponseDto dto = await _authRepository.signIn(
        signInRequestDto: SignInRequestDto(
          email: email,
          password: password,
        ),
      );

      return TokenModel(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      );
    } on Exception {
      rethrow;
    }
  }
}
