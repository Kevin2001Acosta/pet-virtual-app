import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

enum Emotion { joy, surprise, sadness, disgust, anger, respirar }

Emotion parseEmotion(String value) {
  switch (value.toLowerCase()) {
    case 'joy': return Emotion.joy;
    case 'surprise': return Emotion.surprise;
    case 'sadness': return Emotion.sadness;
    case 'disgust': return Emotion.disgust;
    case 'anger': return Emotion.anger;
    default: return Emotion.respirar;
  }
}

class MascotaAnimation extends StatefulWidget {
  final bool isSpeaking;
  final double? size;
  final String currentEmotion;
  final double sizePercentage;
  final double minSize;
  final double maxSize;
  final Duration emotionDuration;
  final bool autoReturnToIdle;

  const MascotaAnimation({
    super.key,
    required this.isSpeaking,
    this.size,
    required this.currentEmotion,
    this.sizePercentage = 0.35,
    this.minSize = 100.0,
    this.maxSize = 400.0,
    this.emotionDuration = const Duration(seconds: 5),
    this.autoReturnToIdle = true,
  });

  @override
  State<MascotaAnimation> createState() => _MascotaAnimationState();
}

class _MascotaAnimationState extends State<MascotaAnimation> {
  Artboard? _mascotaArtboard;
  StateMachineController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  static const String _nombreArtboard = "Artboard";
  static const String _nombreMaquinaEstado = "Emociones";
  static const String _rutaAssetRive = 'assets/rive/animacion.riv';

  SMIBool? _joyInput;
  SMIBool? _surpriseInput;
  SMIBool? _sadnessInput;
  SMIBool? _disgustInput;
  SMIBool? _angerInput;

  Timer? _emotionTimer;
  Emotion _currentDisplayedEmotion = Emotion.respirar;

  @override
  void initState() {
    super.initState();
    _initializeRive();
  }

  @override
  void didUpdateWidget(covariant MascotaAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentEmotion != widget.currentEmotion) {
      final newEmotion = parseEmotion(widget.currentEmotion);
    
      _showEmotionTemporarily(newEmotion);
    }
    
    if (oldWidget.isSpeaking != widget.isSpeaking) {
      _handleSpeakingChange();
    }
  }

  void _showEmotionTemporarily(Emotion emotion) {
    _emotionTimer?.cancel();
    
    
    if (emotion == Emotion.respirar) {
      _applyEmotion(Emotion.respirar);
      return;
    }
    
   
    if (_currentDisplayedEmotion == emotion) {
      _startReturnTimer();
      return;
    }
    
    _applyEmotion(emotion);
    _startReturnTimer();
  }

  void _startReturnTimer() {
    if (!widget.autoReturnToIdle) return;
    
    _emotionTimer = Timer(widget.emotionDuration, () {
      if (mounted && !widget.isSpeaking) {
        _applyEmotion(Emotion.respirar);
      }
    });
  }

  void _handleSpeakingChange() {
    _emotionTimer?.cancel();
    
    if (widget.isSpeaking) {
      _applyEmotion(Emotion.respirar);
    } else {
      final emotion = parseEmotion(widget.currentEmotion);
      _showEmotionTemporarily(emotion);
    }
  }

  void _applyEmotion(Emotion emotion) {
    
    _joyInput?.value = (emotion == Emotion.joy);
    _surpriseInput?.value = (emotion == Emotion.surprise);
    _sadnessInput?.value = (emotion == Emotion.sadness);
    _disgustInput?.value = (emotion == Emotion.disgust);
    _angerInput?.value = (emotion == Emotion.anger);
    
    _currentDisplayedEmotion = emotion;
    
  }

  Future<void> _initializeRive() async {
    await RiveFile.initialize();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      
      final bytes = await rootBundle.load(_rutaAssetRive);
      final file = RiveFile.import(bytes);
      final artboard = file.artboardByName(_nombreArtboard) ?? file.mainArtboard;

      _controller = StateMachineController.fromArtboard(artboard, _nombreMaquinaEstado);

      if (_controller != null) {
        artboard.addController(_controller!);
        
       
        for (final input in _controller!.inputs) {
        
          if (input is SMIBool) {
            switch (input.name) {
              case 'Joy': _joyInput = input; break;
              case 'Surprise': _surpriseInput = input; break;
              case 'Sadness': _sadnessInput = input; break;
              case 'Disgust': _disgustInput = input; break;
              case 'Anger': _angerInput = input; break;
            }
          }
        }
        
        // Aplicar emoción inicial
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final initial = parseEmotion(widget.currentEmotion);
            _showEmotionTemporarily(initial);
          }
        });
      } 
      
      setState(() {
        _mascotaArtboard = artboard;
        _isLoading = false;
      });
    } catch (e) {
      
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _emotionTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  double _getResponsiveSize(BuildContext context) {
    if (widget.size != null) return widget.size!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    double pct = isPortrait 
        ? (widget.sizePercentage * 1.3).clamp(0.25, 0.6)
        : widget.sizePercentage;
    return (screenWidth * pct).clamp(widget.minSize, widget.maxSize);
  }

  @override
  Widget build(BuildContext context) {
    final size = _getResponsiveSize(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final finalSize = size.clamp(0.0, constraints.maxWidth).clamp(0.0, constraints.maxHeight);

        if (_isLoading) {
          return SizedBox(
            width: finalSize,
            height: finalSize,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
          );
        }

        if (_hasError || _mascotaArtboard == null) {
          return _buildErrorWidget(finalSize);
        }

        return SizedBox(
          width: finalSize,
          height: finalSize,
          child: RepaintBoundary(
            child: Rive(artboard: _mascotaArtboard!, fit: BoxFit.contain),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(size * 0.06),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: size * 0.2),
            SizedBox(height: size * 0.04),
            Text('Error al cargar', style: TextStyle(fontSize: size * 0.06)),
            TextButton(onPressed: _loadRiveFile, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}