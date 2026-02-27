import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:smit_up/screens/login_register_screen.dart';
import 'camera_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;
  final String name;

  const DashboardScreen({
    super.key,
    required this.role,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$role Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginRegisterScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome $name 👋',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Scan Resume"),
              onPressed: () async {
                final cameras = await availableCameras();
                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CameraScreen(camera: cameras.first),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}