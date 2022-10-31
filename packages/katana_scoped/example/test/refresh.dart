// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:katana_scoped/katana_scoped.dart';

import 'finder_extensions.dart';

void main() {
  testWidgets("Value.refresh", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: ValueRefreshPage(),
        ),
      ),
    );
    await tester.pump();
    final before = text("count")!.data;
    await tester.tapWithIcon(Icons.add);
    await tester.pump();
    expect(text("count")?.data != before, true);
  });
}

class ValueRefreshPage extends PageScopedWidget {
  const ValueRefreshPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final focusNode = FocusNode();
    return Scaffold(
      body: Center(
        child: Text(
          focusNode.hashCode.toString(),
          key: const ValueKey("count"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.page.refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
