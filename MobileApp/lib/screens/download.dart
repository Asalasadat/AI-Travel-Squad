
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double progress = 0.0;

  String status = "Ready to download";

  bool isDownloading = false;

  Future<void> downloadFile() async {
    // ضع هنا الرابط الحقيقي للملف
    const String fileUrl =
        "https://example.com/travel-guide.pdf";

    try {
      setState(() {
        isDownloading = true;
        progress = 0.0;
        status = "Connecting...";
      });

      final directory =
          await getApplicationDocumentsDirectory();

      final filePath =
          "${directory.path}/travel_guide.pdf";

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      await dio.download(
        fileUrl,
        filePath,

        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;

              status =
                  "Downloading ${(progress * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      setState(() {
        isDownloading = false;
        progress = 1.0;
        status = "Download completed successfully!";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "File downloaded successfully!",
            ),
          ),
        );
      }
    } on DioException catch (e) {
      setState(() {
        isDownloading = false;
      });

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        setState(() {
          status =
              "Connection is weak. Please try again.";
        });
      } else {
        setState(() {
          status =
              "Download failed. Check your internet connection.";
        });
      }
    } catch (e) {
      setState(() {
        isDownloading = false;
        status = "Something went wrong.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Download Travel Guide"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_download,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            const Text(
              "Travel Guide",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 10),

            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed:
                    isDownloading ? null : downloadFile,

                icon: const Icon(Icons.download),

                label: Text(
                  isDownloading
                      ? "Downloading..."
                      : "Download File",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

