// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_functions/katana_functions.dart';

void main() {
  runApp(const MyApp());
}

class TestFunctionsAction extends FunctionsAction<TestFunctionsActionResponse> {
  const TestFunctionsAction({
    required this.responseMessage,
  });

  final String responseMessage;

  @override
  String get action => "test";

  @override
  DynamicMap? toMap() {
    return {
      "message": responseMessage,
    };
  }

  @override
  TestFunctionsActionResponse toResponse(DynamicMap map) {
    return TestFunctionsActionResponse(
      message: map["message"] as String,
    );
  }
}

class TestFunctionsActionResponse extends FunctionsActionResponse {
  const TestFunctionsActionResponse({required this.message});

  final String message;
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
              final response = await functions.execute(
                const TestFunctionsAction(responseMessage: "success"),
              );
              debugPrint(response?.message); // "success"
            },
          )
        ],
      ),
    );
  }
}
