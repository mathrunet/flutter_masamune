// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_prefs/katana_prefs.dart";

part "main.prefs.dart";

/// Example preferences value class demonstrating katana_prefs usage.
///
/// katana_prefsの使用方法を実演するサンプルPrefsValueクラス。
@prefs
class PrefsValue with _$PrefsValue, ChangeNotifier {
  /// Creates a PrefsValue instance.
  ///
  /// PrefsValueインスタンスを作成します。
  factory PrefsValue({
    required double volumeSetting,
    String? userToken,
  }) = _PrefsValue;
  PrefsValue._();
}

void main() {
  runApp(const MyApp());
}

/// Main application widget for preferences demo.
///
/// Preferences デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PrefsPage(),
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

/// Page widget to demonstrate preferences functionality.
///
/// Preferences機能を実演するページWidget。
class PrefsPage extends StatefulWidget {
  /// Creates a PrefsPage widget.
  ///
  /// PrefsPageウィジェットを作成します。
  const PrefsPage({super.key});

  @override
  State<StatefulWidget> createState() => PrefsPageState();
}

/// State for PrefsPage widget.
///
/// PrefsPageウィジェットのState。
class PrefsPageState extends State<PrefsPage> {
  /// Preferences instance for managing app preferences.
  ///
  /// アプリ設定を管理するPreferencesインスタンス。
  final prefs = PrefsValue(volumeSetting: 0.5);

  @override
  void initState() {
    super.initState();
    prefs.addListener(() {
      setState(() {});
    });
    prefs.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Demo")),
      body: ListView(
        children: [
          ListTile(
            title: TextField(
              controller: TextEditingController(text: prefs.userToken.get()),
              onChanged: (val) async {
                await prefs.userToken.set(val);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Volume Settings"),
          ),
          ListTile(
            title: Slider(
              value: prefs.volumeSetting.get(),
              onChanged: (val) {
                prefs.volumeSetting.set(val);
              },
            ),
            trailing: Text(
              "${prefs.volumeSetting.get().toStringAsFixed(1)}/1.0",
            ),
          ),
        ],
      ),
    );
  }
}
