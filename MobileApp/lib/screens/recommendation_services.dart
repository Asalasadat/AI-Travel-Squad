import 'dart:convert';
import 'package:dio/dio.dart';

class RecommendationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://asalasadat-palestine-tourism-recommendation.hf.space',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<Map<String, dynamic>>> getRecommendations({
    required String city,
    required double budgetPerPerson,
    required String tripType,
    required String ageGroup,
    required int people,
  }) async {
    try {
      // IMPORTANT:
      // Replace this with the API name from Hugging Face → Use via API.
      const String apiName = 'YOUR_API_NAME';

      final response = await _dio.post(
        '/gradio_api/call/$apiName',
        data: {
          'data': [
            city,
            budgetPerPerson,
            tripType,
            ageGroup,
            people,
          ],
        },
      );

      final eventId = response.data['event_id'];

      if (eventId == null) {
        throw Exception('No event ID returned from Hugging Face');
      }

      final result = await _dio.get(
        '/gradio_api/call/$apiName/$eventId',
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      return _parseResponse(result.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('API endpoint not found');
      }

      if (e.response?.statusCode == 500) {
        throw Exception('Hugging Face server error');
      }

      throw Exception(
        'Connection failed: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Recommendation error: $e',
      );
    }
  }

  List<Map<String, dynamic>> _parseResponse(String data) {
    final lines = data.split('\n');

    for (final line in lines) {
      if (line.startsWith('data:')) {
        final jsonText = line.substring(5).trim();

        if (jsonText.isEmpty) {
          continue;
        }

        try {
          final decoded = jsonDecode(jsonText);

          return _convertToList(decoded);
        } catch (_) {
          continue;
        }
      }
    }

    throw Exception('Invalid response from Hugging Face');
  }

  List<Map<String, dynamic>> _convertToList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    }

    if (data is Map) {
      if (data['recommendations'] is List) {
        return (data['recommendations'] as List)
            .whereType<Map>()
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();
      }
    }

    return [];
  }
}