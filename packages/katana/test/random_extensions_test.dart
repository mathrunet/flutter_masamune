// Dart imports:
import "dart:math";

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

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
