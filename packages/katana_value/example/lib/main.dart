// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_value/katana_value.dart';

@DataValue()
class Person {
  final String name;
  final String text;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class ValuePage extends StatefulWidget {
  const ValuePage({super.key});

  @override
  State<StatefulWidget> createState() => _ValuePageState();
}

class _ValuePageState extends State<ValuePage> {
  final person =  Person(name: "aaa", text: "aaa");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Value Page"),
      ),
      body: Center(
          child: Text(person.toJson().toString()),
          ),
    );
  }
}
