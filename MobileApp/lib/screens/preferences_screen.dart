import 'package:flutter/material.dart';
import 'package:travelai/screens/result_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? city;
  String? budget;
  String? tripType;
  String? ageGroup;

  final TextEditingController peopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Travel Preferences"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const Icon(
              Icons.travel_explore,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              "Plan Your Trip",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Select your travel preferences",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: const [
                "Jerusalem",
                "Nablus",
                "Ramallah",
                "Bethlehem",
                "Hebron",
                "Jericho",
              ].map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                city = value;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Budget",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              items: const [
                "Low",
                "Medium",
                "High",
              ].map((budget) {
                return DropdownMenuItem(
                  value: budget,
                  child: Text(budget),
                );
              }).toList(),
              onChanged: (value) {
                budget = value;
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: peopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of People",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Trip Type",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.hiking),
              ),
              items: const [
                "Historical",
                "Nature",
                "Adventure",
                "Family",
              ].map((trip) {
                return DropdownMenuItem(
                  value: trip,
                  child: Text(trip),
                );
              }).toList(),
              onChanged: (value) {
                tripType = value;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Age Group",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              items: const [
                "Children",
                "Youth",
                "Adults",
                "All Ages",
              ].map((age) {
                return DropdownMenuItem(
                  value: age,
                  child: Text(age),
                );
              }).toList(),
              onChanged: (value) {
                ageGroup = value;
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResultsScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Find Destinations",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}