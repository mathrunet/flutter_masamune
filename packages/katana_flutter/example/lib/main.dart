// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:katana_flutter/katana_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Localize Demo",
      home: LocalizeDemo(),
    );
  }
}

class LocalizeDemo extends StatefulWidget {
  const LocalizeDemo();

  @override
  State<StatefulWidget> createState() => LocalizeDemoState();
}

class LocalizeDemoState extends State<LocalizeDemo> {
  @override
  void initState() {
    super.initState();
    Localize.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Localize Demo"),
      ),
      body: Center(
        child: Text("Name".localize()),
      ),
    );
  }
}
