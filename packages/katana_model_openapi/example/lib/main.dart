import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

class ListenablePage extends StatefulWidget {
  const ListenablePage({super.key});

  @override
  State<StatefulWidget> createState() => ListenablePageState();
}

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
