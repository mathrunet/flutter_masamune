<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Logger</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

Provides the ability to collect application logs for Katana/Masamune Framework.

# Installation

Import the following packages.

```dart
flutter pub add katana_logger
```

# Implementation

## Advance preparation

Be sure to place the `LoggerAdapterScope` widget near the root of the app.

Pass a LoggerAdapter such as `RuntimeLoggerAdapter` as the adapter parameter.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:katana_logger/katana_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoggerAdapterScope(
      adapter: const RuntimeLoggerAdapter(),
      child: MaterialApp(
        home: const LoggerPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
```

## Creating Logger Objects

To perform logging, first create a `Logger` and keep it somewhere.

This `Logger` object actively performs the following logging

- `send`、`sendRawData`：Records log events.
- `trace`：Records trace events.

Since `Logger` inherits from ChangeNotifier, it is possible to monitor updates by using `addListener`, riverpod's `ChangeNotifierProvider`, etc.

It is also possible to check the logs recorded with the `logList` method.

```dart
// logger_page.dart
import 'package:flutter/material.dart';
import 'package:katana_logger/katana_logger.dart';

class LoggerPage extends StatefulWidget {
  const LoggerPage({super.key});

  @override
  State<StatefulWidget> createState() => LoggerPageState();
}

class LoggerPageState extends State<LoggerPage> {
  final logger = Logger();
  List<LogValue> _values = [];

  @override
  void initState() {
    super.initState();
    logger.addListener(_handledOnUpdate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handledOnUpdate();
  }

  Future<void> _handledOnUpdate() async {
    _values = await logger.logList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    logger.removeListener(_handledOnUpdate);
    logger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          ..._values.map(
            (e) => ListTile(
              title: Text(e.name),
              subtitle: Text(e.dateTime.toIso8601String()),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logger.sendRawData("test", parameters: {"count": 5});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
