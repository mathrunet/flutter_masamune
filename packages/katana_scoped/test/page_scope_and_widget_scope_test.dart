// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';

final _valueNotifierScopedQuery =
    ChangeNotifierScopedQuery((ref) => ValueNotifier(false));

class Page extends PageScopedWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final valueNotifier = ref.app.query(_valueNotifierScopedQuery);

    return Scaffold(
      body: Column(
        children: [
          const Internal(),
          Text(
            key: const ValueKey("pageValue"),
            valueNotifier.value.toString().toLowerCase(),
          ),
          GestureDetector(
            key: const ValueKey("gestureDetector"),
            onTap: () {
              valueNotifier.value = !valueNotifier.value;
            },
            child: const Text("Tap me"),
          ),
        ],
      ),
    );
  }
}

class Internal extends ScopedWidget {
  const Internal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueNotifier = ref.app.query(_valueNotifierScopedQuery);

    return Text(
      key: const ValueKey("widgetValue"),
      valueNotifier.value.toString().toLowerCase(),
    );
  }
}

void main() {
  testWidgets("ChangeNotifierScopedQuery.page_and_widget_scope",
      (WidgetTester tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(home: Page()),
      ),
    );
    expect(
      (find.byKey(const ValueKey("pageValue")).evaluate().single.widget as Text)
          .data,
      "false",
    );
    expect(
      (find.byKey(const ValueKey("widgetValue")).evaluate().single.widget
              as Text)
          .data,
      "false",
    );
    await tester.tap(find.byKey(const ValueKey("gestureDetector")));
    await tester.pump(const Duration(seconds: 1));
    expect(
      (find.byKey(const ValueKey("pageValue")).evaluate().single.widget as Text)
          .data,
      "true",
    );
    expect(
      (find.byKey(const ValueKey("widgetValue")).evaluate().single.widget
              as Text)
          .data,
      "true",
    );
  });
}
