// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:katana_scoped/katana_scoped.dart';

import 'finder_extensions.dart';

void main() {
  testWidgets("Value.on", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: ValueOnPage(),
        ),
      ),
    );
    await tester.pump();
    expect(text("waiting")?.data, "0");
    expect(text("done"), null);
    await tester.pumpAndSettle(const Duration(milliseconds: 1500));
    expect(text("wating"), null);
    expect(text("done")?.data, "1");
  });
}

class ValueOnPage extends PageScopedWidget {
  const ValueOnPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final init = ref.page.on(initOrUpdate: () async {
      await Future.delayed(const Duration(milliseconds: 1000));
    });
    return Scaffold(
      body: FutureBuilder<void>(
        future: init.initOrUpdating,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Text(
              "0",
              key: ValueKey("waiting"),
            );
          } else {
            return const Text(
              "1",
              key: ValueKey("done"),
            );
          }
        },
      ),
    );
  }
}
