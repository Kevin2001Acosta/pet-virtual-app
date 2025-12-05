import 'package:flutter/material.dart';

enum EstadoSemaforo { verde, amarillo, rojo }

extension EstadoSemaforoExtension on EstadoSemaforo {
  static EstadoSemaforo fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verde':
        return EstadoSemaforo.verde;
      case 'amarillo':
        return EstadoSemaforo.amarillo;
      case 'rojo':
        return EstadoSemaforo.rojo;
      default:
        return EstadoSemaforo.amarillo;
    }
  }

  String get stringValue {
    switch (this) {
      case EstadoSemaforo.verde:
        return 'verde';
      case EstadoSemaforo.amarillo:
        return 'amarillo';
      case EstadoSemaforo.rojo:
        return 'rojo';
    }
  }
}

// Estado del semaforo info
class EstadoSemaforoInfo {
  final EstadoSemaforo estado;
  final Color color;
  final String emoji;
  final String titulo;
  final String mensaje;

  EstadoSemaforoInfo({
    required this.estado,
    required this.color,
    required this.emoji,
    required this.titulo,
    required this.mensaje,
  });

  // Factory para obtener info según el estado
  static EstadoSemaforoInfo fromEstado(EstadoSemaforo estado) {
    switch (estado) {
      case EstadoSemaforo.verde:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFF4CAF50),
          emoji: '😊',
          titulo: '¡Excelente estado emocional!',
          mensaje: 'Tu bienestar está en un nivel óptimo. ¡Sigue así!',
        );
      case EstadoSemaforo.amarillo:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFFFFC107),
          emoji: '😌',
          titulo: 'Estado emocional moderado',
          mensaje: 'Es normal sentirse así. Considera tomar un descanso.',
        );
      case EstadoSemaforo.rojo:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFFF44336),
          emoji: '😔',
          titulo: 'Necesitas apoyo',
          mensaje: 'Tus emociones indican que podrías necesitar ayuda profesional.',
        );
    }
  }
}


//Gráfica
class DatoGrafica {
  final int dia; // 0 = Lunes, 6 = Domingo
  final double valor; // 1.0 a 5.0 (estado emocional)
  final String? nota; 

  DatoGrafica({
    required this.dia,
    required this.valor,
    this.nota,
  });

  factory DatoGrafica.fromJson(Map<String, dynamic> json) {
    return DatoGrafica(
      dia: json['dia'] as int,
      valor: (json['valor'] as num).toDouble(),
      nota: json['nota'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dia': dia,
      'valor': valor,
      if (nota != null) 'nota': nota,
    };
  }
}

class EmotionalWeekData {
  final Map<String, DayEmotionData> weeklyData;

  EmotionalWeekData({required this.weeklyData});

  factory EmotionalWeekData.fromJson(Map<String, dynamic> json) {
    Map<String, DayEmotionData> data = {};
    
    json.forEach((fecha, valor) {
      if (valor is Map<String, dynamic>) {
          data[fecha] = DayEmotionData.fromJson(valor);
      }
    });

    return EmotionalWeekData(weeklyData: data);
  }

  // Convertir a DatoGrafica para usar en la gráfica
  List<DatoGrafica> toDatosGrafica() {
    // Ordenar por fecha
    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return sortedEntries.asMap().entries.map((entry) {
      final index = entry.key;  // 0=Lunes, 1=Martes, etc.
      final dayData = entry.value.value;
      
      final valor = dayData.getValorGrafica();
      
      return DatoGrafica(
        dia: index, 
        valor: valor, 
        nota: dayData.emotionLabel,
      );
    }).toList();
  }

  // Verificar si hay datos
  bool get isEmpty => weeklyData.isEmpty;
  bool get isNotEmpty => weeklyData.isNotEmpty;
}

class DayEmotionData {
  final dynamic emotionLevel; // Puede ser String o int (0)
  final String dayName;

  DayEmotionData({
    required this.emotionLevel,
    required this.dayName,
  });

  factory DayEmotionData.fromJson(Map<String, dynamic> json) {
    return DayEmotionData(
      emotionLevel: json['emotional_level'], // Puede ser String, int o null
      dayName: json['day_name'] as String,
    );
  }

  // Obtener el texto del nivel emocional
  String get emotionLabel {
    if (emotionLevel == null || emotionLevel == 0 || emotionLevel == '0') {
      return 'Sin datos';
    }
    if (emotionLevel is String) {
      return emotionLevel as String;
    }
    return 'Sin datos';
  }

  // Convertir a valor numérico para la gráfica
  double getValorGrafica() {
    final label = emotionLabel.toLowerCase();
    
    switch (label) {
      case 'muy negativo':
        return 1.5;
      case 'negativo':
        return 2.5;
      case 'neutral':
        return 3.0;
      case 'positivo':
        return 4.0;
      case 'muy positivo':
        return 4.8;
      case 'sin datos':
      default:
        return 3.0; // Neutral por defecto
    }
  }
}


