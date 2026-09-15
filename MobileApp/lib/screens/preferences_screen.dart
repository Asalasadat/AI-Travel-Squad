import 'package:flutter/material.dart';
import 'package:travelai/screens/result_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {

  final _formKey = GlobalKey<FormState>();

  String? city;
  String? budget;
  String? tripType;
  String? ageGroup;

  final TextEditingController peopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Travel Preferences"),
        centerTitle: true,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Form(

            key: _formKey,

            child: Column(

              children: [

                const Icon(
                  Icons.travel_explore,
                  size: 90,
                  color: Colors.blue,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Travel Preferences",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Choose your trip information",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "City",
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  items: const [
                    "Jerusalem",
                    "Nablus",
                    "Ramallah",
                    "Bethlehem",
                    "Hebron",
                    "Jericho",
                    "Jenin",
                    "Tulkarm"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    city = value;
                  },

                  validator: (value) {
                    if (value == null) {
                      return "Please select city";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Budget",
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  items: const [
                    "Low",
                    "Medium",
                    "High"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    budget = value;
                  },

                  validator: (value) {
                    if (value == null) {
                      return "Please select budget";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: peopleController,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    labelText: "Number of People",
                    prefixIcon: const Icon(Icons.groups),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter number of people";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Trip Type",
                    prefixIcon: const Icon(Icons.hiking),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  items: const [
                    "Historical",
                    "Nature",
                    "Adventure",
                    "Family",
                    "Friends"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    tripType = value;
                  },

                  validator: (value) {
                    if (value == null) {
                      return "Please select trip type";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Age Group",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  items: const [
                    "Children",
                    "Youth",
                    "Adults",
                    "All Ages"
                  ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    ageGroup = value;
                  },

                  validator: (value) {
                    if (value == null) {
                      return "Please select age group";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {

                      if (_formKey.currentState!.validate()) {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultsScreen(),
                          ),
                        );

                      }

                    },

                    child: const Text(
                      "Find Destinations",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}