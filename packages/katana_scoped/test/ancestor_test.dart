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

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';
import 'test_extensions.dart';

void main() {
  testWidgets("Scoped.ancestor", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: AncestorPage(),
        ),
      ),
    );
    await tester.pump();
    expect(text("title")?.data, "AncestorPage");
    expect(text("ancestor")?.data, "AncestorPage");
    expect(text("child")?.data, "ChildContent");
  });
}

class AncestorPage extends PageScopedWidget {
  const AncestorPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final ancestor = context.ancestor<AncestorPage>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ancestor.runtimeType.toString(),
          key: const ValueKey("title"),
        ),
      ),
      body: const ChildContent(),
    );
  }
}

class ChildContent extends ScopedWidget {
  const ChildContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ancestor = context.ancestor<AncestorPage>();
    final child = context.ancestor<ChildContent>();

    return Column(children: [
      ListTile(
        title: Text(
          ancestor.runtimeType.toString(),
          key: const ValueKey("ancestor"),
        ),
      ),
      ListTile(
        title: Text(
          child.runtimeType.toString(),
          key: const ValueKey("child"),
        ),
      ),
    ]);
  }
}
