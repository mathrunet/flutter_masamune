// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_model_notifier/firebase_model_notifier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FirestoreModel Notifier Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyCountUpDemo(),
    );
  }
}

class MyCountUpDemo extends StatefulWidget {
  const MyCountUpDemo();

  @override
  State<StatefulWidget> createState() => MyCountUpDemoState();
}

class MyCountUpDemoState extends State<MyCountUpDemo> {
  late final FirestoreDynamicDocumentModel document;

  @override
  void initState() {
    super.initState();
    document = FirestoreDynamicDocumentModel("app/counter");
    document.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    document.removeListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final count = document.get("count", 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("FirestoreModel Notifier Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "$count",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          document["count"] = count + 1;
          document.save();
        },
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}
