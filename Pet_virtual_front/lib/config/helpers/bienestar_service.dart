import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';


class BienestarService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: backendUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<EstadoSemaforo> obtenerEstadoSemaforo(String token) async {
    try {
      final response = await _dio.get(
        '/chatbot/chat/emotion-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final json = response.data; 
        final estadoString = json['status'] as String?;

        if (estadoString == null) {
          
          return EstadoSemaforo.verde;
        }

        return EstadoSemaforoExtension.fromString(estadoString);
        
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error del servidor: ${e.response!.statusCode}');
      } else {
        throw Exception('Error de conexión: $e');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<EstadoSemaforo?> obtenerEstadoSemaforoSeguro(String token) async {
    try {
      return await obtenerEstadoSemaforo(token);
    } catch (e) {

      return null;
    }
  }


//Para gráfica emocional
Future<EmotionalWeekData> obtenerNivelesSemanales({
  required String token,
  required String startDate,
  required String endDate,
}) async {
  try {
    final response = await _dio.get(
      '/chatbot/chat/emotion-weekly-status',
      queryParameters: {
        'start_date': startDate,
        'end_date': endDate,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    

    if (response.statusCode == 200) {
      return EmotionalWeekData.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw Exception('Token inválido o expirado');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      throw Exception('Error del servidor: ${e.response!.statusCode}');
    } else {
      throw Exception('Error de conexión: $e');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<EmotionalWeekData?> obtenerNivelesSemanaalesSeguro({
  required String token,
  required String startDate,
  required String endDate,
}) async {
  try {
    return await obtenerNivelesSemanales(
      token: token,
      startDate: startDate,
      endDate: endDate,
    );
  } catch (e) {
    return null;
  }
}
}