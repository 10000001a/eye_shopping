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

class SignInResponseDto {
  final String accessToken;

  const SignInResponseDto({
    required this.accessToken,
  });

  factory SignInResponseDto.fromMap(Map<String, dynamic> map) =>
      SignInResponseDto(
        accessToken: map['accessToken'] as String,
      );
}
