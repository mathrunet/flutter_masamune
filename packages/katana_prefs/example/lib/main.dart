// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_prefs/katana_prefs.dart';

part 'main.prefs.dart';

@prefs
class PrefsValue with _$PrefsValue, ChangeNotifier {
  factory PrefsValue({
    String? userToken,
    required double volumeSetting,
  }) = _PrefsValue;
  PrefsValue._();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

class PrefsPage extends StatefulWidget {
  const PrefsPage({super.key});

  @override
  State<StatefulWidget> createState() => PrefsPageState();
}

class PrefsPageState extends State<PrefsPage> {
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
