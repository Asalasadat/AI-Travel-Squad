import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:travelai/models/reco.dart';

class RecommendationService {
  static const String baseUrl =
      'https://palestine-tourism-recommendation-api.onrender.com/api';

  static Future<List<RecommendationModel>> getRecommendations({
    required List<String> cities,
    required List<String> tripTypes,
    required String ageGroup,
    required double totalBudget,
    required int peopleOver10,
  }) async {
    final url = Uri.parse(baseUrl);

    final requestBody = {
      "cities": cities,
      "tripTypes": tripTypes,
      "ageGroup": ageGroup,
      "totalBudget": totalBudget,
      "peopleOver10": peopleOver10,
    };

    debugPrint("REQUEST => ${jsonEncode(requestBody)}");

    final response = await http
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 30));

    debugPrint("STATUS => ${response.statusCode}");
    debugPrint("BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final json = jsonDecode(response.body);

    final List list = json["recommendations"] ?? [];

    return list
        .map((e) => RecommendationModel.fromMap(e))
        .toList();
  }
}