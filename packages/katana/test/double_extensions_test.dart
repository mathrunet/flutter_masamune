// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("DoubleExtensions.isEmpty", () {
    expect(0.0.isEmpty, true);
    expect(1.0.isEmpty, false);
  });
  test("DoubleExtensions.isNotEmpty", () {
    expect(0.0.isNotEmpty, false);
    expect(1.0.isNotEmpty, true);
  });
  test("DoubleExtensions.replaceNanOrInfinite", () {
    expect(1.0.replaceNanOrInfinite(), 1.0);
    expect(10.0.replaceNanOrInfinite(100.0), 10.0);
    expect(double.nan.replaceNanOrInfinite(), 0.0);
    expect(double.infinity.replaceNanOrInfinite(), 0.0);
    expect(double.nan.replaceNanOrInfinite(20.0), 20.0);
    expect(double.infinity.replaceNanOrInfinite(30.0), 30.0);
  });
  test("DoubleExtensions.limit", () {
    expect(9.0.limit(10, 100), 10.0);
    expect(10.0.limit(10, 100), 10.0);
    expect(50.0.limit(10, 100), 50.0);
    expect(100.0.limit(10, 100), 100.0);
    expect(101.0.limit(10, 100), 100.0);
    expect(double.nan.limit(10, 100), 10.0);
    expect(double.infinity.limit(10, 100), 100.0);
  });
  test("DoubleExtensions.limitLow", () {
    expect(9.0.limitLow(10), 10.0);
    expect(10.0.limitLow(10), 10.0);
    expect(50.0.limitLow(10), 50.0);
    expect(100.0.limitLow(10), 100.0);
    expect(101.0.limitLow(10), 101.0);
    expect(double.nan.limitLow(10), 10.0);
    expect(double.infinity.limitLow(10), double.infinity);
  });
  test("DoubleExtensions.limitHigh", () {
    expect(9.0.limitHigh(100), 9.0);
    expect(10.0.limitHigh(100), 10.0);
    expect(50.0.limitHigh(100), 50.0);
    expect(100.0.limitHigh(100), 100.0);
    expect(101.0.limitHigh(100), 100.0);
    expect(double.nan.limitHigh(100), 100.0);
    expect(double.infinity.limit(10, 100), 100.0);
  });
  test("DoubleExtensions.format", () {
    expect(12.343.format("###.0#"), "12.34");
  });
  test("DoubleExtensions.roundBy", () {
    expect(12.343.roundBy(2), 12.34);
  });
}
