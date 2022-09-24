import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("IntExtensions.isEmpty", () {
    expect(0.isEmpty, true);
    expect(1.isEmpty, false);
  });
  test("IntExtensions.isNotEmpty", () {
    expect(0.isNotEmpty, false);
    expect(1.isNotEmpty, true);
  });
  test("IntExtensions.replaceNanOrInfinite", () {
    expect(1.replaceNanOrInfinite(), 1);
    expect(10.replaceNanOrInfinite(100), 10);
  });
  test("IntExtensions.limit", () {
    expect(9.limit(10, 100), 10);
    expect(10.limit(10, 100), 10);
    expect(50.limit(10, 100), 50);
    expect(100.limit(10, 100), 100);
    expect(101.limit(10, 100), 100);
  });
  test("IntExtensions.limitLow", () {
    expect(9.limitLow(10), 10);
    expect(10.limitLow(10), 10);
    expect(50.limitLow(10), 50);
    expect(100.limitLow(10), 100);
    expect(101.limitLow(10), 101);
  });
  test("IntExtensions.limitHigh", () {
    expect(9.limitHigh(100), 9);
    expect(10.limitHigh(100), 10);
    expect(50.limitHigh(100), 50);
    expect(100.limitHigh(100), 100);
    expect(101.limitHigh(100), 100);
  });
  test("IntExtensions.format", () {
    expect(12.format("000"), "012");
  });
}
