// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

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
}
