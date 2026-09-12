import 'package:flutter/material.dart';

import '../models/place_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.blue,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(place.name),
              background: Hero(
                tag: place.name,
                child: Image.network(
                  place.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

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
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  Chip(
                    label: Text(place.type),
                    backgroundColor: Colors.blue.shade100,
                  ),

                  const SizedBox(height: 25),

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

                  const Text(
                    "AI Matching",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: place.score / 100,
                      minHeight: 12,
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

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.favorite),
                      label: const Text("Add To Favorites"),

                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to Favorites"),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text("Open in Google Maps"),

                      onPressed: () {
                        // سيتم ربطه لاحقاً مع Google Maps
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text(
                        "Recommend Similar Places",
                        style: TextStyle(color: Colors.white),
                      ),

                      onPressed: () {
                        // سيتم ربطه مع نموذج الذكاء الاصطناعي
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