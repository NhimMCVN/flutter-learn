class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginResponse {
  final String authToken;

  LoginResponse({required this.authToken});
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(authToken: json['authToken'] as String);
  }
}
