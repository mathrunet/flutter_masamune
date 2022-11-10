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
  testWidgets("Value.watch", (tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(
          home: ValueWatchPage(),
        ),
      ),
    );
    await tester.pump();
    expect(text("app_text")?.data, "0");
    expect(text("page_text")?.data, "0");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("app");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "0");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("page");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "0");
    await tester.tapByKey("widget");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "0.0");
    expect(text("widget_text")?.data, "1");
    await tester.tapByKey("page_with_double");
    await tester.pump();
    expect(text("app_text")?.data, "1");
    expect(text("page_text")?.data, "1");
    expect(text("page_text_with_double")?.data, "1.0");
    expect(text("widget_text")?.data, "1");
  });
}

class ValueWatchPage extends PageScopedWidget {
  const ValueWatchPage({super.key});

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
      body: const ValueWatchContent(),
    );
  }
}

class ValueWatchContent extends ScopedWidget {
  const ValueWatchContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = ref.widget.watch(() => ValueNotifier(0));
    final page = ref.page.watch(() => ValueNotifier(0));
    final pageWithDouble = ref.page.watch(() => ValueNotifier(0.0));
    final app = ref.app.watch(() => ValueNotifier(0));

    return Column(children: [
      ListTile(
        key: const ValueKey("app"),
        title: Text(app.value.toString(), key: const ValueKey("app_text")),
        onTap: () {
          app.value++;
        },
      ),
      ListTile(
        key: const ValueKey("page"),
        title: Text(page.value.toString(), key: const ValueKey("page_text")),
        onTap: () {
          page.value++;
        },
      ),
      ListTile(
        key: const ValueKey("page_with_double"),
        title: Text(
          pageWithDouble.value.toString(),
          key: const ValueKey("page_text_with_double"),
        ),
        onTap: () {
          pageWithDouble.value++;
        },
      ),
      ListTile(
        key: const ValueKey("widget"),
        title:
            Text(widget.value.toString(), key: const ValueKey("widget_text")),
        onTap: () {
          widget.value++;
        },
      ),
    ]);
  }
}
