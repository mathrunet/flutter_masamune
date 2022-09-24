import 'dart:math';

import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("RandomExtensions.format", () {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      final val = random.rangeInt(0, 100);
      expect(0 <= val && val < 100, true);
    }
    for (int i = 0; i < 100; i++) {
      final val = random.rangeDouble(0, 100);
      expect(0 <= val && val < 100, true);
    }
  });
}
