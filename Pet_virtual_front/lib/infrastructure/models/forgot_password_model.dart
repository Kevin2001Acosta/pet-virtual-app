//Modelo recuperar contraseña
class ForgotPassword {
  final String email;

  ForgotPassword({required this.email});

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}

//Modelo de codigo para recuperar contraseña
class ForgotPasswordCode{
  final bool success;
  final String message;
  final String? resetToken;

  ForgotPasswordCode({
    required this.success,
    required this.message,
    this.resetToken,
  });

  factory ForgotPasswordCode.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordCode(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Error desconocido',
      resetToken: json['resetToken'],
    );
  }
}
