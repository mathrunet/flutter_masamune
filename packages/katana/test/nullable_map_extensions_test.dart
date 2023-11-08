// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("NullableMapExtensions.isEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.isEmpty, false);
    expect(<String, int>{}.isEmpty, true);
    expect(nullMap.isEmpty, true);
  });
  test("NullableMapExtensions.isNotEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.isNotEmpty, true);
    expect(<String, int>{}.isNotEmpty, false);
    expect(nullMap.isNotEmpty, false);
  });
  test("NullableMapExtensions.length", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.length, 3);
    expect(<String, int>{}.length, 0);
    expect(nullMap.length, 0);
  });
  test("NullableMapExtensions.containsKey", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsKey("a"), true);
    expect(map.containsKey("d"), false);
    expect(nullMap.containsKey("a"), false);
  });
  test("NullableMapExtensions.containsValue", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsValue(1), true);
    expect(map.containsValue(5), false);
    expect(nullMap.containsValue(1), false);
  });
  test("NullableMapExtensions.get", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    const Map<String, int>? nullMap = null;
    expect(map.get("a", ""), "a");
    expect(map.get("b", ""), "");
    expect(map.get("b", 0), 1);
    expect(map.get("c", 1.2), 1.5);
    expect(map.get("d", <int>[]), [1, 2, 3]);
    expect(map.get("d", <double>[]), []);
    expect(map.get("e", <String, dynamic>{}), {"a": 1, "b": 2});
    expect(map.get("e", []), []);
    expect(map.get("f", DateTime(2000, 1, 1)), DateTime(2001, 1, 1));
    expect(nullMap.get("a", ""), "");
  });
  test("NullableMapExtensions.getAsInt", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsInt("a", 0), 0);
    expect(map.getAsInt("b", 0), 1);
    expect(nullMap.getAsInt("a", 0), 0);
  });
  test("NullableMapExtensions.getAsDouble", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsDouble("a", 0), 0);
    expect(map.getAsDouble("b", 0), 1);
    expect(map.getAsDouble("c", 0), 1.5);
    expect(nullMap.getAsDouble("a", 0), 0);
  });
  test("NullableMapExtensions.getAsList", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsList("a"), []);
    expect(map.getAsList("d"), [1, 2, 3]);
    expect(nullMap.getAsList("a"), []);
  });
  test("NullableMapExtensions.getAsSet", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1),
      "g": {"a", "b", "c"}
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsSet("a"), <dynamic>{});
    expect(map.getAsSet("g"), {"a", "b", "c"});
    expect(nullMap.getAsList("a"), <dynamic>{});
  });
  test("NullableMapExtensions.getAsMap", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1),
      "g": {"a", "b", "c"}
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsMap("a"), <String, dynamic>{});
    expect(map.getAsMap("e"), {"a": 1, "b": 2});
    expect(nullMap.getAsMap("a"), <String, dynamic>{});
  });
  test("NullableMapExtensions.getAsDateTime", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1),
      "g": {"a", "b", "c"}
    };
    const Map<String, int>? nullMap = null;
    expect(map.getAsDateTime("f"), DateTime(2001, 1, 1));
    expect(map.getAsDateTime("b"), DateTime.fromMillisecondsSinceEpoch(1));
    expect(map.getAsDateTime("a", DateTime(2000, 1, 1)), DateTime(2000, 1, 1));
    expect(
      nullMap.getAsDateTime("a", DateTime(2000, 1, 1)),
      DateTime(2000, 1, 1),
    );
  });
  test("NullableMapExtensions.containsKeyAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsKeyAny(["a", "e", "f"]), true);
    expect(map.containsKeyAny(["g", "e", "f"]), false);
    expect(nullMap.containsKeyAny(["g", "e", "f"]), false);
  });
  test("NullableMapExtensions.containsKeyAll", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsKeyAll(["a", "b", "c"]), true);
    expect(map.containsKeyAll(["g", "e", "c"]), false);
    expect(nullMap.containsKeyAll(["g", "e", "c"]), false);
  });
  test("NullableMapExtensions.containsValueAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsValueAny([1, 5, 6]), true);
    expect(map.containsValueAny([4, 5, 6]), false);
    expect(nullMap.containsValueAny([4, 5, 6]), false);
  });
  test("NullableMapExtensions.containsValueAll", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, int>? map = {"a": 1, "b": 2, "c": 3};
    const Map<String, int>? nullMap = null;
    expect(map.containsValueAll([1, 2, 3]), true);
    expect(map.containsValueAll([3, 5, 6]), false);
    expect(nullMap.containsValueAll([3, 5, 6]), false);
  });
  test("NullableMapExtensions.equalsTo", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? array1 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? array2 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? array3 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 6],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Map<String, dynamic>? array4 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "i": {"9d8", 192}
    };
    const Map<String, dynamic>? array5 = null;
    const Map<String, dynamic>? array6 = null;
    expect(array1.equalsTo(array2), true);
    expect(array1.equalsTo(array3), false);
    expect(array1.equalsTo(array4), false);
    expect(array1.equalsTo(array5), false);
    expect(array6.equalsTo(array5), true);
  });
}
