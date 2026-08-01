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
}
