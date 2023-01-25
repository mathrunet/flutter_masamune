// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("SetExtensions.containsAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final set = {1, 3, 5, 6, 8, 9};
    expect(set.containsAny([3, 10, 12]), true);
    expect(set.containsAny([7, 10, 12]), false);
  });
  test("SetExtensions.containsAll", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final set = {1, 3, 5, 6, 8, 9};
    expect(set.containsAll([3, 5, 8]), true);
    expect(set.containsAll([3, 10, 12]), false);
  });
  test("SetExtensions.equalsTo", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final set1 = {
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    };
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final set2 = {
      "aa",
      3,
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    };
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final set3 = {
      "aa",
      "dd",
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    };
    expect(set1.equalsTo(set2), true);
    expect(set1.equalsTo(set3), false);
  });
}
