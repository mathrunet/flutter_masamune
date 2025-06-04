// Dart imports:
import "dart:math";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_listenables/katana_listenables.dart";

part "main.listenable.dart";

/// Example listenable value class demonstrating katana_listenables usage.
///
/// katana_listenablesの使用方法を実演するサンプルListenableValueクラス。
@listenables
class ListenableValue with _$ListenableValue, ChangeNotifier {
  /// Creates a ListenableValue instance.
  ///
  /// ListenableValueインスタンスを作成します。
  factory ListenableValue({
    required TextEditingController controller,
    ValueNotifier<String> value,
  }) = _ListenableValue;
  ListenableValue._();

  /// Gets the current state.
  ///
  /// 現在の状態を取得します。
  void get() {}
}

void main() {
  runApp(const MyApp());
}

/// Main application widget for listenables demo.
///
/// Listenables デモ用のメインアプリケーションWidget。
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
  /// Listenable instance for managing state.
  ///
  /// 状態管理用のListenableインスタンス。
  final listenable = ListenableValue(
    controller: TextEditingController(text: "before click"),
    value: ValueNotifier("0"),
  );

  @override
  void initState() {
    super.initState();
    listenable.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Demo")),
      body: ListView(
        children: [
          ListTile(
            title: Text(listenable.controller.text),
            onTap: () {
              listenable.controller.text = "after click";
            },
          ),
          ListTile(
            title: Text(listenable.value?.value ?? ""),
            onTap: () {
              listenable.value?.value = Random().nextInt(100).toString();
            },
          )
        ],
      ),
    );
  }
}
