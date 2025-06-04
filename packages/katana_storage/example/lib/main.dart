// Dart imports:
import "dart:typed_data";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_storage/katana_storage.dart";

void main() {
  runApp(const MyApp());
}

/// Main application widget that provides the root of the widget tree.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageAdapterScope(
      adapter: const LocalStorageAdapter(),
      child: MaterialApp(
        home: const StoragePage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

/// A page widget that demonstrates storage functionality.
class StoragePage extends StatefulWidget {
  /// Creates a [StoragePage].
  const StoragePage({super.key});

  @override

  /// Creates the state for this widget.
  State<StatefulWidget> createState() => StoragePageState();
}

/// State class for [StoragePage].
class StoragePageState extends State<StoragePage> {
  /// Storage instance for managing file operations.
  final storage = Storage(const StorageQuery("test/file"));

  /// Text controller for input field.
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    storage.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    storage.removeListener(_handledOnUpdate);
    storage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: TextField(
        controller: controller,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final text = controller.text;
          final bytes = Uint8List.fromList(text.codeUnits);
          await storage.uploadWithBytes(bytes);
        },
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
