// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_scoped/katana_scoped.dart";

void main() {
  runApp(const MyApp());
}

/// Global app reference for the application.
final appRef = AppRef();

/// Main application widget that provides the root of the widget tree.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScoped(
      appRef: appRef,
      child: MaterialApp(
        home: const CounterPage(),
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

/// Query for managing a ValueNotifier with an integer value.
final valueNotifierQuery =
    ChangeNotifierAppScopedQueryFamily<ValueNotifier<int>, int>(
  (ref, p) => ValueNotifier(p),
);

/// A page widget that displays a counter and allows incrementing it.
class CounterPage extends PageScopedWidget {
  /// Creates a [CounterPage].
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final counter = ref.app.query(valueNotifierQuery(100));

    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: Center(
        child: Text("${counter.value}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
