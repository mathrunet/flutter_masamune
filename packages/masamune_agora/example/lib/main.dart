// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_agora/masamune_agora.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  const AgoraMasamuneAdapter(
    appId: "e3306fb870954eb880242a756a56c883",
    customerId: "4def5dd9abb0475faa69a5edd1328e6e",
    customerSecret: "f261c32d6af1406eb9a987f5cc900613",
    functionsAdapter: RuntimeFunctionsAdapter(),
  ),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const AgoraPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class AgoraPage extends StatefulWidget {
  const AgoraPage({super.key});

  @override
  State<StatefulWidget> createState() => AgoraPagePageState();
}

class AgoraPagePageState extends State<AgoraPage> {
  final AgoraController _controller = AgoraController("test_channel");

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
      ),
      body: GridBuilder<AgoraUser>.count(
        crossAxisCount: 2,
        source: _controller.value ?? <AgoraUser>[],
        builder: (context, item, index) {
          return AgoraScreen(value: item);
        },
      ),
      floatingActionButton: !_controller.connected
          ? FloatingActionButton(
              onPressed: () {
                _controller.disconnect();
              },
              child: const Icon(Icons.login),
            )
          : FloatingActionButton(
              onPressed: () {
                _controller.connect(userName: "user_name");
              },
              child: const Icon(Icons.logout),
            ),
    );
  }
}
