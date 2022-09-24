import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("MapExtensions.toList", () {
    final map = {1: 1, 4: 2, 6: 3};
    expect(map.toList((k, v) => k + v), [2, 6, 9]);
  });
  test("MapExtensions.addWith", () {
    final main = {"c": 3, "d": 4};
    final other = {"a": 1, "b": 2};
    main.addWith(other, ["a"]);
    expect(main.addWith(other, ["a"]), {"a": 1, "c": 3, "d": 4});
    expect(main.addWith(other, ["a", "b"]), {"a": 1, "b": 2, "c": 3, "d": 4});
  });
  test("MapExtensions.get", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    expect(map.get("a", ""), "a");
    expect(map.get("b", ""), "");
    expect(map.get("b", 0), 1);
    expect(map.get("c", 1.2), 1.5);
    expect(map.get("d", <int>[]), [1, 2, 3]);
    expect(map.get("d", <double>[]), []);
    expect(map.get("e", <String, dynamic>{}), {"a": 1, "b": 2});
    expect(map.get("e", []), []);
    expect(map.get("f", DateTime(2000, 1, 1)), DateTime(2001, 1, 1));
  });
  test("MapExtensions.getAsInt", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    expect(map.getAsInt("a", 0), 0);
    expect(map.getAsInt("b", 0), 1);
  });
  test("MapExtensions.getAsDouble", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    expect(map.getAsDouble("a", 0), 0);
    expect(map.getAsDouble("b", 0), 1);
    expect(map.getAsDouble("c", 0), 1.5);
  });
  test("MapExtensions.getAsList", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1)
    };
    expect(map.getAsList("a"), []);
    expect(map.getAsList("d"), [1, 2, 3]);
  });
  test("MapExtensions.getAsSet", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1),
      "g": {"a", "b", "c"}
    };
    expect(map.getAsSet("a"), <dynamic>{});
    expect(map.getAsSet("g"), {"a", "b", "c"});
  });
  test("MapExtensions.getAsMap", () {
    final map = {
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
  test("MapExtensions.getAsDateTime", () {
    final map = {
      "a": "a",
      "b": 1,
      "c": 1.5,
      "d": [1, 2, 3],
      "e": {"a": 1, "b": 2},
      "f": DateTime(2001, 1, 1),
      "g": {"a", "b", "c"}
    };
    expect(map.getAsDateTime("f"), DateTime(2001, 1, 1));
    expect(map.getAsDateTime("b"), DateTime.fromMillisecondsSinceEpoch(1));
    expect(map.getAsDateTime("a", DateTime(2000, 1, 1)), DateTime(2000, 1, 1));
  });
  test("MapExtensions.merge", () {
    final map = {"a": 1, "b": 2, "c": 3};
    final others = {"d": 4, "e": 5};
    expect(
      map.merge(
        others,
        convertKeys: (key) => "merged_$key",
        convertValues: (value) => value * 2,
      ),
      {"a": 1, "b": 2, "c": 3, "merged_d": 8, "merged_e": 10},
    );
  });
  test("MapExtensions.addAllIfEmpty", () {
    final map = {"a": 1, "b": 2, "c": 3};
    final others = {"c": 4, "d": 5};
    expect(map..addAllIfEmpty(others), {"a": 1, "b": 2, "c": 3, "d": 5});
  });
  test("MapExtensions.containsKeyAny", () {
    final map = {"a": 1, "b": 2, "c": 3};
    expect(map.containsKeyAny(["a", "e", "f"]), true);
    expect(map.containsKeyAny(["g", "e", "f"]), false);
  });
  test("MapExtensions.containsKeyAll", () {
    final map = {"a": 1, "b": 2, "c": 3};
    expect(map.containsKeyAll(["a", "b", "c"]), true);
    expect(map.containsKeyAll(["g", "e", "c"]), false);
  });
  test("MapExtensions.containsValueAny", () {
    final map = {"a": 1, "b": 2, "c": 3};
    expect(map.containsValueAny([1, 5, 6]), true);
    expect(map.containsValueAny([4, 5, 6]), false);
  });
  test("MapExtensions.containsValueAll", () {
    final map = {"a": 1, "b": 2, "c": 3};
    expect(map.containsValueAll([1, 2, 3]), true);
    expect(map.containsValueAll([3, 5, 6]), false);
  });
  test("MapExtensions.equalsTo", () {
    final array1 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    final array2 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    final array3 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 6],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "h": {"9d8", 192}
    };
    final array4 = {
      "a": "aa",
      "b": 3,
      "c": 5,
      "d": ["cc", 4],
      "e": 9.5,
      "f": {"aa": "dd", "bb": 6},
      "g": 12,
      "i": {"9d8", 192}
    };
    expect(array1.equalsTo(array2), true);
    expect(array1.equalsTo(array3), false);
    expect(array1.equalsTo(array4), false);
  });
}
