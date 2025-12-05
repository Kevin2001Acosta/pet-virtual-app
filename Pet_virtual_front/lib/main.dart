import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/config/theme/app_theme.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/screens/auth/splash_screen.dart';
import 'package:yes_no_app/presentation/screens/chat/chat_screen.dart';
import 'package:yes_no_app/presentation/screens/auth/login.dart';
import 'package:yes_no_app/presentation/screens/auth/register.dart';
import 'package:yes_no_app/presentation/screens/auth/forgot_password.dart';
import 'package:yes_no_app/presentation/screens/auth/change_password.dart';
import 'package:yes_no_app/presentation/screens/chat/bienestar_emocional.dart';

import 'dart:async';
import 'package:app_links/app_links.dart';

void main() => runApp(
  MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
    child: const MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  final AppLinks _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _listenToLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      // getInitialLinkUri es el nuevo método para obtener enlace inicial
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _onAppLink(initialUri, coldStart: true);
      }
    } catch (e) {
      debugPrint('Error al obtener enlace inicial: $e');
      // Puedes capturar o ignorar según lo consideres
    }
  }

  void _listenToLinks() {
    _sub = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _onAppLink(uri, coldStart: false);
      },
      onError: (err) {
        debugPrint('Error en uriLinkStream: $err');
      },
    );
  }

  void _onAppLink(Uri uri, {required bool coldStart}) {
    debugPrint('Received link (coldStart=$coldStart): $uri');
    debugPrint(uri.scheme);
    debugPrint(uri.host);
    debugPrint(uri.queryParameters.toString());
    //debugPrint((uri.scheme == 'mychatbot').toString());
    debugPrint((uri.host == 'changepassword').toString());

    // Verifica esquema y host
    if (uri.scheme == 'mychatbot' && uri.host == 'changepassword') {
      debugPrint('Navegando a cambiar contraseña');
      final token = uri.queryParameters['token'];
      if (token != null) {
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/changePassword',
          (route) => false,
          arguments: {'token': token},
        );
      }
    }
    // Aquí puedes manejar más hosts/rutas si necesitas
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Mascota Virtual',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        home: SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/chat': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>?;
            final token = args?['token'] ?? '';
            return ChatScreen(token: token);
          },
          '/forgot_password': (context) => const ForgotScreen(),
          '/changePassword': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>?;
            final token = args?['token'] ?? '';
            return ChangePasswordScreen(token: token);
          },
          '/emotional_wellness': (context) => BienestarEmocionalScreen(),
        },
      ),
    );
  }
}
