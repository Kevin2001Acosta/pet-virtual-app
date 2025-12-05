import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  /// Calcula tamaños 
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      return baseSpacing * 0.7; 
    } else {
      return baseSpacing * (screenHeight / 812); 
    }
  }

  double _getResponsiveIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isTablet) {
      return 120; 
    } else if (isLandscape) {
      return 70; 
    } else {
      return 80; 
    }
  }

  /// Campo de texto 
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
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
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ícono
        Icon(
          Icons.lock,
          color: Colors.red,
          size: _getResponsiveIconSize(context),
        ),
        SizedBox(height: _getResponsiveSpacing(context, 8)),
        // Título
        Stack(
          children: [
            // Borde blanco 
            Text(
              'RECUPERAR CONTRASEÑA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontWeight: FontWeight.w800,
                fontSize: _getResponsiveFontSize(context, 32),
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
              'RECUPERAR CONTRASEÑA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontWeight: FontWeight.w800,
                fontSize: _getResponsiveFontSize(context, 32),
                color: const Color(0xFFE52E2E),
                letterSpacing: 1.2,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  
 Future<void> _sendResetLink() async {
  if (_emailController.text.isEmpty) {
    if (!mounted) return; 
    showErrorDialog(
      context: context,
      title: 'Campos requeridos',
      message: 'Por favor ingresa tu correo electrónico',
    );
    return;
  }
  setState(() {
    _isLoading = true;
  });

  try {
    final result = await _authService.sendPasswordResetLink(
      _emailController.text,
    );

    if (!mounted) return; 

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      showSuccessDialog(
        context: context,
        title: 'Correo enviado',
        message: result['message'] ??
            'Se ha enviado un enlace de recuperación a tu correo electrónico.',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      showErrorDialog(
        context: context,
        title: 'Error',
        message: result['error'] ??
            'Ocurrió un error desconocido al enviar el correo',
      );
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    showErrorDialog(
      context: context,
      title: 'Error de conexión',
      message: 'No se pudo conectar con el servidor: $e',
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;
    
    final maxWidth = isTablet ? 500.0 : screenWidth;

    return Scaffold(
      body: Stack(
        children: [
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
                    _buildHeader(context),
                    SizedBox(height: _getResponsiveSpacing(context, 35)),

                    // Texto descriptivo
                    Text(
                      'Ingresa tu correo electrónico para restablecer tu acceso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: _getResponsiveFontSize(context, 16),
                        color: const Color.fromARGB(255, 0, 0, 0),
                        letterSpacing: 1.0,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: _getResponsiveSpacing(context, 20)),

                    // Campo de email
                    _buildStyledTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      icon: Icons.email,
                      context: context,
                    ),
                    SizedBox(height: _getResponsiveSpacing(context, 50)),

                    // Botón de Recuperar
                    Container(
                      width: double.infinity,
                      height: isTablet ? 60 : 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(255, 243, 84, 73),
                            const Color.fromARGB(255, 229, 47, 47),
                            const Color.fromARGB(255, 211, 47, 47),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 243, 84, 73).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: _isLoading ? null : _sendResetLink,
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: _getResponsiveFontSize(context, 20),
                                    width: _getResponsiveFontSize(context, 20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'ENVIAR ENLACE',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: _getResponsiveFontSize(context, 18),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _getResponsiveSpacing(context, 24)),
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