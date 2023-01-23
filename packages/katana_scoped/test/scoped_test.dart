import 'package:flutter/material.dart';
import 'package:katana_scoped/katana_scoped.dart';
import 'package:test/test.dart';

void main() {
  test("Dispose Test", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ScopedValueContainer();
    final appRef = AppRef(scopedValueContainer: container);
    final n1 = appRef.watch((ref) => ValueNotifier(0));
    expect(n1.value, 0);
    n1.value = 1;
    final n2 = appRef.watch((ref) => ValueNotifier(0));
    expect(n2.value, 1);
    expect(n1 == n2, true);
    appRef.dispose();
    final n3 = appRef.watch((ref) => ValueNotifier(2));
    expect(n3.value, 2);
    expect(n1 != n3, true);
    n3.value = 4;
    final n4 = appRef.watch((ref) => ValueNotifier(2));
    expect(n4.value, 4);
    expect(n3 == n4, true);
  });
}
