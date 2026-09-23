import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:travelai/config/app_config.dart';
import 'package:travelai/models/recommendationmodel.dart';


class RecommendationService {


  static Future<List<RecommendationModel>> getRecommendations({

    required List<String> cities,
    required List<String> tripTypes,
    required String ageGroup,
    required double totalBudget,
    required int peopleOver10,

  }) async {


    final url = Uri.parse(
      AppConfig.baseUrl,
    );


    final requestBody = {

      "Cities": cities,
      "TripTypes": tripTypes,
      "AgeGroup": ageGroup,
      "Budget": totalBudget,
      "GroupSize": peopleOver10,

    };


    debugPrint(
      "REQUEST => ${jsonEncode(requestBody)}",
    );


    try {

      final response = await http
          .post(

            url,

            headers: {

              "Content-Type": "application/json",
              "Accept": "application/json",

            },

            body: jsonEncode(requestBody),

          )
          .timeout(
            const Duration(seconds: 30),
          );


      debugPrint(
        "STATUS => ${response.statusCode}",
      );


      debugPrint(
        "BODY => ${response.body}",
      );


      if (response.statusCode != 200) {

        throw Exception(
          "Server Error: ${response.body}",
        );

      }


      final json = jsonDecode(
        response.body,
      );


      final List list =
          json["recommendations"] ?? [];


      return list
          .map(
            (e) => RecommendationModel.fromMap(e),
          )
          .toList();


    } catch (e) {


      debugPrint(
        "API ERROR => $e",
      );


      throw Exception(
        "Connection failed: $e",
      );


    }

  }

}