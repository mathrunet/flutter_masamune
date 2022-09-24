import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("NullableIntExtensions.isEmpty", () {
    const int? val = null;
    expect(val.isEmpty, true);
    expect(0.isEmpty, true);
    expect(1.isEmpty, false);
  });
  test("NullableIntExtensions.isNotEmpty", () {
    const int? val = null;
    expect(val.isNotEmpty, false);
    expect(0.isNotEmpty, false);
    expect(1.isNotEmpty, true);
  });
}
