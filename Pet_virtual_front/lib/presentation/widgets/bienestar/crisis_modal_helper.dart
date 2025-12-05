import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrisisModalHelper {
  static void showCrisisModal(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    final titleFontSize = isTablet ? 22.0 : (isLandscape ? 16.0 : 20.0);
    final bodyFontSize = isTablet ? 16.0 : (isLandscape ? 13.0 : 15.0);
    final iconSize = isTablet ? 60.0 : 50.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: isTablet ? 550 : double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 32.0 : 28.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF35449),
                      const Color(0xFFE63946),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 16.0 : 14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        color: const Color(0xFFF35449),
                        size: iconSize,
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    Text(
                      'Apoyo Psicológico Disponible',
                      style: TextStyle(
                        fontSize: titleFontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTablet ? 10 : 8),
                    Text(
                      'Universidad del Valle - Sede Tuluá',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Contenido
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 32.0 : 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título 
                      Text(
                        '🏥 Recursos de Apoyo Psicológico',
                        style: TextStyle(
                          fontSize: bodyFontSize + 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),

                      SizedBox(height: isTablet ? 20 : 18),

                      // Consultorio
                      Container(
                        padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFF35449).withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF35449).withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF35449).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.medical_services_rounded,
                                    color: const Color(0xFFF35449),
                                    size: isTablet ? 32 : 28,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 16 : 14),
                                Expanded(
                                  child: Text(
                                    'Consultorio Psicológico',
                                    style: TextStyle(
                                      fontSize: bodyFontSize + 2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isTablet ? 24 : 20),

                            // Psicólogo
                            _buildInfoRow(
                              icon: Icons.person_rounded,
                              label: 'Psicólogo',
                              value: 'Paúl Steven Aponte Jiménez',
                              isTablet: isTablet,
                              bodyFontSize: bodyFontSize,
                            ),

                            SizedBox(height: isTablet ? 18 : 16),

                            // Horario
                            _buildInfoRow(
                              icon: Icons.access_time_rounded,
                              label: 'Horario',
                              value: 'Lunes a viernes\n08:00 a.m. – 12:00 m.\n02:00 p.m. – 06:00 p.m.',
                              isTablet: isTablet,
                              bodyFontSize: bodyFontSize,
                            ),

                            SizedBox(height: isTablet ? 18 : 16),

                            // Correo
                            _buildInfoRow(
                              icon: Icons.email_rounded,
                              label: 'Correo',
                              value: 'serviciopsicologico.tulua@correounivalle.edu.co',
                              isTablet: isTablet,
                              bodyFontSize: bodyFontSize,
                              copyable: true,
                              context: context,
                            ),

                            SizedBox(height: isTablet ? 18 : 16),

                            // Lugar
                            _buildInfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Lugar',
                              value: 'Sede Victoria',
                              isTablet: isTablet,
                              bodyFontSize: bodyFontSize,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isTablet ? 28 : 24),

                      // Mensaje motivacional
                      Container(
                        padding: EdgeInsets.all(isTablet ? 20.0 : 18.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: Colors.blue.shade700,
                              size: isTablet ? 26 : 24,
                            ),
                            SizedBox(width: isTablet ? 14 : 12),
                            Expanded(
                              child: Text(
                                'Pedir ayuda es un acto de valentía.\nTu bienestar es importante.',
                                style: TextStyle(
                                  fontSize: bodyFontSize - 1,
                                  color: Colors.grey[800],
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón
              Container(
                padding: EdgeInsets.all(isTablet ? 28.0 : 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35449),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 18 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Entendido',
                      style: TextStyle(
                        fontSize: bodyFontSize + 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
    required double bodyFontSize,
    bool copyable = false,
    BuildContext? context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 8.0 : 6.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFF35449),
            size: isTablet ? 22 : 20,
          ),
        ),
        SizedBox(width: isTablet ? 14 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: bodyFontSize - 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: Colors.grey[900],
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (copyable && context != null)
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: isTablet ? 20 : 18,
                        color: const Color(0xFFF35449),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Correo copiado al portapapeles'),
                            backgroundColor: const Color(0xFFF35449),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      tooltip: 'Copiar correo',
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}