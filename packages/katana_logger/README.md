<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Logger</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://threads.net/@mathrunet">
    <img src="https://img.shields.io/static/v1?label=Threads&message=Follow&color=101010&link=https://threads.net/@mathrunet" alt="Follow on Threads" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[Threads]](https://threads.net/@mathrunet) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

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

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)