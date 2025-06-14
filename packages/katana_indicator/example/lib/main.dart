// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_indicator/katana_indicator.dart";

void main() {
  runApp(const MyApp());
}

/// Main application widget for indicator demo.
///
/// Indicator デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
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

/// Page widget to demonstrate shorten indicator functionality.
///
/// ショートインジケーター機能を実演するページWidget。
class ShortenPage extends StatelessWidget {
  /// Creates a ShortenPage widget.
  ///
  /// ShortenPageウィジェットを作成します。
  const ShortenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: const ColoredBox(
        color: Colors.blue,
        child: ColoredBox(
          color: Colors.red,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Start");
          Future.delayed(const Duration(seconds: 3)).showIndicator(context);
          debugPrint("End");
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
