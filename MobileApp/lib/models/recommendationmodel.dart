
class RecommendationModel {
  final String placeName;
  final String description;
  final String city;
  final String tripType;
  final double estimatedCost;
  final double totalCost;
  final double recommendationScore;

  RecommendationModel({
    required this.placeName,
    required this.description,
    required this.city,
    required this.tripType,
    required this.estimatedCost,
    required this.totalCost,
    required this.recommendationScore,
  });

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      placeName: map['Place_Name_AR']?.toString() ?? '',
      description: map['Description_AR']?.toString() ?? '',
      city: map['City']?.toString() ?? '',
      tripType: map['Trip_Type']?.toString() ?? '',
      estimatedCost:
          double.tryParse(map['Estimated_Cost_ILS']?.toString() ?? '0') ?? 0,
      totalCost:
          double.tryParse(map['Total_Cost_ILS']?.toString() ?? '0') ?? 0,
      recommendationScore:
          double.tryParse(
                map['Recommendation_Score']?.toString() ?? '0',
              ) ??
              0,
    );
  }
}

