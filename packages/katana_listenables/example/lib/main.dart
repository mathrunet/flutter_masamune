import 'dart:math';

import 'package:flutter/material.dart';

part 'main.listenable.dart';

class Test with _$Test {
  factory Test({
    required TextEditingController name,
    ValueNotifier<String> value,
  }) = _Test;
}

class _Test with ChangeNotifier implements Test {
  _Test({required this.name, this.value}) {
    if (name is Listenable) {
      name?.addListener(notifyListeners);
    }
    if (value is Listenable) {
      value?.addListener(notifyListeners);
    }
  }
  final TextEditingController name;
  final ValueNotifier<String>? value;

  @override
  void dispose() {
    super.dispose();
    if (name is Listenable) {
      name?.removeListener(notifyListeners);
    }
    if (value is Listenable) {
      value?.removeListener(notifyListeners);
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizeScope(
      localize: l,
      builder: (context, localize) {
        return MaterialApp(
          locale: localize.locale,
          localizationsDelegates: localize.delegates(),
          supportedLocales: localize.supportedLocales(),
          localeResolutionCallback: localize.localeResolutionCallback(),
          home: TestPage(),
          title: "Flutter Demo",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final test = Test(
    name: TextEditingController(text: "ccc"),
  );
  @override
  void initState() {
    super.initState();
    test.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l().appTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(test.name.text),
            onTap: () {
              test.name.text = "aaa";
            },
          ),
          ListTile(
            title: Text(test.value?.value ?? ""),
            onTap: () {
              test.value?.value = Random().rangeInt(0, 100).toString();
            },
          )
        ],
      ),
    );
  }
}
