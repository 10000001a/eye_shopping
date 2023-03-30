import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth.dart';

StateNotifierProvider<AuthService, AuthState> authServiceProvider =
    StateNotifierProvider<AuthService, AuthState>(
  (Ref ref) => AuthService(const AuthState.init()),
);

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState({
    required this.status,
  });

  const AuthState.init({
    this.status = AuthStatus.unknown,
  });

  @override
  List<Object?> get props => <Object?>[status];

  AuthState copyWith({
    AuthStatus? status,
  }) =>
      AuthState(
        status: status ?? this.status,
      );
}

class AuthService extends StateNotifier<AuthState> {
  late final SharedPreferences _sharedPreferences;

  AuthService(super.state) {
    init();
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> success({
    required TokenModel tokenModel,
  }) async {
    await _sharedPreferences.setString(
      'access_token',
      tokenModel.accessToken,
    );
    await _sharedPreferences.setString(
      'refresh_token',
      tokenModel.refreshToken,
    );

    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void fail() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}
