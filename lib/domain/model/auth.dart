typedef Token = String;

class TokenModel {
  final Token accessToken;
  final Token refreshToken;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
  });
}
