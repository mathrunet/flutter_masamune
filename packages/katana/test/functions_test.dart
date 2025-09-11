// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("jsonEncodable", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const num? val = 100;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "100";
    const test = _Test();
    const num? nullVal = null;
    const dynamic dynamicValue = "test";
    final map = <String, dynamic>{
      "aaa": 1,
      "bbb": 2,
      "ccc": 3,
    };
    final testObjInMap = <String, dynamic>{
      "aaa": 1,
      "bbb": 2,
      "ccc": const _Test(),
    };
    final list = <dynamic>[
      "1",
      2,
      0.0,
    ];
    final testObjInList = <dynamic>[
      "3",
      3,
      const _Test(),
    ];
    final set = <dynamic>{};
    final intMap = <int, dynamic>{};
    expect(jsonEncodable(val), true);
    expect(jsonEncodable(nullVal), false);
    expect(jsonEncodable(text), true);
    expect(jsonEncodable(test), false);
    expect(jsonEncodable(map), true);
    expect(jsonEncodable(testObjInMap), false);
    expect(jsonEncodable(list), true);
    expect(jsonEncodable(testObjInList), false);
    expect(jsonEncodable(set), false);
    expect(jsonEncodable(intMap), false);
    expect(jsonEncodable(dynamicValue), true);
  });
  test("uuid", () {
    final uid = uuid();
    expect(uid.length, 32);
    expect(uid.replaceAll("-", ""), isA<String>());
    final uid2 =
        uuid(baseTime: DateTime.now().subtract(const Duration(hours: 1)));
    expect(uid2.length, 32);
    expect(uid2.replaceAll("-", ""), isA<String>());
    final uid3 = uuid(reverse: true);
    expect(uid3.length, 32);
    expect(uid3.replaceAll("-", ""), isA<String>());
    final ids = <String>[];
    for (final i in List.generate(5, (index) => index)) {
      final dateTime = DateTime(2024, 1, 1, 0, 0, i);
      final uid = uuid(baseTime: dateTime);
      // ignore: avoid_print
      print(uid);
      ids.add(uid);
    }
    var sortedIds = ids.sortTo((a, b) => a.compareTo(b));
    expect(sortedIds, ids);
    ids.clear();
    for (final i in List.generate(5, (index) => index)) {
      final dateTime = DateTime(2024, 1, 1, 0, 0, i);
      final uid = uuid(baseTime: dateTime, reverse: true);
      // ignore: avoid_print
      print(uid);
      ids.add(uid);
    }
    sortedIds = ids.sortTo((a, b) => b.compareTo(a));
    expect(sortedIds, ids);
  });
}

class _Test {
  const _Test();
}
