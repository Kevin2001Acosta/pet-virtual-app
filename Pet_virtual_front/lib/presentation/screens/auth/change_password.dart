import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String token;

  const ChangePasswordScreen({super.key, required this.token});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
              size: _getResponsiveFontSize(context, 20),
            ),
            onPressed: onToggleVisibility,
          ) : null,
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ícono
        Icon(
          Icons.lock_reset,
          color: const Color.fromARGB(255, 229, 47, 47),
          size: _getResponsiveIconSize(context),
        ),
        SizedBox(height: _getResponsiveSpacing(context, 8)),

        // Título
        Stack(
          children: [
            // Borde blanco
            Text(
              'NUEVA CONTRASEÑA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontWeight: FontWeight.w800,
                fontSize: _getResponsiveFontSize(context, 30),
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
              'NUEVA CONTRASEÑA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontWeight: FontWeight.w800,
                fontSize: _getResponsiveFontSize(context, 30),
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

  Future<void> _changePassword() async {
  // Validaciones
  if (_passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty) {
    if (!mounted) return;
    showErrorDialog(
      context: context,
      title: 'Campos requeridos',
      message: 'Por favor completa todos los campos',
    );
    return;
  }


  if (_passwordController.text != _confirmPasswordController.text) {
    if (!mounted) return;
    showErrorDialog(
      context: context,
      title: 'Contraseñas no coinciden',
      message: 'Las contraseñas ingresadas no son iguales',
    );
    return;
  }

  final password = _passwordController.text;
    if (password.length < 8) {
      showErrorDialog(
        context: context,
        title: 'Contraseña muy corta',
        message: 'La contraseña debe tener al menos 8 caracteres',
      );
      return;
   }

    if (!password.contains(RegExp(r'[A-Z]'))) {
    showErrorDialog(
      context: context,
      title: 'Falta mayúscula',
      message: 'La contraseña debe contener al menos una letra mayúscula',
    );
    return;
  }

  if (!password.contains(RegExp(r'[a-z]'))) {
    showErrorDialog(
      context: context,
      title: 'Falta minúscula', 
      message: 'La contraseña debe contener al menos una letra minúscula',
    );
    return;
  }

  if (!password.contains(RegExp(r'[0-9]'))) {
    showErrorDialog(
      context: context,
      title: 'Falta número',
      message: 'La contraseña debe contener al menos un dígito',
    );
    return;
  }
  

  setState(() {
    _isLoading = true;
  });

  try {
    final result = await _authService.resetPassword(
      _passwordController.text,
      widget.token,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      
      showSuccessDialog(
        context: context,
        title: '¡Contraseña cambiada!',
        message: 'Tu contraseña ha sido actualizada exitosamente',
        onPressed: () {
          // Redireccionar al login
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login', 
            (route) => false
          );
        },
      );
    } else {
      showErrorDialog(
        context: context,
        title: 'Error',
        message: result['error'] ?? 'Error al cambiar la contraseña',
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

                    Text(
                      'Ingresa y confirma tu nueva contraseña',
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

                    // Campo de nueva contraseña
                    _buildStyledTextField(
                      controller: _passwordController,
                      label: 'Nueva contraseña',
                      icon: Icons.lock,
                      context: context,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: _getResponsiveSpacing(context, 16)),

                    // Campo de confirmar contraseña
                    _buildStyledTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar contraseña',
                      icon: Icons.lock_outline,
                      context: context,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    SizedBox(height: _getResponsiveSpacing(context, 50)),

                    // Botón de Cambiar Contraseña
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
                          onTap: _isLoading ? null : _changePassword,
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
                                    'CAMBIAR CONTRASEÑA',
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
