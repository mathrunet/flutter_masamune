// Dart imports:
import "dart:io";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_picker/masamune_picker.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MasamuneApp(
      home: const PickerPage(),
      title: "Flutter Demo",
      masamuneAdapters: const [PickerMasamuneAdapter()],
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    );
  }
}

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<StatefulWidget> createState() => PickerPageState();
}

class PickerPageState extends State<PickerPage> {
  final picker = Picker();
  PickerValue? _value;

  @override
  void initState() {
    super.initState();
    picker.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    picker.removeListener(_handledOnUpdate);
    picker.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: Center(
        child: _value == null
            ? const SizedBox.shrink()
            : Image.file(
                File(_value!.uri!.toString()),
                fit: BoxFit.cover,
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _value = await picker.pickSingle();
        },
        label: const Text("Pick"),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
