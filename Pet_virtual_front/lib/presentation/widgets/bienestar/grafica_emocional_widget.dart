import 'package:flutter/material.dart'; 
import 'package:fl_chart/fl_chart.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';

class GraficaEmocionalWidget extends StatelessWidget {
  final List<DatoGrafica>? datos;

  const GraficaEmocionalWidget({
  super.key,
  this.datos,
});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    
    final padding = isTablet ? 24.0 : (isLandscape ? 14.0 : 18.0);
    final chartHeight = isTablet ? 250.0 : (isLandscape ? 180.0 : 200.0);
    final borderRadius = isTablet ? 25.0 : 20.0;

    // Datos de ejemplo si no se proporcionan
    final datosGrafica = datos ??
        [
          DatoGrafica(dia: 0, valor: 3.5),
          DatoGrafica(dia: 1, valor: 4.0),
          DatoGrafica(dia: 2, valor: 3.8),
          DatoGrafica(dia: 3, valor: 4.2),
          DatoGrafica(dia: 4, valor: 4.5),
          DatoGrafica(dia: 5, valor: 4.3),
          DatoGrafica(dia: 6, valor: 4.6),
        ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF35449).withValues(alpha: 0.08),
            const Color(0xFFF35449).withValues(alpha: 0.03),
          ],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: chartHeight,
            child: _buildLineChart(datosGrafica),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<DatoGrafica> datos) {
    final spots = datos.map((d) => FlSpot(d.dia.toDouble(), d.valor)).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sab', 'Dom'];
                if (value.toInt() >= 0 && value.toInt() < dias.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      dias[value.toInt()],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final emojis = {
                1.0: '😢',  // Muy Negativo
                2.0: '😕',  // Negativo
                3.0: '😐',  // Neutral / Sin datos
                4.0: '🙂',  // Positivo
                5.0: '😊',  // Muy Positivo
              };
              
                if (emojis.containsKey(value)) {
                  return Text(
                    emojis[value]!,
                    style: const TextStyle(fontSize: 16),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 1,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFFF35449),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: const Color(0xFFF35449),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFF35449).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}