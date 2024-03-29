import 'package:flutter/foundation.dart';

class LoginResponse with ChangeNotifier {
  final String token_type;
  final int expires_in;
  final String access_token;
  final String refresh_token;

  LoginResponse({
    required this.token_type,
    required this.expires_in,
    required this.access_token,
    required this.refresh_token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> parsedJson) {
    return LoginResponse(
      token_type: parsedJson['token_type'],
      expires_in: parsedJson['expires_in'],
      access_token: parsedJson['access_token'],
      refresh_token: parsedJson['refresh_token'],
    );
  }
}
