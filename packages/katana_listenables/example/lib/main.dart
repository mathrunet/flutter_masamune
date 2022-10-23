import 'dart:math';

import 'package:katana_listenables/katana_listenables.dart';

import 'package:flutter/material.dart';

part 'main.listenable.dart';

@listenables
class ListenableValue with _$ListenableValue, ChangeNotifier {
  factory ListenableValue({
    required TextEditingController controller,
    ValueNotifier<String> value,
  }) = _ListenableValue;
  ListenableValue._();

  void get() {}
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
