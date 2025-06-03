// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("IntIterableExtensions.nearestOrNull", () {
    final ints = [1, 2, 5, 100];
    expect(ints.nearestOrNull(1.4), 1);
    expect(ints.nearestOrNull(3.2), 2);
    expect(ints.nearestOrNull(-100), 1);
    expect(ints.nearestOrNull(100), 100);
    expect(ints.nearestOrNull(8), 5);
    expect(ints.nearestOrNull(5000), 100);
    expect(<int>[].nearestOrNull(5000), null);
  });
  test("IntIterableExtensions.sum", () {
    final ints = [1, 2, 3, 4];
    expect(ints.sum(), 10);
  });
  test("IntIterableExtensions.average", () {
    final ints = [1, 2, 3, 4];
    expect(ints.average(), 2.5);
  });
  test("IntIterableExtensions.min", () {
    final ints = [1, 2, 3, 4];
    expect(ints.min(), 1);
  });
  test("IntIterableExtensions.max", () {
    final ints = [1, 2, 3, 4];
    expect(ints.max(), 4);
  });
  test("IntIterableExtensions.variance", () {
    final ints = [1, 2, 3, 4];
    expect(ints.variance(), 1.25);
  });
  test("IntIterableExtensions.standardDeviation", () {
    final ints = [1, 2, 3, 4];
    expect(ints.standardDeviation(), 1.118033988749895);
  });
  test("IntIterableExtensions.smoothing", () {
    final ints = [1, 9, 5, 4, 3];
    expect(ints.smoothing(), [5, 5, 6, 4, 3.5]);
  });
}
