// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("NullableIterableExtensions.isEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.isEmpty, false);
    expect([].isEmpty, true);
    expect(nullArray.isEmpty, true);
  });
  test("NullableIterableExtensions.isNotEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.isNotEmpty, true);
    expect([].isNotEmpty, false);
    expect(nullArray.isNotEmpty, false);
  });
  test("NullableIterableExtensions.length", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.length, 8);
    expect([].length, 0);
    expect(nullArray.length, 0);
  });
  test("NullableIterableExtensions.firstOrNull", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.firstOrNull, 1);
    expect([].firstOrNull, null);
    expect(nullArray.firstOrNull, null);
  });
  test("NullableIterableExtensions.lastOrNull", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.lastOrNull, 9);
    expect([].lastOrNull, null);
    expect(nullArray.lastOrNull, null);
  });
  test("NullableIterableExtensions.firstWhereOrNull", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.firstWhereOrNull((item) => item % 4 == 0), 8);
    expect(array.firstWhereOrNull((item) => item % 5 == 2), null);
    expect(nullArray.firstWhereOrNull((item) => item % 5 == 2), null);
  });
  test("NullableIterableExtensions.contains", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.contains(1), true);
    expect(array.contains(10), false);
    expect(nullArray.contains(1), false);
  });
  test("NullableIterableExtensions.containsAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.containsAny([3, 10, 12]), true);
    expect(array.containsAny([7, 10, 12]), false);
    expect(nullArray.containsAny([7, 10, 12]), false);
  });
  test("NullableIterableExtensions.containsAll", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable<int>? array = [1, 1, 3, 5, 6, 8, 9, 9];
    const Iterable<int>? nullArray = null;
    expect(array.containsAll([3, 5, 8]), true);
    expect(array.containsAll([3, 10, 12]), false);
    expect(nullArray.containsAll([7, 10, 12]), false);
  });
  test("NullableIterableExtensions.equalsTo", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable? array1 = [
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable? array2 = [
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Iterable? array3 = [
      "aa",
      "dd",
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    ];
    const Iterable? array4 = null;
    const Iterable? array5 = null;
    expect(array1.equalsTo(array2), true);
    expect(array1.equalsTo(array3), false);
    expect(array1.equalsTo(array4), false);
    expect(array5.equalsTo(array4), true);
  });
}
