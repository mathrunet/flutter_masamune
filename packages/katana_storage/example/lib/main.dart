import 'package:flutter/material.dart';
import 'package:katana_storage/katana_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageAdapterScope(
      adapter: const RuntimeStorageAdapter(),
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

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StatefulWidget> createState() => StoragePageState();
}

class StoragePageState extends State<StoragePage> {
  final storage = Storage(const StorageQuery("/test/file"));

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
      body: ListView(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person),
      ),
    );
  }
}
