// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("IterableExtensions.distinct", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.distinct(), [1, 3, 5, 6, 8, 9]);
    expect(array.distinct((i) => i % 3), [1, 3, 5]);
    final array2 = [1, null, 1, 3, 6, 9, null, 9];
    expect(array2.distinct(), [1, null, 3, 6, 9]);
    expect(array2.distinct((i) => i % 3), [1, null, 3]);
  });
  test("IterableExtensions.firstOrNull", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.firstOrNull, 1);
    expect([].firstOrNull, null);
  });
  test("IterableExtensions.lastOrNull", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.lastOrNull, 9);
    expect([].lastOrNull, null);
  });
  test("IterableExtensions.firstWhereOrNull", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.firstWhereOrNull((item) => item % 4 == 0), 8);
    expect(array.firstWhereOrNull((item) => item % 5 == 2), null);
  });
  test("IterableExtensions.lastWhereOrNull", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.lastWhereOrNull((item) => item % 3 == 0), 9);
    expect(array.lastWhereOrNull((item) => item % 5 == 2), null);
  });
  test("IterableExtensions.mapAndRemoveEmpty", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(
      array.mapAndRemoveEmpty((item) => item.isOdd ? null : item),
      [6, 8],
    );
  });
  test("IterableExtensions.expandAndRemoveEmpty", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(
      array.expandAndRemoveEmpty(
        (item) => [
          if (item.isOdd) ...[item, item],
        ],
      ),
      [1, 1, 1, 1, 3, 3, 5, 5, 9, 9, 9, 9],
    );
  });
  test("IterableExtensions.split", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(
      array.split(3),
      [
        [1, 1, 3],
        [5, 6, 8],
        [9, 9]
      ],
    );
  });
  test("IterableExtensions.splitWhere", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(
      array.splitWhere((a, b) => a == b),
      [
        [1, 1],
        [3],
        [5],
        [6],
        [8],
        [9, 9]
      ],
    );
  });
  test("IterableExtensions.toMap", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(
      array.toMap((item) => MapEntry(item.toString(), item)),
      {
        "1": 1,
        "3": 3,
        "5": 5,
        "6": 6,
        "8": 8,
        "9": 9,
      },
    );
  });
  test("IterableExtensions.limit", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.limit(1, 3), [1, 3]);
  });
  test("IterableExtensions.limitStart", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.limitStart(1), [1, 3, 5, 6, 8, 9, 9]);
  });
  test("IterableExtensions.limitEnd", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.limitEnd(3), [1, 1, 3]);
  });
  test("IterableExtensions.containsAny", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.containsAny([3, 10, 12]), true);
    expect(array.containsAny([7, 10, 12]), false);
  });
  test("IterableExtensions.containsAll", () {
    final array = [1, 1, 3, 5, 6, 8, 9, 9];
    expect(array.containsAll([3, 5, 8]), true);
    expect(array.containsAll([3, 10, 12]), false);
  });
  test("IterableExtensions.setWhere", () {
    final colors = <Map<String, dynamic>>[
      {"id": 1, "color": "red"},
      {"id": 2, "color": "green"},
      {"id": 5, "color": "yellow"}
    ];
    final fruits = <Map<String, dynamic>>[
      {"id": 1, "fruits": "strawberry"},
      {"id": 3, "fruits": "orange"},
      {"id": 5, "fruits": "banana"}
    ];
    expect(
      colors.setWhere(
        fruits,
        test: (original, other) => original["id"] == other["id"],
        apply: (original, other) => original..["fruits"] = other["fruits"],
      ),
      [
        {"id": 1, "color": "red", "fruits": "strawberry"},
        {"id": 5, "color": "yellow", "fruits": "banana"}
      ],
    );
  });
  test("IterableExtensions.insertEvery", () {
    final array = [1, 3, 5, 7, 9, 11, 12];
    expect(array.insertEvery(2, 2), [1, 3, 2, 5, 7, 2, 9, 11, 2, 12]);
    expect(array.insertEvery(2, 3), [1, 3, 5, 2, 7, 9, 11, 2, 12]);
  });
  test("IterableExtensions.equalsTo", () {
    final array1 = [
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    final array2 = [
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    final array3 = [
      "aa",
      "dd",
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    expect(array1.equalsTo(array2), true);
    expect(array1.equalsTo(array3), false);
  });
}
