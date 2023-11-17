// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("DoubleIterableExtensions.nearestOrNull", () {
    final doubles = [1.0, 2.0, 5.0, 100.0];
    expect(doubles.nearestOrNull(1.4), 1.0);
    expect(doubles.nearestOrNull(3.2), 2.0);
    expect(doubles.nearestOrNull(-100), 1.0);
    expect(doubles.nearestOrNull(100), 100.0);
    expect(doubles.nearestOrNull(8), 5.0);
    expect(doubles.nearestOrNull(5000), 100.0);
    expect(doubles.nearestOrNull(double.nan), null);
  });
  test("DoubleIterableExtensions.average", () {
    final doubles = [1.0, 2.0, 3.0, 4.0];
    expect(doubles.average(), 2.5);
  });
  test("DoubleIterableExtensions.min", () {
    final doubles = [1.0, 2.0, 3.0, 4.0];
    expect(doubles.min(), 1);
  });
  test("DoubleIterableExtensions.max", () {
    final doubles = [1.0, 2.0, 3.0, 4.0];
    expect(doubles.max(), 4);
  });
  test("DoubleIterableExtensions.variance", () {
    final doubles = [1.0, 2.0, 3.0, 4.0];
    expect(doubles.variance(), 1.25);
  });
  test("DoubleIterableExtensions.standardDeviation", () {
    final doubles = [1.0, 2.0, 3.0, 4.0];
    expect(doubles.standardDeviation(), 1.118033988749895);
  });
}
