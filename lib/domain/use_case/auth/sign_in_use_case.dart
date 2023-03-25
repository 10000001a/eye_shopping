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

  Future<Token> call() async {
    try {
      final SignInResponseDto dto = await _authRepository.signIn(
        signInRequestDto: const SignInRequestDto(
          email: '',
          password: '',
        ),
      );

      return dto.accessToken;
    } on Exception {
      rethrow;
    }
  }
}
