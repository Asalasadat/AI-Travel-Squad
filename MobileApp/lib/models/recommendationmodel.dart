class RecommendationModel {
  final int placeId;
  final String placeName;
  final String placeType;
  final String city;
  final String description;
  final String? imageUrl;
  final double matchScore;
  final int rankOrder;

  RecommendationModel({
    required this.placeId,
    required this.placeName,
    required this.placeType,
    required this.city,
    required this.description,
    required this.imageUrl,
    required this.matchScore,
    required this.rankOrder,
  });

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      placeId: map['placeId'] ?? map['PlaceId'] ?? 0,

      placeName: map['placeName'] ??
          map['PlaceName'] ??
          '',

      placeType: map['placeType'] ??
          map['PlaceType'] ??
          '',

      city: map['city'] ??
          map['City'] ??
          '',

      description: map['description'] ??
          map['Description'] ??
          '',

      imageUrl: map['imageUrl'] ??
          map['ImageUrl'],

      matchScore: (map['matchScore'] ??
                  map['MatchScore'] ??
                  0)
              .toDouble(),

      rankOrder: map['rankOrder'] ??
          map['RankOrder'] ??
          0,
    );
  }
}