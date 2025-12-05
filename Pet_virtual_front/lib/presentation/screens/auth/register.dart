import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController(); 
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  // Animaciones
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores de animación
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Configurar animaciones
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Iniciar animaciones
    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _registerUser() async {
    // Validación de campos vacíos
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _petNameController.text.isEmpty) {
      showErrorDialog(
        context: context,
        title: 'Campos requeridos',
        message: 'Por favor completa todos los campos',
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showErrorDialog(
        context: context,
        title: 'Contraseñas no coinciden',
        message: 'Las contraseñas deben ser iguales',
      );
      return;
    }

    final password = _passwordController.text;

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

    setState(() => _isLoading = true);

    try {
      final user = UserRegister(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        petName: _petNameController.text,
      );
      
      final authService = AuthService();
      final response = await authService.register(user);

      if (response['success'] == true) {
        if (mounted) {
          showSuccessDialog(
            context: context,
            title: 'Éxito',
            message: response['message'] ?? 'Cuenta registrada con éxito',
          );
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
        }
      } else {
        if (mounted) {
          showErrorDialog(
            context: context,
            title: 'Error',
            message: response['error'] ?? 'Error en el registro',
          );
        }
      }
    } catch (e) {
     
      if (mounted) {
        showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Ocurrió un error inesperado: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Calcula tamaños responsive basados en la pantalla
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isTablet) {
      return baseSize * 1.2; // 20% más grande en tablets
    } else if (isLandscape) {
      return baseSize * 0.9; // 10% más pequeño en landscape
    } else {
      return baseSize * (screenWidth / 375); // Basado en iPhone X (375px)
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

  double _getResponsiveImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isTablet) {
      return screenWidth * 0.3;
    } else if (isLandscape) {
      return screenWidth * 0.30; 
    } else {
      return screenWidth * 0.5; 
    }
  }

  /// Campo de texto estilizado
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
    bool isPassword = false,
    bool isConfirmPassword = false, 
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
        obscureText: isPassword 
            ? (isConfirmPassword ? _obscureConfirmText : _obscureText)
            : false,
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
              (isConfirmPassword ? _obscureConfirmText : _obscureText) 
                  ? Icons.visibility_off 
                  : Icons.visibility,
              color: Colors.black, 
              size: _getResponsiveFontSize(context, 20),
            ),
            onPressed: () {
              setState(() {
                if (isConfirmPassword) {
                  _obscureConfirmText = !_obscureConfirmText;
                } else {
                  _obscureText = !_obscureText;
                }
              });
            },
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

  Widget _buildHeader(BuildContext context, bool isKeyboardVisible) {
    return Container(
      width: double.infinity, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isKeyboardVisible) ...[
            SizedBox(
              width: _getResponsiveImageSize(context),
              height: _getResponsiveImageSize(context),
              child: Transform.rotate(
                angle: 0.1,
                child: Image.asset(
                  'assets/images/registro.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: _getResponsiveSpacing(context, 10)),
          ],
          
          
          Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center, 
              children: [
                Text(
                  'CREAR CUENTA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ComicNeue', 
                    fontWeight: FontWeight.w800,
                    fontSize: _getResponsiveFontSize(
                      context, 
                      isKeyboardVisible ? 36 : 38 
                    ),
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth= 4
                      ..color = Colors.white,
                    letterSpacing: 1.2,
                    height: 1.1,
                  ),
                ),
                Text(
                  'CREAR CUENTA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontWeight: FontWeight.w800,
                    fontSize: _getResponsiveFontSize(
                      context, 
                      isKeyboardVisible ? 36 : 38
                    ),
                    color: const Color(0xFFE52E2E), 
                    letterSpacing: 1.2,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInset > 0; 
    
    final maxWidth = isTablet ? 500.0 : screenWidth;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      
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
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, 
                          children: [
                           
                            Container(
                              width: double.infinity,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SizeTransition(
                                      sizeFactor: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildHeader(context, isKeyboardVisible),
                              ),
                            ),
                            
                            SizedBox(height: _getResponsiveSpacing(context, isKeyboardVisible ? 15 : 20)),

                            // Campos de formulario
                            Column(
                              children: [
                                _buildStyledTextField(
                                  controller: _nameController,
                                  label: 'Nombre',
                                  icon: Icons.person_outline,
                                  context: context,
                                ),
                                SizedBox(height: _getResponsiveSpacing(context, 14)),
                                _buildStyledTextField(
                                  controller: _emailController,
                                  label: 'Correo electrónico',
                                  icon: Icons.email,
                                  context: context,
                                ),
                                SizedBox(height: _getResponsiveSpacing(context, 14)),
                                _buildStyledTextField(
                                  controller: _passwordController,
                                  label: 'Contraseña',
                                  icon: Icons.lock,
                                  context: context,
                                  isPassword: true,
                                ),
                                SizedBox(height: _getResponsiveSpacing(context, 14)),
                                _buildStyledTextField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirmar contraseña',
                                  icon: Icons.lock_outline,
                                  context: context,
                                  isPassword: true,
                                  isConfirmPassword: true,
                                ),
                                SizedBox(height: _getResponsiveSpacing(context, 14)),
                                _buildStyledTextField(
                                  controller: _petNameController,
                                  label: 'Nombre mascota',
                                  icon: Icons.pets,
                                  context: context,
                                ),
                              ],
                            ),
                            SizedBox(height: _getResponsiveSpacing(context, 40)),
                            
                            // Botón de registro
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
                                  onTap: _isLoading ? null : _registerUser,
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
                                            'REGISTRARSE',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: _getResponsiveFontSize(context, 20),
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: _getResponsiveSpacing(context, 7)),

                            // Botón de login
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: _getResponsiveFontSize(context, 14),
                                    color: Colors.black,
                                  ),
                                  children: [
                                    const TextSpan(text: ' ¿Ya tienes cuenta? '),
                                    TextSpan(
                                      text: 'Inicia sesión',
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _petNameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}