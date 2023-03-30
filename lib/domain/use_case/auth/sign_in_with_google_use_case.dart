import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dto/auth_dto.dart';
import '../../../data/repository/auth_repository.dart';
import '../../model/auth.dart';

final Provider<SignInWithGoogleUseCase> signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>(
  (Ref ref) => SignInWithGoogleUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  const SignInWithGoogleUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<TokenModel> call() async {
    try {
      final AuthResponseDto dto = await _authRepository.signInWithGoogle(
        signInWithGoogleRequestDto: const SignInWithGoogleRequestDto(
          token: '',
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
