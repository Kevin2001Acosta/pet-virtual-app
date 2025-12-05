import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';
import 'package:yes_no_app/presentation/screens/chat/mascota_animation.dart';
import '../../../domain/entities/message.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';

class ChatScreen extends StatefulWidget {
  final String token;
  
  const ChatScreen({super.key, required this.token});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _loading = false; 

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(  
      builder: (context, chatProvider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, chatProvider), 
          body: _ChatView(token: widget.token),
        );
      },
    );
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), 
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción Cerrar Sesión
            ListTile(
              leading: const Icon(
                Icons.exit_to_app_rounded,
                color: Color(0xFFF35449),
              ),
              title: const Text(
                'Cerrar sesión', 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context); 
                _showLogoutDialog(context);
              },
            ),
            
            Divider(height: 1, color: Colors.grey[300]),
            
            // Opción Eliminar Cuenta
            ListTile(
              leading: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
              ),
              title: const Text(
                'Eliminar cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context); 
                _showDeleteAccountDialog(context);
              },
            ),
            
            Divider(height: 1, color: Colors.grey[300]),

            // Opción Limpiar Chat
            ListTile(
              leading: const Icon(
                Icons.cleaning_services_rounded,
                color: Colors.blue,
              ),
              title: const Text(
                'Limpiar chat',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                 _showClearChatDialog(context);
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// AppBar 
  PreferredSizeWidget _buildAppBar(BuildContext context, ChatProvider chatProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final toolbarHeight = isLandscape ? 90.0 : (isTablet ? 110.0 : 100.0);
    final titleFontSize = isTablet ? 24.0 : (isLandscape ? 16.0 : 20.0);
    final subtitleFontSize = isTablet ? 16.0 : (isLandscape ? 12.0 : 14.0);
    final iconSize = isTablet ? 22.0 : (isLandscape ? 18.0 : 20.0);

    return AppBar(
      backgroundColor: const Color(0xFFF35449),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(77),
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withAlpha(77),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        tooltip: 'Menú de opciones',
        onPressed: () => _showMenuOptions(context),
      ),
      title: _buildAppBarContent(
        context,
        chatProvider,
        titleFontSize,
        subtitleFontSize,
        isTablet,
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: isTablet ? 12.0 : 8.0),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(77),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: iconSize * 1.3,
              ),
            ),
            tooltip: 'Bienestar emocional',
            onPressed: () {
              Navigator.pushNamed(context, '/emotional_wellness');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarContent(
    BuildContext context,
    ChatProvider chatProvider,
    double titleFontSize,
    double subtitleFontSize,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: titleFontSize * 1.2,
            ),
            const SizedBox(width: 8),
            Text(
              chatProvider.petName,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withAlpha(128),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'En línea', 
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(242),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red),
            SizedBox(width: 8),
            Text('Eliminar cuenta'),
          ],
        ),
        content: const Text('¿Estás seguro de que quieres eliminar tu cuenta permanentemente? Esta acción no se puede deshacer y se perderán todos tus datos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _executeDeleteAccount(context),
            child: const Text('Eliminar cuenta'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cleaning_services_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Text('Limpiar chat'),
          ],
        ),
        content: const Text('¿Estás seguro de que quieres limpiar todo el historial del chat? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _executeClearChat(context),
            child: const Text('Limpiar chat'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Future<void> _executeDeleteAccount(BuildContext context) async {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
   
    rootNavigator.pop(); 

    setState(() => _loading = true);
    showDialog(
      context: rootNavigator.context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFF35449)),
      ),
    );

    try {      final authService = AuthService();
      final result = await authService.deleteAccount().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Intenta nuevamente.');
        },
      );

      if (result['success'] != true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Error al eliminar la cuenta'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        rootNavigator.pop();
        if (mounted) {
          rootNavigator.pushNamedAndRemoveUntil('/login', (route) => false); 
        }
      }
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/login', 
      (route) => false
    );
  }
 
  void _showLogoutDialog(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Color(0xFFF35449)),
            SizedBox(width: 8),
            Text('Cerrar sesión'),
          ],
        ),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {
              rootNavigator.pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF35449),
            ),
            onPressed: () {
              rootNavigator.pop();
              Future.delayed(Duration.zero, () async {
                try {
                  final authService = AuthService();
                  await authService.logout();
                  _navigateToLogin(context); 
                } catch (e) {
                  _navigateToLogin(context); 
                }
              });
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _executeClearChat(BuildContext context) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );

    try {
      final chatService = GetIAAnswer();
      final result = await chatService.clearChat(widget.token);

      if (mounted) navigator.pop(); 

      if (result['success'] == true) {
        if (mounted) {
          final chatProvider = Provider.of<ChatProvider>(context, listen: false);
          chatProvider.clearMessages(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Chat limpiado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Error al limpiar el chat'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && navigator.canPop()) navigator.pop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ChatView extends StatefulWidget {
  final String token;
  const _ChatView({required this.token});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  bool _loading = true;
  bool _sessionExpiredDialogShown = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _focusNode.addListener(_onKeyboardChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onKeyboardChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyboardChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.scrollToBottom(animated: true);
        }
      });
    }
  }

  Future<void> _loadMessages() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadMessages(widget.token);

    if (mounted && chatProvider.sessionExpired && !_sessionExpiredDialogShown) {
      _showSessionExpiredDialog();
    } else if (mounted) {
      setState(() => _loading = false);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatProvider.scrollToBottom(animated: false);
      });
    }
  }
  
  void _showSessionExpiredDialog() {
    _sessionExpiredDialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.access_time, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text(
              'Sesión expirada',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Tu sesión ha expirado por seguridad. Por favor, inicia sesión nuevamente para continuar.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF87070),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.pushReplacementNamed(context, '/login'); 
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      ),
    );
  }

  double _getMascotaSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    if (isLandscape) {
      return (screenHeight * 0.25).clamp(80.0, 120.0);
    } else if (isTablet) {
      return 180;
    } else {
      return (screenWidth * 0.4).clamp(120.0, 160.0);
    }
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return const EdgeInsets.all(20);
    } else if (isLandscape) {
      return const EdgeInsets.all(8);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    if (keyboardHeight > 0 && chatProvider.messageList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          chatProvider.scrollToBottom(animated: true);
        }
      });
    }
    
    if (chatProvider.sessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final maxWidth = isTablet ? 800.0 : screenWidth;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, 
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                // Mascota animada
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    final mascotaSize = _getMascotaSize(context);
                    final padding = _getResponsivePadding(context);
                    return Container(
                      padding: padding,
                      child: Container(
                        height: mascotaSize + 40,
                        width: mascotaSize + 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.red,
                            width: isTablet ? 4 : 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(51),
                              blurRadius: isTablet ? 12 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: MascotaAnimation(
                            isSpeaking: chatProvider.isLoading,
                            currentEmotion: chatProvider.currentEmotion,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: _loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color(0xFFF87070),
                                    ),
                                    strokeWidth: isTablet ? 3 : 2,
                                  ),
                                )
                              : _buildMessageList(chatProvider, isTablet),
                        ),

                        // Campo de texto
                        SingleChildScrollView(
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 8,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: MessageFieldBox(
                              onValue: (value) {
                                chatProvider.sendMessage(value, widget.token);
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  chatProvider.scrollToBottom(animated: true);
                                });
                              },
                              enabled: !chatProvider.isLoading,
                              focusNode: _focusNode,
                            ),
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
    );
  }

  Widget _buildMessageList(ChatProvider chatProvider, bool isTablet) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        chatProvider.scrollToBottom(animated: false);
      }
    });

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return false;
      },
      child: ListView.builder(
        controller: chatProvider.chatScrollController,
        itemCount: chatProvider.messageList.length,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 10,
          vertical: 8,
        ),
        physics: const ClampingScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          final message = chatProvider.messageList[index];
          return message.fromWho == FromWho.me
              ? MyMessageBubble(message: message)
              : HerMessageBubble(message: message);
        },
      ),
    );
  }
}