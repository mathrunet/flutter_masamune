// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_theme/katana_theme.dart";

part "main.theme.dart";

@appTheme

/// Application theme configuration.
final theme = AppThemeData.light(
  primary: Colors.red,
  secondary: Colors.orange,
  tertiary: Colors.teal,
);

void main() {
  runApp(const MyApp());
}

/// Main application widget that provides the root of the widget tree.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      theme: theme,
      child: MaterialApp(
        home: const MyHomePage(
          title: "Flutter Demo",
        ),
        title: "Flutter Demo",
        theme: theme.toThemeData(
          defaultFontFamily: theme.font.notoSerifJP,
        ),
      ),
    );
  }
}

/// Home page widget that displays a counter.
@immutable
class MyHomePage extends StatefulWidget {
  /// Creates a [MyHomePage].
  const MyHomePage({required this.title, super.key});

  /// The title to display in the app bar.
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "You have pushed the button this many times:",
              style: theme.text.labelMedium,
            ),
            Text(
              "$_counter",
              style: theme.text.displayMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.color.tertiary,
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: Icon(Icons.add, color: theme.color.onTertiary),
      ),
    );
  }
}
