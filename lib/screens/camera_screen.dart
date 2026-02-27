// import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:smit_up/database/database_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _captureAndProcess() async {
  await _initializeControllerFuture;

  final image = await _controller.takePicture();
  final inputImage = InputImage.fromFilePath(image.path);

  final textRecognizer = TextRecognizer();
  final recognizedText =
      await textRecognizer.processImage(inputImage);

  final extractedText = recognizedText.text;

  await textRecognizer.close();

  final phone = _extractPhone(extractedText);
  final email = _extractEmail(extractedText);

  if (!mounted) return;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Resume Details"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Phone: $phone"),
            Text("Email: $email"),
            const SizedBox(height: 20),

            /// ✅ QR CODE GENERATED FROM RESUME TEXT
            QrImageView(
              data: extractedText,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await DatabaseHelper.instance.insertApplicant(
              extractedText,
              phone,
              email,
              image.path,
            );

            if (!mounted) return;

            Navigator.pop(context); // close dialog
            Navigator.pop(context); // back to dashboard
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}

  String _extractPhone(String text) {
    final regex = RegExp(r'\b\d{10}\b');
    return regex.firstMatch(text)?.group(0) ?? "";
  }

  String _extractEmail(String text) {
    final regex = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b');
    return regex.firstMatch(text)?.group(0) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
     title: const Text("Scan Resume"),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _captureAndProcess,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}