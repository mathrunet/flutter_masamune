// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune_animate/masamune_animate.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masamune Animate Example"),
      ),
      body: Center(
        child: SizedBox(
          width: 256,
          height: 256,
          child: AnimateScope(
            repeat: true,
            autoPlay: true,
            scenario: (runner) async {
              await runner.opacity(
                duration: const Duration(seconds: 1),
                begin: 0.0,
                end: 1.0,
              );
              await runner.wait(const Duration(seconds: 1));
              await runner.opacity(
                duration: const Duration(seconds: 1),
                begin: 1.0,
                end: 0.0,
              );
            },
            child: const ColoredBox(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
