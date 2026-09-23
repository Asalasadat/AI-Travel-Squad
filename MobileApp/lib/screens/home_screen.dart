
import 'package:flutter/material.dart';
import 'package:travelai/screens/download.dart';
import 'package:travelai/screens/favscreen.dart';
import 'package:travelai/screens/preferences_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("AI Travel Squad"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.travel_explore,
              size: 120,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              "اكتشف فلسطين",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "نقارن اهتمامك مع وجهات فلسطينية لنقدم لك الاماكن الاقرب الاقرب الى ذوقك مرتبة بوضوح حسب نسبةالمطابقة",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),
            ),

            const Spacer(),

            // Start Journey
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PreferencesScreen(),
                    ),
                  );

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                 "ابدأ الرحلة",
               textAlign: TextAlign.center,
                   style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                 ),
                ),
              ),

            const SizedBox(height: 15),

            // Download
            SizedBox(
              width: double.infinity,
              height: 55,

              child: OutlinedButton.icon(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const DownloadScreen(),
                    ),
                  );

                },

                icon: const Icon(
                  Icons.download,
                ),

                label: const Text(
                "تحميل الدليل السياحي",
  // ignore: unnecessary_const
                style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                ),
               ),
              ),
            ),

            const SizedBox(height: 15),

            // Favorites
            SizedBox(
              width: double.infinity,
              height: 55,

              child: OutlinedButton.icon(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FavoritesScreen(),
                    ),
                  );

                },

                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),

                label: const Text(
  "المفضلة",
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

