import 'package:flutter/material.dart';
import 'package:travelai/data/place_data.dart';
import 'package:travelai/screens/place_details.dart';

import '../models/place_model.dart';

class ResultsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    List<PlaceModel> filteredPlaces = places.where((place) {
      final bool cityMatch = place.city == city;
      final bool typeMatch = place.type == tripType;

      return cityMatch || typeMatch;
    }).toList();

 
    if (filteredPlaces.isEmpty) {
      filteredPlaces = places;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Recommended Places"),
        centerTitle: true,

        actions: [
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


          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,

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
                      city,
                    ),

                    _preferenceChip(
                      Icons.attach_money,
                      budget,
                    ),

                    _preferenceChip(
                      Icons.hiking,
                      tripType,
                    ),

                    _preferenceChip(
                      Icons.person,
                      ageGroup,
                    ),

                    _preferenceChip(
                      Icons.groups,
                      "$people People",
                    ),
                  ],
                ),
              ],
            ),
          ),


          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              itemCount: filteredPlaces.length,

              itemBuilder: (context, index) {
                PlaceModel place = filteredPlaces[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlaceDetailsScreen(place: place),
                      ),
                    );
                  },

                  child: Card(
                    elevation: 5,

                    margin: const EdgeInsets.only(bottom: 20),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                                      Icons.image_not_supported,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      place.name,

                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),

                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.shade100,

                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      "${place.score.toInt()}%",

                                      style: const TextStyle(
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

                                    style: const TextStyle(
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

                                    style: const TextStyle(
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
                                value: place.score / 100,

                                minHeight: 8,

                                borderRadius:
                                    BorderRadius.circular(20),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "AI Match: ${place.score.toInt()}%",

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _preferenceChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,

        borderRadius: BorderRadius.circular(20),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
