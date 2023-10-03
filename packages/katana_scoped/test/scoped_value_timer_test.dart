// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';

class Page extends PageScopedWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context, PageRef ref) {
    return const Scaffold(
      body: Column(
        children: [
          Internal(),
        ],
      ),
    );
  }
}

class Internal extends ScopedWidget {
  const Internal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.widget.timer(
      duration: const Duration(seconds: 1),
      (currentTime, startTime) {
        debugPrint("timer updated");
      },
    );

    return Text(
      key: const ValueKey("widgetValue"),
      DateTime.now().toIso8601String(),
    );
  }
}

void main() {
  testWidgets("ScopedValue.timer", (WidgetTester tester) async {
    final appRef = AppRef();
    await tester.pumpWidget(
      AppScoped(
        appRef: appRef,
        child: const MaterialApp(home: Page()),
      ),
    );
    final dateTime = (find
            .byKey(const ValueKey("widgetValue"))
            .evaluate()
            .single
            .widget as Text)
        .data;
    expect(
      dateTime.isNotEmpty,
      true,
    );
    await tester.pump(const Duration(seconds: 3));
    expect(
      (find.byKey(const ValueKey("widgetValue")).evaluate().single.widget
                  as Text)
              .data !=
          dateTime,
      true,
    );
  });
}
