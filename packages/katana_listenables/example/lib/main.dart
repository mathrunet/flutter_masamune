import 'dart:math';

import 'package:katana_listenables_annotation/katana_listenables_annotation.dart';

import 'package:flutter/material.dart';

part 'main.listenable.dart';

@listenables
class ListenableValue with _$ListenableValue {
  factory ListenableValue({
    required TextEditingController name,
    ValueNotifier<String> value,
  }) = _ListenableValue;
}

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
  final listenable = ListenableValue(
    name: TextEditingController(text: "before click"),
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
            title: Text(listenable.name.text),
            onTap: () {
              listenable.name.text = "after click";
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
