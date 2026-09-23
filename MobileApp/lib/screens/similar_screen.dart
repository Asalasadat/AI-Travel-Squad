import 'package:flutter/material.dart';
import 'package:travelai/screens/place_details.dart';
import '../models/place_model.dart';

class SimilarPlacesScreen extends StatelessWidget {
  final List<PlaceModel> places;

  const SimilarPlacesScreen({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("أماكن مشابهة"),
        centerTitle: true,
      ),

      body: places.isEmpty
          ? const Center(
              child: Text(
                "لم يتم العثور على أماكن مشابهة",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),

                        child: Image.network(
                          place.image,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 18,
                                ),

                                const SizedBox(width: 5),

                                Text(place.city),

                                const SizedBox(width: 15),

                                Chip(
                                  label: Text(place.type),
                                  backgroundColor:
                                      Colors.blue.shade100,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              place.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.green,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  "${place.score.toInt()}% Match",
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),

                                const Spacer(),

                                ElevatedButton(
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
                                  child:
                                      const Text("عرض التفاصيل"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}