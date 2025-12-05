import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/secure_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final isLoggedIn = await SecureStorageService.isLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        final token = await SecureStorageService.getToken();
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: {'token': token},
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  /// Calcula tamaños responsivos
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return baseSize * 1.3;
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
      return baseSpacing * 0.6;
    } else {
      return baseSpacing * (screenHeight / 812);
    }
  }

  double _getResponsiveImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return 220;
    } else if (isLandscape) {
      return screenHeight * 0.3;
    } else {
      return screenWidth * 0.4;
    }
  }

  double _getBorderWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return isTablet ? 6 : 4;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF48A8A),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 40.0 : 24.0,
            vertical: isLandscape ? 20.0 : 0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500.0 : screenWidth,
              minHeight: screenHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen de la mascota
                Container(
                  width: _getResponsiveImageSize(context),
                  height: _getResponsiveImageSize(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 233, 80, 70),
                    border: Border.all(
                      color: Colors.white,
                      width: _getBorderWidth(context),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/mascota.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: _getResponsiveSpacing(context, 30)),

                // Título con efecto de borde
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Texto de borde blanco
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
                    // Texto de relleno rojo
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

                SizedBox(height: _getResponsiveSpacing(context, 30)),

                // Indicador de carga
                SizedBox(
                  width: _getResponsiveFontSize(context, 24),
                  height: _getResponsiveFontSize(context, 24),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}