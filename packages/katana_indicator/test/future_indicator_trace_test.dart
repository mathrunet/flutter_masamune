// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana_logger/katana_logger.dart";

// Project imports:
import "package:katana_indicator/katana_indicator.dart";

void main() {
  late LoggerDatabase loggerDatabase;

  setUp(() {
    loggerDatabase = LoggerDatabase();
    TestLoggerAdapterScope.setTestAdapters([
      RuntimeLoggerAdapter(database: loggerDatabase),
    ]);
  });

  tearDown(() {
    TestLoggerAdapterScope.setTestAdapters(const []);
  });

  testWidgets("showIndicator emits one performance trace", (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              await completer.future.showIndicator(context);
            },
            child: const Text("start"),
          ),
        ),
      ),
    );

    await tester.tap(find.text("start"));
    await tester.pump();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();

    final logs = await loggerDatabase.read();
    final traceLogs = logs.values.where(
      (value) => value
          .get(LoggerDatabase.nameKey, "")
          .startsWith("$katanaIndicatorTracePrefix|"),
    );
    expect(traceLogs, hasLength(1));
    expect(
      traceLogs.single.get(LoggerDatabase.nameKey, ""),
      isNot(endsWith("|unknown")),
    );
  });

  testWidgets("trace names at the Firebase limit are preserved", (
    tester,
  ) async {
    final traceName = "a" * (100 - katanaIndicatorTracePrefix.length - 1);
    final expectedName = "$katanaIndicatorTracePrefix|$traceName";

    await tester.pumpWidget(
      MaterialApp(
        home: MeasuredCircularProgressIndicator(traceName: traceName),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    final names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""));
    expect(names, contains(expectedName));
  });

  testWidgets("long trace names are shortened deterministically", (
    tester,
  ) async {
    final traceName = "ExamplePage.${"longOperation" * 12}";

    for (var i = 0; i < 2; i++) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(i),
          home: MeasuredCircularProgressIndicator(traceName: traceName),
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    }

    final names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(names, hasLength(2));
    expect(names[0], names[1]);
    expect(names.first, hasLength(100));
    expect(names.first, matches(RegExp(r"-[0-9a-f]{8}$")));
  });

  testWidgets("long trace names with different suffixes stay distinct", (
    tester,
  ) async {
    final commonName = "ExamplePage.${"sharedOperation" * 12}";

    await tester.pumpWidget(
      MaterialApp(
        home: MeasuredCircularProgressIndicator(traceName: "${commonName}A"),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MeasuredCircularProgressIndicator(traceName: "${commonName}B"),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    final names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(names, hasLength(2));
    expect(names[0], isNot(names[1]));
    expect(names, everyElement(hasLength(100)));
    expect(names, everyElement(matches(RegExp(r"-[0-9a-f]{8}$"))));
  });

  testWidgets("measured circular indicator emits one named trace", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeasuredCircularProgressIndicator(
          traceName: "ExamplePage.initialLoad",
          color: Colors.red,
          strokeWidth: 3,
        ),
      ),
    );
    await tester.pump();

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.color, Colors.red);
    expect(indicator.strokeWidth, 3);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    final traceLogs = (await loggerDatabase.read())
        .values
        .where(
          (value) =>
              value.get(LoggerDatabase.nameKey, "") ==
              "$katanaIndicatorTracePrefix|ExamplePage.initialLoad",
        )
        .toList();
    expect(traceLogs, hasLength(1));
    expect(traceLogs.single.get("duration", -1), greaterThanOrEqualTo(0));
  });

  testWidgets("measured linear indicator emits one named trace", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeasuredLinearProgressIndicator(
          traceName: "DownloadPage.fileWait",
          value: 0.4,
          color: Colors.blue,
          minHeight: 6,
        ),
      ),
    );
    await tester.pump();

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.4);
    expect(indicator.color, Colors.blue);
    expect(indicator.minHeight, 6);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    final traceLogs = (await loggerDatabase.read()).values.where(
          (value) =>
              value.get(LoggerDatabase.nameKey, "") ==
              "$katanaIndicatorTracePrefix|DownloadPage.fileWait",
        );
    expect(traceLogs, hasLength(1));
  });

  testWidgets("rebuild keeps trace and trace name change rotates it", (
    tester,
  ) async {
    final traceName = ValueNotifier("ExamplePage.firstWait");
    addTearDown(traceName.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<String>(
          valueListenable: traceName,
          builder: (context, value, child) =>
              MeasuredCircularProgressIndicator(traceName: value),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(await loggerDatabase.read(), isEmpty);

    traceName.value = "ExamplePage.secondWait";
    await tester.pump();
    await tester.pump();

    var names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(
      names.where(
        (name) => name == "$katanaIndicatorTracePrefix|ExamplePage.firstWait",
      ),
      hasLength(1),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    names = (await loggerDatabase.read())
        .values
        .map((value) => value.get(LoggerDatabase.nameKey, ""))
        .toList();
    expect(
      names.where(
        (name) => name == "$katanaIndicatorTracePrefix|ExamplePage.secondWait",
      ),
      hasLength(1),
    );
  });

  testWidgets("adaptive measured indicator forwards material properties", (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeasuredCircularProgressIndicator.adaptive(
          traceName: "ExamplePage.adaptiveWait",
          value: 0.25,
          backgroundColor: Colors.black,
          strokeWidth: 5,
        ),
      ),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 0.25);
    expect(indicator.backgroundColor, Colors.black);
    expect(indicator.strokeWidth, 5);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
