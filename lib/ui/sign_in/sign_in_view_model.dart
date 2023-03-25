import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/auth.dart';
import '../../domain/service/auth_service.dart';
import '../../domain/use_case/auth/sign_in_use_case.dart';
import '../../domain/use_case/auth/sign_in_with_google_use_case.dart';

StateNotifierProvider<SignInViewModel, SignInState> signInViewModelProvider =
    StateNotifierProvider<SignInViewModel, SignInState>(
  (Ref ref) => SignInViewModel(
    authService: ref.watch(authServiceProvider.notifier),
    signInUseCase: ref.watch(signInUseCaseProvider),
    signInWithGoogleUseCase: ref.watch(signInWithGoogleUseCaseProvider),
    state: const SignInState.init(),
  ),
);

class SignInState extends Equatable {
  final String email;
  final String password;

  const SignInState({
    required this.email,
    required this.password,
  });

  const SignInState.init()
      : email = '',
        password = '';

  @override
  List<Object?> get props => <Object?>[
        email,
        password,
      ];

  SignInState copyWith({
    String? email,
    String? password,
  }) =>
      SignInState(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class SignInViewModel extends StateNotifier<SignInState> {
  final AuthService _authService;
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  SignInViewModel({
    required AuthService authService,
    required SignInUseCase signInUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInState state,
  })  : _authService = authService,
        _signInUseCase = signInUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(state);

  void onChangeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> signIn() async {
    try {
      await _signInUseCase.call();

      _authService.success();
    } on Exception {
      _authService.fail();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _signInWithGoogleUseCase.call();

      _authService.success();
    } on Exception {
      _authService.fail();
    }
  }
}
