import 'package:flutter/material.dart';

class NavigationControlsWidget extends StatelessWidget {
  final DateTime fechaInicioSemana;
  final bool puedeAnterior;
  final bool puedeSiguiente;
  final bool cargando;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;
  final VoidCallback onHoy;

  const NavigationControlsWidget({
    super.key,
    required this.fechaInicioSemana,
    required this.puedeAnterior,
    required this.puedeSiguiente,
    required this.cargando,
    required this.onAnterior,
    required this.onSiguiente,
    required this.onHoy,
  }) ;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    //final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Solo mostrar "Hoy" si no estamos en la semana actual
    final mostrarHoy = _necesitaMostrarHoy();
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 8 : 6,
        horizontal: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón semana anterior
          _buildNavigationButton(
            context: context,
            icon: Icons.chevron_left,
            enabled: puedeAnterior && !cargando,
            onPressed: onAnterior,
            tooltip: 'Semana anterior',
            isTablet: isTablet,
          ),

          // Fecha actual
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatearRangoSemanaCompacto(fechaInicioSemana),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: isTablet ? 14 : 13,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mostrarHoy && !cargando) ...[
                    SizedBox(height: 4),
                    GestureDetector(
                      onTap: onHoy,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10 : 8,
                          vertical: isTablet ? 3 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF35449).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Ir a hoy',
                          style: TextStyle(
                            color: Color(0xFFF35449),
                            fontSize: isTablet ? 12 : 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Botón semana siguiente
          _buildNavigationButton(
            context: context,
            icon: Icons.chevron_right,
            enabled: puedeSiguiente && !cargando,
            onPressed: onSiguiente,
            tooltip: 'Semana siguiente',
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  bool _necesitaMostrarHoy() {
    final inicioSemanaActual = _obtenerInicioSemana(DateTime.now());
    return !_mismaSemana(fechaInicioSemana, inicioSemanaActual);
  }

  DateTime _obtenerInicioSemana(DateTime fecha) {
    return fecha.subtract(Duration(days: fecha.weekday - 1));
  }

  bool _mismaSemana(DateTime fecha1, DateTime fecha2) {
    final inicio1 = _obtenerInicioSemana(fecha1);
    final inicio2 = _obtenerInicioSemana(fecha2);
    return inicio1.year == inicio2.year && 
           inicio1.month == inicio2.month && 
           inicio1.day == inicio2.day;
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isTablet,
  }) {
    return Container(
      width: isTablet ? 36 : 32,
      height: isTablet ? 36 : 32,
      decoration: BoxDecoration(
        color: enabled 
            ? Color(0xFFF35449).withValues(alpha: 0.1)
            : Colors.grey[100],
        shape: BoxShape.circle,
        border: Border.all(
          color: enabled 
              ? Color(0xFFF35449).withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: cargando 
            ? SizedBox(
                width: isTablet ? 16 : 14,
                height: isTablet ? 16 : 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Color(0xFFF35449),
                ),
              )
            : Icon(
                icon,
                color: enabled ? Color(0xFFF35449) : Colors.grey[400],
                size: isTablet ? 20 : 18,
              ),
        onPressed: enabled ? onPressed : null,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        iconSize: isTablet ? 20 : 18,
      ),
    );
  }

  String _formatearRangoSemanaCompacto(DateTime fechaInicio) {
    final fechaFin = fechaInicio.add(const Duration(days: 6));
    
    // Formato  "17-23 Dic 2023"
    final mesInicio = _nombreMesCorto(fechaInicio.month);
    final mesFin = _nombreMesCorto(fechaFin.month);
    
    if (fechaInicio.month == fechaFin.month) {
      return '${fechaInicio.day}-${fechaFin.day} $mesInicio ${fechaInicio.year}';
    } else {
      return '${fechaInicio.day} $mesInicio - ${fechaFin.day} $mesFin ${fechaInicio.year}';
    }
  }

  String _nombreMesCorto(int mes) {
    const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return meses[mes - 1];
  }
}
