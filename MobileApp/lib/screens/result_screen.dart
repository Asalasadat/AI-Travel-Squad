import 'package:flutter/material.dart';

import 'package:travelai/data/place_data.dart';
import 'package:travelai/screens/place_details.dart';
import 'package:travelai/models/place_model.dart';
import 'package:travelai/screens/recommendation_services.dart';

class ResultsScreen extends StatefulWidget {
  final String city;
  final String budget;
  final String tripType;
  final String ageGroup;
  final int people;

  const ResultsScreen({
    super.key,
    required this.city,
    required this.budget,
    required this.tripType,
    required this.ageGroup,
    required this.people,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final RecommendationService _recommendationService =
      RecommendationService();

  List<PlaceModel> filteredPlaces = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    _getRecommendations();
  }

  Future<void> _getRecommendations() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Budget comes from PreferencesScreen as:
      // Low / Medium / High
      //
      // We convert it to an approximate value
      // until the exact budget value is passed.
      final double budgetPerPerson =
          _convertBudgetToNumber(widget.budget);

      final recommendations =
          await _recommendationService.getRecommendations(
        city: widget.city,
        budgetPerPerson: budgetPerPerson,
        tripType: widget.tripType,
        ageGroup: widget.ageGroup,
        people: widget.people,
      );

      final List<PlaceModel> result =
          _convertRecommendationsToPlaces(recommendations);

      if (!mounted) return;

      setState(() {
        filteredPlaces = result;

        if (filteredPlaces.isEmpty) {
          _loadLocalRecommendations();
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;

        // Keep the application usable if Hugging Face
        // is temporarily unavailable.
        _loadLocalRecommendations();
      });
    }
  }

  double _convertBudgetToNumber(String budget) {
    switch (budget.toLowerCase()) {
      case 'low':
        return 33;

      case 'medium':
        return 66;

      case 'high':
        return 100;

      default:
        return 66;
    }
  }

  List<PlaceModel> _convertRecommendationsToPlaces(
    List<Map<String, dynamic>> recommendations,
  ) {
    final List<PlaceModel> result = [];

    for (final recommendation in recommendations) {
      final String? name =
          recommendation['name']?.toString();

      if (name == null || name.isEmpty) {
        continue;
      }

      // Find the same place in local data
      final matchingPlaces = places.where(
        (place) =>
            place.name.toLowerCase() ==
            name.toLowerCase(),
      );

      if (matchingPlaces.isNotEmpty) {
        final place = matchingPlaces.first;

        result.add(
          PlaceModel(
            name: place.name,
            city: place.city,
            type: place.type,
            description: place.description,
            image: place.image,
            score: _getScore(
              recommendation,
              place.score,
            ),
          ),
        );
      }
    }

    return result;
  }

  double _getScore(
    Map<String, dynamic> recommendation,
    double defaultScore,
  ) {
    final dynamic score =
        recommendation['match_score'] ??
        recommendation['score'] ??
        recommendation['match'];

    if (score == null) {
      return defaultScore;
    }

    return double.tryParse(
          score.toString(),
        ) ??
        defaultScore;
  }

  void _loadLocalRecommendations() {
    final List<PlaceModel> localResults =
        places.where((place) {
      final bool cityMatch =
          place.city.toLowerCase() ==
          widget.city.toLowerCase();

      final bool typeMatch =
          place.type.toLowerCase() ==
          widget.tripType.toLowerCase();

      return cityMatch || typeMatch;
    }).toList();

    if (localResults.isEmpty) {
      filteredPlaces = places;
    } else {
      filteredPlaces = localResults;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          "Recommended Places",
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh Recommendations",
            onPressed:
                isLoading ? null : _getRecommendations,
          ),

          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Preferences",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          _buildPreferences(),

          if (errorMessage.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "AI service is unavailable. Showing local recommendations.",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: isLoading
                ? _buildLoading()
                : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Your Preferences",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: [
              _preferenceChip(
                Icons.location_on,
                widget.city,
              ),

              _preferenceChip(
                Icons.attach_money,
                widget.budget,
              ),

              _preferenceChip(
                Icons.hiking,
                widget.tripType,
              ),

              _preferenceChip(
                Icons.person,
                widget.ageGroup,
              ),

              _preferenceChip(
                Icons.groups,
                "${widget.people} People",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          CircularProgressIndicator(),

          SizedBox(height: 20),

          Text(
            "AI is finding the best places for you...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Connecting to Hugging Face",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (filteredPlaces.isEmpty) {
      return const Center(
        child: Text(
          "No recommended places found.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      itemCount: filteredPlaces.length,

      itemBuilder: (context, index) {
        final PlaceModel place =
            filteredPlaces[index];

        return _buildPlaceCard(place);
      },
    );
  }

  Widget _buildPlaceCard(
    PlaceModel place,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PlaceDetailsScreen(
              place: place,
            ),
          ),
        );
      },

      child: Card(
        elevation: 5,

        margin: const EdgeInsets.only(
          bottom: 20,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(20),
              ),

              child: Hero(
                tag: place.name,

                child: Image.network(
                  place.image,

                  height: 220,
                  width: double.infinity,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      color: Colors.grey.shade300,

                      child: const Center(
                        child: Icon(
                          Icons
                              .image_not_supported,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,

                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.green.shade100,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Text(
                          "${place.score.toInt()}%",

                          style:
                              const TextStyle(
                            color: Colors.green,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 18,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        place.city,

                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 18,
                        color: Colors.blue,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        place.type,

                        style:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    place.description,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 15),

                  LinearProgressIndicator(
                    value:
                        place.score / 100,

                    minHeight: 8,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "AI Match: ${place.score.toInt()}%",

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child:
                        ElevatedButton.icon(
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),

                      label: const Text(
                        "View Details",
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlaceDetailsScreen(
                              place: place,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferenceChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.blue,
          ),

          const SizedBox(width: 5),

          Text(
            text,

            style: const TextStyle(
              color: Colors.blue,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}