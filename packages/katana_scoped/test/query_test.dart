// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";

// Project imports:
import "package:katana_scoped/katana_scoped.dart";
import "test_extensions.dart";

void main() {
  testWidgets("Scoped.Value.watch.chain", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: ValueQueryPage(),
        ),
      ),
    );
    await tester.pump();
    expect(text("app1_text")?.data, "0");
    expect(text("app2_text")?.data, "0.0");
    // expect(text("page1_text")?.data, "0");
    // expect(text("page2_text")?.data, "0");
    // expect(text("widget1_text")?.data, "0");
    // expect(text("widget2_text")?.data, "0");
    await tester.tapByKey("app1");
    await tester.pump();
    expect(text("app1_text")?.data, "1");
    expect(text("app2_text")?.data, "0.0");
    // expect(text("page1_text")?.data, "0");
    // expect(text("page2_text")?.data, "0");
    // expect(text("widget1_text")?.data, "0");
    // expect(text("widget2_text")?.data, "0");
    await tester.tapByKey("app1");
    await tester.pump();
    expect(text("app1_text")?.data, "2");
    expect(text("app2_text")?.data, "0.0");
    // expect(text("page1_text")?.data, "0");
    // expect(text("page2_text")?.data, "0");
    // expect(text("widget1_text")?.data, "0");
    // expect(text("widget2_text")?.data, "0");
    await tester.tapByKey("app2");
    await tester.pump();
    await tester.pump();
    expect(text("app1_text")?.data, "1");
    expect(text("app2_text")?.data, "1.0");
    // expect(text("page1_text")?.data, "0");
    // expect(text("page2_text")?.data, "0");
    // expect(text("widget1_text")?.data, "0");
    // expect(text("widget2_text")?.data, "0");
    await tester.tapByKey("app1");
    await tester.pump();
    expect(text("app1_text")?.data, "2");
    expect(text("app2_text")?.data, "1.0");
    await tester.tapByKey("app1");
    await tester.pump();
    expect(text("app1_text")?.data, "3");
    expect(text("app2_text")?.data, "1.0");
    await tester.tapByKey("app2");
    await tester.pump();
    await tester.pump();
    expect(text("app1_text")?.data, "2");
    expect(text("app2_text")?.data, "2.0");
  });
}

final widgetQuery1 = ChangeNotifierScopedQuery((ref) {
  final v2 = ref.query(widgetQuery2);
  return ValueNotifier(v2.value);
});

final widgetQuery2 = ScopedQuery((ref) {
  return ValueNotifier(0);
});

final pageQuery1 = ChangeNotifierScopedQuery((ref) {
  final v2 = ref.query(pageQuery2);
  return ValueNotifier(v2.value);
});

final pageQuery2 = ScopedQuery((ref) {
  return ValueNotifier(0);
});

final appQuery1 = ChangeNotifierScopedQuery((ref) {
  final v2 = ref.query(appQuery2);
  return ValueNotifier(v2.value.toInt());
});

final appQuery2 = ChangeNotifierScopedQuery((ref) {
  return ValueNotifier(0.0);
});

class ValueQueryPage extends PageScopedWidget {
  const ValueQueryPage({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          focusNode.hashCode.toString(),
          key: const ValueKey("title"),
        ),
      ),
      body: const ValueQueryContent(),
    );
  }
}

class ValueQueryContent extends ScopedWidget {
  const ValueQueryContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app1 = ref.app.query(appQuery1);
    final app2 = AppScoped.of(context)?.query(appQuery2);

    return Column(children: [
      ListTile(
        key: const ValueKey("app1"),
        title: Text(app1.value.toString(), key: const ValueKey("app1_text")),
        onTap: () {
          app1.value++;
        },
      ),
      ListTile(
        key: const ValueKey("app2"),
        title: Text(app2!.value.toString(), key: const ValueKey("app2_text")),
        onTap: () {
          app2.value++;
        },
      ),
    ]);
  }
}
