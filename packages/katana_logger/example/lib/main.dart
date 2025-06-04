// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_logger/katana_logger.dart";

void main() {
  runApp(const MyApp());
}

/// Main application widget for logger demo.
///
/// Logger デモ用のメインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
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

/// Page widget to demonstrate logger functionality.
///
/// Logger機能を実演するページWidget。
class LoggerPage extends StatefulWidget {
  /// Creates a LoggerPage widget.
  ///
  /// LoggerPageウィジェットを作成します。
  const LoggerPage({super.key});

  @override
  State<StatefulWidget> createState() => LoggerPageState();
}

/// State for LoggerPage widget.
///
/// LoggerPageウィジェットのState。
class LoggerPageState extends State<LoggerPage> {
  /// Logger instance for managing log operations.
  ///
  /// ログ操作を管理するLoggerインスタンス。
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
