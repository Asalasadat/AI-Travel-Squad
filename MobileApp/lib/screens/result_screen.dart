import 'package:flutter/material.dart';
import 'package:travelai/models/recommendationmodel.dart';
import 'package:travelai/screens/recommendation_services.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> cities;
  final List<String> tripTypes;
  final String ageGroup;
  final double totalBudget;
  final int peopleOver10;

  const ResultsScreen({
    super.key,
    required this.cities,
    required this.tripTypes,
    required this.ageGroup,
    required this.totalBudget,
    required this.peopleOver10,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List<RecommendationModel>> recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    recommendationsFuture = RecommendationService.getRecommendations(
      cities: widget.cities,
      tripTypes: widget.tripTypes,
      ageGroup: widget.ageGroup,
      totalBudget: widget.totalBudget,
      peopleOver10: widget.peopleOver10,
    );
  }

  void retry() {
    setState(() {
      _loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أماكن موصى بها"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<RecommendationModel>>(
        future: recommendationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 70,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: retry,
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              ),
            );
          }

          final recommendations = snapshot.data ?? [];

          if (recommendations.isEmpty) {
            return const Center(
              child: Text(
                "No recommendations found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final place = recommendations[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (place.imageUrl != null &&
                          place.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            place.imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 80,
                              );
                            },
                          ),
                        )
                      else
                        const Icon(
                          Icons.place,
                          size: 80,
                          color: Colors.blue,
                        ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.placeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "📍 ${place.city}",
                            ),

                            Text(
                              "🏷 ${place.placeType}",
                            ),

                            const SizedBox(height: 8),

                            Text(
                              place.description,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "⭐ Match Score: ${place.matchScore.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Rank: ${place.rankOrder}",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}