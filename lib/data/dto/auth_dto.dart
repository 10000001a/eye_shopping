class SignUpRequestDto {
  final String email;
  final String password;

  const SignUpRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
        'password': password,
      };
}

class SignInRequestDto {
  final String email;
  final String password;

  const SignInRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
        'password': password,
      };
}

class SignInWithGoogleRequestDto {
  final String token;

  const SignInWithGoogleRequestDto({
    required this.token,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'token': token,
      };
}

class AuthResponseDto {
  final String accessToken;
  final String refreshToken;

  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseDto.fromMap(Map<String, dynamic> map) => AuthResponseDto(
        accessToken: map['accessToken'] as String,
        refreshToken: map['refreshToken'] as String,
      );
}
