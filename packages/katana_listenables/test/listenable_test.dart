// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:katana_listenables/katana_listenables.dart';

part 'listenable_test.listenable.dart';

@listenables
class ListenableValue with _$ListenableValue, ChangeNotifier {
  factory ListenableValue({
    required TextEditingController controller,
    ValueNotifier<String> value,
  }) = _ListenableValue;
  ListenableValue._();

  void get() {}
}

void main() {
  testWidgets("Listenable.update", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListenablePage(),
      ),
    );
    await tester.pump();
    expect(text("textEditingController")?.data, "before click");
    expect(text("valueNotifier")?.data, "0");
    await tester.tapByKey("textEditingControllerTile");
    await tester.pump();
    expect(text("textEditingController")?.data, "after click");
    await tester.tapByKey("valueNotifierTile");
    await tester.pump();
    expect(text("valueNotifier")?.data, "1");
  });
}

class ListenablePage extends StatefulWidget {
  const ListenablePage({super.key});

  @override
  State<StatefulWidget> createState() => ListenablePageState();
}

class ListenablePageState extends State<ListenablePage> {
  final listenable = ListenableValue(
    controller: TextEditingController(text: "before click"),
    value: ValueNotifier("0"),
  );

  @override
  void initState() {
    super.initState();
    listenable.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            key: const ValueKey("textEditingControllerTile"),
            title: Text(
              listenable.controller.text,
              key: const ValueKey("textEditingController"),
            ),
            onTap: () {
              listenable.controller.text = "after click";
            },
          ),
          ListTile(
            key: const ValueKey("valueNotifierTile"),
            title: Text(
              listenable.value?.value ?? "",
              key: const ValueKey("valueNotifier"),
            ),
            onTap: () {
              listenable.value?.value = "1";
            },
          )
        ],
      ),
    );
  }
}

Text? text(String key) {
  final elements = find.byKey(ValueKey(key)).evaluate();
  if (elements.isEmpty) {
    return null;
  }
  return elements.single.widget as Text;
}

extension TesterExtensions on WidgetTester {
  Future<void> tapWithIcon(IconData icon) {
    return tap(find.byIcon(icon));
  }

  Future<void> tapByKey(String key) {
    return tap(find.byKey(ValueKey(key)));
  }
}
