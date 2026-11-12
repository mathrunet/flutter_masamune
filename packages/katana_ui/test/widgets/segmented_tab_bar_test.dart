// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";

// Project imports:
import "package:katana_ui/katana_ui.dart";

void main() {
  Widget buildApp({ValueChanged<int>? onTap}) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            children: [
              SegmentedTabBar(
                onTap: onTap,
                tabs: const [
                  Tab(text: "First"),
                  Tab(text: "Second"),
                  Tab(text: "Third"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text("Page 1")),
                    Center(child: Text("Page 2")),
                    Center(child: Text("Page 3")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TabController controllerOf(WidgetTester tester) {
    return DefaultTabController.of(tester.element(find.byType(TabBarView)));
  }

  testWidgets("SegmentedTabBar renders all tabs", (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.text("First"), findsOneWidget);
    expect(find.text("Second"), findsOneWidget);
    expect(find.text("Third"), findsOneWidget);
    expect(find.text("Page 1"), findsOneWidget);
  });

  testWidgets("SegmentedTabBar switches tabs on tap", (tester) async {
    final tapped = <int>[];
    await tester.pumpWidget(buildApp(onTap: tapped.add));

    await tester.tap(find.text("Third"));
    await tester.pumpAndSettle();

    expect(tapped, [2]);
    expect(controllerOf(tester).index, 2);
    expect(find.text("Page 3"), findsOneWidget);
  });

  testWidgets("SegmentedTabBar follows horizontal swipes", (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.fling(find.text("Page 1"), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(controllerOf(tester).index, 1);
    expect(find.text("Page 2"), findsOneWidget);
  });

  testWidgets("SegmentedTabBar reports preferred size with margin", (
    tester,
  ) async {
    const bar = SegmentedTabBar(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8),
      tabs: [Tab(text: "A")],
    );

    expect(bar.preferredSize.height, 56);
  });
}
