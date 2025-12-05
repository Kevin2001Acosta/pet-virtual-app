import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';

class SemaforoWidget extends StatefulWidget {
  final EstadoSemaforo estadoActual;
  final VoidCallback? onTap;
  final bool showAnimation; 
  final Duration animationDuration;

  const SemaforoWidget({
    super.key,
    required this.estadoActual,
    this.onTap,
    this.showAnimation = true,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<SemaforoWidget> createState() => _SemaforoWidgetState();
}

class _SemaforoWidgetState extends State<SemaforoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
  
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    final titleFontSize = isTablet ? 22.0 : (isLandscape ? 15.0 : 18.0);
    final subtitleFontSize = isTablet ? 16.0 : (isLandscape ? 12.0 : 14.0);
    final padding = isTablet ? 28.0 : (isLandscape ? 16.0 : 20.0);
    final borderRadius = isTablet ? 28.0 : 24.0;
    final semaforoSize = isTablet ? 56.0 : (isLandscape ? 38.0 : 44.0);
    
    final estadoInfo = EstadoSemaforoInfo.fromEstado(widget.estadoActual);
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              estadoInfo.color.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: estadoInfo.color.withValues(alpha: 0.4),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
           
            BoxShadow(
              color: estadoInfo.color.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 0,
              offset: const Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildSemaforoStructure(
              estadoInfo,
              semaforoSize,
              isTablet,
            ),
            SizedBox(width: isTablet ? 28 : 20),
            
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                child: _buildEstadoInfo(
                  estadoInfo,
                  titleFontSize,
                  subtitleFontSize,
                  isTablet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Estructura del semáforo con caja contenedora
  Widget _buildSemaforoStructure(
    EstadoSemaforoInfo estadoInfo,
    double lightSize,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14.0 : 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(isTablet ? 18.0 : 14.0),
        border: Border.all(
          color: const Color(0xFF1A1A1A),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSemaforoLight(
            Colors.red,
            widget.estadoActual == EstadoSemaforo.rojo,
            lightSize,
            Icons.error,
          ),
          SizedBox(height: isTablet ? 14 : 10),
          _buildSemaforoLight(
            Colors.amber,
            widget.estadoActual == EstadoSemaforo.amarillo,
            lightSize,
            Icons.warning_amber_rounded,
          ),
          SizedBox(height: isTablet ? 14 : 10),
          _buildSemaforoLight(
            Colors.green,
            widget.estadoActual == EstadoSemaforo.verde,
            lightSize,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildSemaforoLight(
    Color color,
    bool isActive,
    double size,
    IconData icon,
  ) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: (isActive && widget.showAnimation) ? _pulseAnimation.value : 1.0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isActive
                    ? [
                        color.lighten(0.15),
                        color,
                        color.darken(0.1),
                      ]
                    : [
                        color.withValues(alpha: 0.15),
                        color.withValues(alpha: 0.08),
                      ],
                stops: isActive
                    ? const [0.0, 0.6, 1.0]  
                    : const [0.0, 1.0],      
              ),
              border: Border.all(
                color: isActive
                    ? color.lighten(0.2)
                    : const Color(0xFF404040),
                width: isActive ? 2.5 : 1.5,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.8),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(-2, -2),
                        spreadRadius: -2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                        spreadRadius: -1,
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isActive)
                  Positioned(
                    top: size * 0.15,
                    left: size * 0.2,
                    child: Container(
                      width: size * 0.3,
                      height: size * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                Icon(
                  icon,
                  size: size * 0.5,
                  color: isActive
                      ? Colors.white
                      : const Color(0xFF606060),
                  shadows: isActive
                      ? [
                          Shadow(
                            color: color.withValues(alpha: 0.8),
                            blurRadius: 8,
                          ),
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstadoInfo(
    EstadoSemaforoInfo estadoInfo,
    double titleFontSize,
    double subtitleFontSize,
    bool isTablet,
  ) {
    return Column(
      key: ValueKey(estadoInfo.estado), 
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 10.0 : 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    estadoInfo.color.withValues(alpha: 0.2),
                    estadoInfo.color.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isTablet ? 14.0 : 12.0),
                border: Border.all(
                  color: estadoInfo.color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Text(
                      estadoInfo.emoji,
                      style: TextStyle(fontSize: isTablet ? 32 : 24),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: isTablet ? 14 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estadoInfo.titulo,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: estadoInfo.color,
                      height: 1.2,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(
                          color: estadoInfo.color.withValues(alpha: 0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  Text(
                    estadoInfo.mensaje,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey[700],
                      height: 1.4,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

extension ColorExtension on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}




