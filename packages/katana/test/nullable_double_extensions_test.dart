// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("NullableDoubleExtensions.isEmpty", () {
    const double? val = null;
    expect(val.isEmpty, true);
    expect(0.0.isEmpty, true);
    expect(1.0.isEmpty, false);
  });
  test("NullableDoubleExtensions.isNotEmpty", () {
    const double? val = null;
    expect(val.isNotEmpty, false);
    expect(0.0.isNotEmpty, false);
    expect(1.0.isNotEmpty, true);
  });
  test("NullableDoubleExtensions.operator", () {
    const double? a = null;
    const int b = 10;
    const int c = 20;
    const double d = 30;
    expect(a + b, 10);
    expect(a - b, 10);
    expect(a * c, 20);
    expect(a / d, 30);
    expect(b + c, 30);
    expect(b - b, 0);
    expect(c * c, 400);
    expect(c / b, 2);
  });
}
