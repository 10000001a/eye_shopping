import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dto/auth_dto.dart';
import '../../../data/repository/auth_repository.dart';
import '../../model/auth.dart';

final Provider<SignUpUseCase> signUpUseCaseProvider = Provider<SignUpUseCase>(
  (Ref ref) => SignUpUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

class SignUpUseCase {
  final AuthRepository _authRepository;

  const SignUpUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<TokenModel> call({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponseDto dto = await _authRepository.signUp(
        signUpRequestDto: SignUpRequestDto(
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
