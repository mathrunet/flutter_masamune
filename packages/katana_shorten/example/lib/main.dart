// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_shorten/katana_shorten.dart";

void main() {
  runApp(const MyApp());
}

/// Main application widget that provides the root of the widget tree.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ShortenPage(),
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

/// A page widget that demonstrates the katana_shorten package functionality.
class ShortenPage extends StatelessWidget {
  /// Creates a [ShortenPage].
  const ShortenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: Container(
        color: Colors.blue,
        padding: 16.p,
        child: const ColoredBox(
          color: Colors.red,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Start");
          Future.delayed(1.s);
          debugPrint("End");
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
