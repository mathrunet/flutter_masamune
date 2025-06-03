// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("NullableValueIterableExtensions.removeEmpty", () {
    final array = [1, null, 2, null, 3];
    expect(array.removeEmpty(), [1, 2, 3]);
  });
}
