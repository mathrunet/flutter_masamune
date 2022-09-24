import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("NullableSetExtensions.isEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.isEmpty, false);
    expect(<int>{}.isEmpty, true);
    expect(nullSet.isEmpty, true);
  });
  test("NullableSetExtensions.isNotEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.isNotEmpty, true);
    expect(<int>{}.isNotEmpty, false);
    expect(nullSet.isNotEmpty, false);
  });
  test("NullableSetExtensions.length", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.length, 6);
    expect(<int>{}.length, 0);
    expect(nullSet.length, 0);
  });
  test("NullableSetExtensions.contains", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.contains(1), true);
    expect(set.contains(10), false);
    expect(nullSet.contains(1), false);
  });
  test("NullableSetExtensions.containsAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.containsAny([3, 10, 12]), true);
    expect(set.containsAny([7, 10, 12]), false);
    expect(nullSet.containsAny([7, 10, 12]), false);
  });
  test("NullableSetExtensions.containsAll", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set<int>? set = {1, 3, 5, 6, 8, 9};
    const Set<int>? nullSet = null;
    expect(set.containsAll([3, 5, 8]), true);
    expect(set.containsAll([3, 10, 12]), false);
    expect(nullSet.containsAll([7, 10, 12]), false);
  });
  test("NullableSetExtensions.equalsTo", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Set? set1 = {
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
    final Set? set2 = {
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
    final Set? set3 = {
      "aa",
      "dd",
      5,
      ["cc", 4],
      9.5,
      {"aa": "dd", "bb": 6},
      12,
      {"9d8", 192}
    };
    const Set? set4 = null;
    const Set? set5 = null;
    expect(set1.equalsTo(set2), true);
    expect(set1.equalsTo(set3), false);
    expect(set1.equalsTo(set4), false);
    expect(set5.equalsTo(set4), true);
  });
}
