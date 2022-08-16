import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("nullIntOperator", () {
    const int? a = null;
    const int b = 10;
    const int c = 20;
    const int d = 30;
    expect(a + b, 10);
    expect(a - b, 10);
    expect(a * c, 20);
    expect(a / d, 30);
    expect(b + c, 30);
    expect(b - b, 0);
    expect(c * c, 400);
    expect(c / b, 2);
  });
  test("nullDoubleOperator", () {
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
  test("splitWhere", () async {
    expect(
      [
        ...List.generate(10, (i) => DateTime(2021, 1, i + 1)),
        ...List.generate(10, (i) => DateTime(2021, 2, i + 1)),
        ...List.generate(10, (i) => DateTime(2021, 3, i + 1)),
      ].splitWhere((a, b) => a.year == b.year && a.month == b.month),
      [
        List.generate(10, (i) => DateTime(2021, 1, i + 1)),
        List.generate(10, (i) => DateTime(2021, 2, i + 1)),
        List.generate(10, (i) => DateTime(2021, 3, i + 1)),
      ],
    );
  });
  test("insertEvery", () async {
    expect(
      ["a", "b", "c", "d", "e"].insertEvery("0", 1),
      ["a", "0", "b", "0", "c", "0", "d", "0", "e"],
    );
    expect(
      ["a", "b", "c", "d", "e"].insertEvery("0", 2),
      ["a", "b", "0", "c", "d", "0", "e"],
    );
    expect(
      ["a", "b", "c", "d", "e"].insertEvery("0", 3),
      ["a", "b", "c", "0", "d", "e"],
    );
  });
}
