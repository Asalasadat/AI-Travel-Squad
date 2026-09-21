import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:travelai/models/reco.dart';

class RecommendationService {
  static const String baseUrl =
     'https://palestine-tourism-recommendation-api.onrender.com';

  static Future<List<RecommendationModel>> getRecommendations({
    required List<String> cities,
    required List<String> tripTypes,
    required double totalBudget,
    required int peopleOver10,
  }) async {
    final url = Uri.parse('$baseUrl/recommendations');

    try {
      debugPrint('==============================');
      debugPrint('START RECOMMENDATION REQUEST');
      debugPrint('URL: $url');
      debugPrint('Cities: $cities');
      debugPrint('Trip Types: $tripTypes');
      debugPrint('Budget: $totalBudget');
      debugPrint('People: $peopleOver10');
      debugPrint('==============================');

      final requestBody = {
        'cities': cities,
        'tripTypes': tripTypes,
        'totalBudget': totalBudget,
        'peopleOver10': peopleOver10,
      };

      debugPrint('REQUEST BODY: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 120),
          );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'السيرفر أعاد خطأ.\n'
          'Status Code: ${response.statusCode}\n'
          'Response: ${response.body}',
        );
      }

      if (response.body.trim().isEmpty) {
        throw Exception(
          'السيرفر أعاد استجابة فارغة.',
        );
      }

      final dynamic data = jsonDecode(response.body);

      debugPrint('DECODED DATA: $data');
      debugPrint('DATA TYPE: ${data.runtimeType}');

      final results = _parseResult(data);

      debugPrint(
        'TOTAL RESULTS: ${results.length}',
      );

      return results;
    } on SocketException catch (e) {
      debugPrint('SOCKET ERROR: $e');

      throw Exception(
        'لا يوجد اتصال بالسيرفر.\n'
        'تأكدي من الإنترنت ومن أن خدمة الـ API تعمل.',
      );
    } on http.ClientException catch (e) {
      debugPrint('CLIENT ERROR: $e');

      throw Exception(
        'تعذر الوصول إلى API.\n'
        '$e',
      );
    } on FormatException catch (e) {
      debugPrint('JSON ERROR: $e');

      throw Exception(
        'السيرفر أعاد بيانات ليست بصيغة JSON صحيحة.\n'
        '$e',
      );
    } catch (e) {
      debugPrint('MODEL ERROR: $e');

      throw Exception(
        'حدث خطأ أثناء الحصول على التوصيات.\n'
        '$e',
      );
    }
  }

  static List<RecommendationModel> _parseResult(
    dynamic data,
  ) {
    if (data == null) {
      return [];
    }

    dynamic actualData = data;

    if (data is Map &&
        data['recommendations'] is List) {
      actualData = data['recommendations'];
    } else if (data is Map &&
        data['data'] is List) {
      actualData = data['data'];
    }

    if (actualData is! List) {
      throw Exception(
        'صيغة نتيجة المودل غير متوقعة:\n$actualData',
      );
    }

    final List<RecommendationModel> results = [];

    for (final item in actualData) {
      final model = _parseItem(item);

      if (model != null) {
        results.add(model);
      }
    }

    return results;
  }

  static RecommendationModel? _parseItem(
    dynamic item,
  ) {
    try {
      if (item is Map) {
        return RecommendationModel.fromMap(
          Map<String, dynamic>.from(item),
        );
      }

      if (item is List) {
        if (item.length < 7) {
          debugPrint(
            'Skipping row because length < 7: $item',
          );

          return null;
        }

        return RecommendationModel.fromMap({
          'Place_Name_AR': item[0],
          'Description_AR': item[1],
          'City': item[2],
          'Trip_Type': item[3],
          'Estimated_Cost_ILS': item[4],
          'Total_Cost_ILS': item[5],
          'Recommendation_Score': item[6],
        });
      }
    } catch (e) {
      debugPrint(
        'Error parsing item: $e',
      );
    }

    return null;
  }
}