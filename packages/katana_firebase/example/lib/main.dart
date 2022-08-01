// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:katana_firebase/katana_firebase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Firebase initialize Demo",
      home: FirebaseInitializeDemo(),
    );
  }
}

class FirebaseInitializeDemo extends StatefulWidget {
  const FirebaseInitializeDemo();

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
          FirebaseCore.isInitialized ? "Initialized" : "Not initialized",
        ),
      ),
    );
  }
}
