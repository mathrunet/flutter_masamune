// Dart imports:

// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_camera/masamune_camera.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  const MobileCameraMasamuneAdapter(),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (adapters) => MasamuneApp(
      home: const CameraPage(),
      title: "Flutter Demo",
      masamuneAdapters: adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  final cameraController = Camera();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await cameraController.initialize().showIndicator(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.initialized == false) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
      ),
      body: cameraController.preview,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final value = await cameraController.takePicture();
          if (value?.bytes == null) {
            return;
          }
          Modal.show(
            context,
            contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
            builder: (ref) {
              return [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: 256,
                    height: 256,
                    child: Image.memory(
                      value!.bytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.close();
                  },
                  child: const Text("Close"),
                ),
              ];
            },
          );
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
