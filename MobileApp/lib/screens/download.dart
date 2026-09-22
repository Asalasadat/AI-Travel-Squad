
import 'dart:html' as html;

import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool isDownloading = false;
  bool isDownloaded = false;

  String status = "الدليل جاهز للتنزيل";

  static const String fileUrl =
      "https://raw.githubusercontent.com/Asalasadat/AI-Travel-Squad/main/ai_travel_squad_summary.pdf";

  void downloadGuide() {
    setState(() {
      isDownloading = true;
      status = "الدليل جاهز للتنزيل";
    });

    final anchor = html.AnchorElement(href: fileUrl)
      ..setAttribute(
        "تحميل",
        "ai_travel_squad_summary.pdf",
      )
      ..target = "_blank";

    html.document.body?.append(anchor);

    anchor.click();

    anchor.remove();

    setState(() {
      isDownloading = false;
      isDownloaded = true;
      status = "جارٍ تنزيل الدليل السياحي...";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "بدأ تنزيل الدليل السياحي!",
        ),
      ),
    );
  }

  void openGuide() {
    html.window.open(fileUrl, "_blank");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          "تحميل الدليل السياحي",
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.menu_book,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 30),

                const Text(
                  "دليل السفر في فلسطين",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "حمّل دليل AI Travel Squad السياحي واستكشف أجمل الوجهات السياحية في فلسطين.",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  status,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed:
                        isDownloading
                            ? null
                            : downloadGuide,

                    icon: Icon(
                      isDownloaded
                          ? Icons.check_circle
                          : Icons.download,
                    ),

                    label: Text(
                      isDownloaded
                          ? "تحميل الدليل مرة أخرى"
                          : "تحميل الدليل السياحي",
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                if (isDownloaded)
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      onPressed: openGuide,

                      icon: const Icon(
                        Icons.menu_book,
                      ),

                      label: const Text(
                        "فتح الدليل السياحي",
                      ),

                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
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

