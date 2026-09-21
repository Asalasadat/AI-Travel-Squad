import 'package:flutter/material.dart';

import 'package:travelai/screens/favscreen.dart';
import 'package:travelai/screens/similar_screen.dart';

import '../models/place_model.dart';
import '../data/place_data.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  // Find similar places
  List<PlaceModel> getSimilarPlaces(PlaceModel currentPlace) {
    final results = places
        .where((place) => place.name != currentPlace.name)
        .map((place) {
      int similarityScore = 0;

      // Same city
      if (place.city == currentPlace.city) {
        similarityScore += 50;
      }

      // Same type
      if (place.type == currentPlace.type) {
        similarityScore += 40;
      }

      // Similar place score
      final difference =
          (place.score - currentPlace.score).abs();

      if (difference <= 10) {
        similarityScore += 10;
      }

      return MapEntry(place, similarityScore);
    }).toList();

    // Sort from highest similarity to lowest
    results.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    // Return maximum 3 places
    return results
        .take(3)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = favorites.contains(place);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: CustomScrollView(
        slivers: [
          // =========================
          // Header Image
          // =========================
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.blue,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                place.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              background: Hero(
                tag: place.name,

                child: Image.network(
                  place.image,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // =========================
          // Page Content
          // =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // =========================
                  // City
                  // =========================
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        place.city,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Type
                  // =========================
                  Chip(
                    avatar: const Icon(
                      Icons.category,
                      size: 18,
                    ),

                    label: Text(
                      place.type,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    backgroundColor:
                        Colors.blue.shade100,
                  ),

                  const SizedBox(height: 25),

                  // =========================
                  // Description
                  // =========================
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // AI Matching
                  // =========================
                  const Text(
                    "AI Matching",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: place.score / 100,
                      minHeight: 12,
                      backgroundColor:
                          Colors.grey.shade300,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${place.score.toInt()}% Match",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // =========================
                  // Favorite Button
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),

                      label: Text(
                        isFavorite
                            ? "Remove From Favorites"
                            : "Add To Favorites",
                      ),

                      onPressed: () {
                        if (favorites.contains(place)) {
                          favorites.remove(place);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Removed from Favorites",
                              ),
                            ),
                          );
                        } else {
                          favorites.add(place);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Added to Favorites",
                              ),
                            ),
                          );
                        }

                        // Refresh screen
                        (context as Element)
                            .markNeedsBuild();
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // Google Maps
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.map,
                      ),

                      label: const Text(
                        "Open in Google Maps",
                      ),

                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Google Maps will be connected later",
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // Similar Places
                  // =========================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      icon: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),

                      label: const Text(
                        "Recommend Similar Places",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      onPressed: () {
                        // Get similar places
                        final similarPlaces =
                            getSimilarPlaces(place);

                        // Open Similar Places screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SimilarPlacesScreen(
                              places: similarPlaces,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}