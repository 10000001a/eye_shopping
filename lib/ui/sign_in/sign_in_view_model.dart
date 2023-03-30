import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/auth.dart';
import '../../domain/service/auth_service.dart';
import '../../domain/use_case/auth/sign_in_use_case.dart';
import '../../domain/use_case/auth/sign_in_with_google_use_case.dart';
import '../../domain/use_case/auth/sign_up_use_case.dart';

StateNotifierProvider<SignInViewModel, SignInState> signInViewModelProvider =
    StateNotifierProvider<SignInViewModel, SignInState>(
  (Ref ref) => SignInViewModel(
    authService: ref.watch(authServiceProvider.notifier),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
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
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;

  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  SignInViewModel({
    required AuthService authService,
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignInState state,
  })  : _authService = authService,
        _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(state);

  void onChangeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> signUp() async {
    try {
      final TokenModel tokenModel = await _signUpUseCase.call(
        // email: state.email,
        // password: state.password,
        email: 'test@test.com',
        password: 'test',
      );

      await _authService.success(tokenModel: tokenModel);
    } on Exception {
      _authService.fail();
    }
  }

  Future<void> signIn() async {
    try {
      final TokenModel tokenModel = await _signInUseCase.call(
        // email: state.email,
        // password: state.password,
        email: 'test@test.com',
        password: 'test',
      );

      await _authService.success(tokenModel: tokenModel);
    } on Exception {
      _authService.fail();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final TokenModel tokenModel = await _signInWithGoogleUseCase.call();

      await _authService.success(tokenModel: tokenModel);
    } on Exception {
      _authService.fail();
    }
  }
}
