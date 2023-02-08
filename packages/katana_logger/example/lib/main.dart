// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_logger/katana_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoggerAdapterScope(
      adapters: const [RuntimeLoggerAdapter()],
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
