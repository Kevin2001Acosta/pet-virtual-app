import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:dio/dio.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final GetIAAnswer getIAAnswer = GetIAAnswer();
  String _currentEmotion = 'respirar';
  bool _isLoading = false;
  String _petName = 'Mascota Virtual';
  bool _sessionExpired = false;
  double _lastViewInsets = 0; 

  List<Message> messageList = [];

  bool get isLoading => _isLoading;
  String get currentEmotion => _currentEmotion;
  String get petName => _petName;
  bool get sessionExpired => _sessionExpired; 

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setEmotion(String emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  void _startTyping() {
    final typingMessage = Message(
      text: 'Escribiendo...',
      fromWho: FromWho.typing,
    );
    messageList.add(typingMessage);
    notifyListeners();
    scrollToBottom(animated: true);
  }

  void _stopTyping() {
    if (messageList.isNotEmpty && messageList.last.fromWho == FromWho.typing) {
      messageList.removeLast();
      notifyListeners();
    }
  }

 void scrollToBottom({bool animated = true}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (chatScrollController.hasClients) {
      final position = chatScrollController.position;
      if (position.maxScrollExtent > 0) {
        if (animated) {
          chatScrollController.animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        } else {
          chatScrollController.jumpTo(position.maxScrollExtent);
        }
      }
    }
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (chatScrollController.hasClients) {
        final position = chatScrollController.position;
        if (position.maxScrollExtent > 0) {
          chatScrollController.jumpTo(position.maxScrollExtent);
        }
      }
    });
  });
}

//Limpiar chat
void clearMessages() {
  messageList.clear();
  notifyListeners();
}


void ensureScrollOnKeyboard() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    scrollToBottom(animated: true);
  });
}


void handleViewInsetsChange(double viewInsets) {
  if (viewInsets > _lastViewInsets && messageList.isNotEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(animated: true);
    });
  }
  _lastViewInsets = viewInsets;
}

  Future<void> sendMessage(String text, String token) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);
    notifyListeners();

    _setLoading(true);
    _startTyping();
    scrollToBottom(animated: true);

    herReply(text, token);
  }

  Future<void> herReply(String text, String token) async {
    _setLoading(true);

    try {
      final herMessage = await getIAAnswer.getAnswer(text, token);
      _stopTyping();
      messageList.add(herMessage);
      setEmotion(herMessage.emotion);
      debugPrint(herMessage.text);
      debugPrint(herMessage.imageUrl);
    } on DioException catch (e) { 
      _stopTyping();

      if (e.response?.statusCode == 401) {
        _sessionExpired = true;
        messageList.add(
          Message(
            text: 'Tu sesión ha expirado. Redirigiendo al login...',
            fromWho: FromWho.hers,
            emotion: 'respirar',
          ),
        );
      } else {
        messageList.add(
          Message(
            text: '¡Ups! No pude responder. Error: ${e.message}',
            fromWho: FromWho.hers,
            emotion: 'respirar',
          ),
        );
      }
      setEmotion('respirar');
    } catch (e) {
      _stopTyping();
      messageList.add(
        Message(
          text: '¡Ups! No pude responder. Error: ${e.toString()}',
          fromWho: FromWho.hers,
          emotion: 'respirar',
        ),
      );
      setEmotion('respirar');
    } finally {
      _setLoading(false);
      notifyListeners();
      scrollToBottom(animated: true);
    }
  }

  Future<void> loadMessages(String token) async {
    _setLoading(true);

    try {
      final Map<String, dynamic> result = await getIAAnswer.getMessages(token);
      messageList = result['messages'] as List<Message>;
      _petName = result['petName'] as String? ?? 'Mascota Virtual';
      debugPrint('Pet name cargado: $_petName');
    } on DioException catch (e) { 
      if (e.response?.statusCode == 401) {
        _sessionExpired = true;
      }
      messageList.add(
        Message(
          text: 'Error cargando mensajes: ${e.message}',
          fromWho: FromWho.me,
        ),
      );
    } catch (e) {
      debugPrint('Error en loadMessages: $e');
      messageList.add(
        Message(
          text: 'Error cargando mensajes: ${e.toString()}',
          fromWho: FromWho.me,
        ),
      );
    } finally {
      _setLoading(false);
      notifyListeners();
      scrollToBottom(animated: false);
    }
  }

  @override
  void dispose() {
    chatScrollController.dispose();
    super.dispose();
  }
}