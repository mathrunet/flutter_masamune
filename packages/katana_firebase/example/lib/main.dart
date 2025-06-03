import "package:flutter/material.dart";
import "package:katana_firebase/katana_firebase.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Firebase initialize Demo",
      home: FirebaseInitializeDemo(),
    );
  }
}

class FirebaseInitializeDemo extends StatefulWidget {
  const FirebaseInitializeDemo({super.key});

  @override
  State<StatefulWidget> createState() => FirebaseInitializeDemoState();
}

class FirebaseInitializeDemoState extends State<FirebaseInitializeDemo> {
  @override
  void initState() {
    super.initState();
    FirebaseCore.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase initialize Demo"),
      ),
      body: Center(
        child: Text(
          FirebaseCore.initialized ? "Initialized" : "Not initialized",
        ),
      ),
    );
  }
}
