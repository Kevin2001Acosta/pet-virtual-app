import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _loginUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showErrorDialog(
        context: context,
        title: 'Campos requeridos',
        message: 'Por favor completa todos los campos',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = UserLogin(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final authService = AuthService();
      final response = await authService.login(user);

      if (response['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: {'token': response['token']},
        );
      } else {
        if (!mounted) return;
        showErrorDialog(
          context: context,
          title: 'Error',
          message: response['error'] ?? 'Error en el inicio de sesión',
        );
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(
        context: context,
        title: 'Error',
        message: 'Ocurrió un error inesperado: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Calcula tamaños
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return baseSize * 1.2;
    } else if (isLandscape) {
      return baseSize * 0.9;
    } else {
      return baseSize * (screenWidth / 375);
    }
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      return baseSpacing * 0.7;
    } else {
      return baseSpacing * (screenHeight / 812);
    }
  }

  double _getResponsiveImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return 220;
    } else if (isLandscape) {
      return screenHeight * 0.25;
    } else {
      return screenWidth * 0.45;
    }
  }

  /// Campo de texto
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
    bool obscureText = true,
  }) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        style: TextStyle(
          fontSize: _getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: _getResponsiveFontSize(context, 16),
            color: const Color.fromARGB(137, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.black,
              size: _getResponsiveFontSize(context, 20),
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                    size: _getResponsiveFontSize(context, 20),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: isTablet ? 20 : 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 243, 84, 73),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    final maxWidth = isTablet ? 500.0 : screenWidth;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF48A8A), Color(0xFFFDEDED)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40.0 : 24.0,
                vertical: isLandscape ? 20.0 : 40.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  minHeight: screenHeight - (isLandscape ? 40 : 80),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: _getResponsiveSpacing(context, 30)),

                    // Titulo
                    Stack(
                      children: [
                        Text(
                          'Mascota virtual',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.w800,
                            fontSize: _getResponsiveFontSize(context, 38),
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.white,
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                        // Relleno rojo
                        Text(
                          'Mascota virtual',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.w800,
                            fontSize: _getResponsiveFontSize(context, 38),
                            color: const Color(0xFFE52E2E),
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 20)),

                    // Imagen
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 233, 80, 70),
                        border: Border.all(
                          color: Colors.white,
                          width: isTablet ? 6 : 5,
                        ),
                      ),
                      padding: EdgeInsets.all(isTablet ? 10 : 8),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/mascota.png',
                          width: _getResponsiveImageSize(context),
                          height: _getResponsiveImageSize(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 40)),

                    // Campos
                    _buildStyledTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      icon: Icons.email,
                      context: context,
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 16)),

                    _buildStyledTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      context: context,
                      isPassword: true,
                      obscureText: _obscureText,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 8)),

                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/forgot_password'),
                        child: Text(
                          'Recuperar contraseña',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: _getResponsiveFontSize(context, 16),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 50)),

                    // Botón de Iniciar Sesión
                    Container(
                      width: double.infinity,
                      height: isTablet ? 60 : 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 243, 84, 73),
                            Color.fromARGB(255, 229, 47, 47),
                            Color.fromARGB(255, 211, 47, 47),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 238, 163, 157).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: _isLoading ? null : _loginUser,
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: _getResponsiveFontSize(context, 20),
                                    width: _getResponsiveFontSize(context, 20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'INICIAR SESIÓN',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: _getResponsiveFontSize(
                                        context,
                                        18,
                                      ),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: _getResponsiveSpacing(context, 5)),

                    // Registrarse
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: _getResponsiveFontSize(context, 16),
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: '¿No tienes cuenta? '),
                            TextSpan(
                              text: 'Regístrate',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: _getResponsiveFontSize(context, 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
