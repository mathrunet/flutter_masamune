// Flutter imports:
import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

/// Main application widget for model OpenAPI demo.
///
/// Model OpenAPI デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ListenablePage(),
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

/// Page widget to demonstrate listenable functionality.
///
/// Listenable機能を実演するページWidget。
class ListenablePage extends StatefulWidget {
  /// Creates a ListenablePage widget.
  ///
  /// ListenablePageウィジェットを作成します。
  const ListenablePage({super.key});

  @override
  State<StatefulWidget> createState() => ListenablePageState();
}

/// State for ListenablePage widget.
///
/// ListenablePageウィジェットのState。
class ListenablePageState extends State<ListenablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Demo")),
      body: ListView(
        children: const [],
      ),
    );
  }
}
