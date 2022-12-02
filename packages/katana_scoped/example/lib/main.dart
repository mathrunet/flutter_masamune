import 'package:flutter/material.dart';
import 'package:katana_scoped/katana_scoped.dart';

void main() {
  runApp(const MyApp());
}

final appRef = AppRef();

class MyApp extends StatelessWidget {
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

final valueNotifierQuery =
    ChangeNotifierScopedQueryFamily<ValueNotifier<int>, int>(
  (p) => ValueNotifier(p),
);

class CounterPage extends PageScopedWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final counter = ref.page.query(valueNotifierQuery(100));

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
