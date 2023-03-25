import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AuthService(super.state);

  void success() {
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void fail() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}
