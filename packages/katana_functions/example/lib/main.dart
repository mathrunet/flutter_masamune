// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_functions/katana_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FunctionsAdapterScope(
      adapter: const RuntimeFunctionsAdapter(),
      child: MaterialApp(
        home: const FunctionsPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class FunctionsPage extends StatefulWidget {
  const FunctionsPage({super.key});

  @override
  State<StatefulWidget> createState() => FunctionsPageState();
}

class FunctionsPageState extends State<FunctionsPage> {
  final functions = Functions();

  @override
  void initState() {
    super.initState();
    functions.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    functions.removeListener(_handledOnUpdate);
    functions.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Test Functions"),
            onTap: () async {
              await functions.execute(
                const TestFunctionsAction(),
              );
            },
          )
        ],
      ),
    );
  }
}
