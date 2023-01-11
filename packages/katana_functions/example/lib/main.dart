import 'package:flutter/material.dart';
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

class FunctionsPage extends StatelessWidget {
  const FunctionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Send Notification"),
            onTap: () async {
              await Functions.sendNotification(
                title: "Title",
                text: "Push Notifications",
                target: "TopicName",
              );
            },
          )
        ],
      ),
    );
  }
}
