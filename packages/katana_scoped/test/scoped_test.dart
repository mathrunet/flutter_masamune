// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_scoped/katana_scoped.dart';

void main() {
  test("Logger Test", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ScopedValueContainer();
    const logger = RuntimeLoggerAdapter();
    final appRef = AppRef(
      scopedValueContainer: container,
      loggerAdapters: const [logger],
    );
    appRef.watch((ref) => ValueNotifier(0), name: "1");
    appRef.watch((ref) => ValueNotifier(0), name: "2");
    appRef.watch((ref) => ValueNotifier(2), name: "3");
    appRef.watch((ref) => ValueNotifier(2), name: "4");
    appRef.clear();
    expect(
        (await logger.logList())
            .map((e) => "${e.name}: ${e.parameters.get("name", "")}"),
        [
          for (var i = 1; i <= 4; i++) "ScopedLoggerEvent.init: $i",
          for (var i = 1; i <= 4; i++) "ScopedLoggerEvent.dispose: $i"
        ]);
  });
  test("Reset Test", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ScopedValueContainer();
    final appRef = AppRef(scopedValueContainer: container);
    final n1 = appRef.watch((ref) => ValueNotifier(0));
    expect(n1.value, 0);
    n1.value = 1;
    final n2 = appRef.watch((ref) => ValueNotifier(0));
    expect(n2.value, 1);
    expect(n1 == n2, true);
    appRef.clear();
    final n3 = appRef.watch((ref) => ValueNotifier(2));
    expect(n3.value, 2);
    expect(n1 != n3, true);
    n3.value = 4;
    final n4 = appRef.watch((ref) => ValueNotifier(2));
    expect(n4.value, 4);
    expect(n3 == n4, true);
  });
}
