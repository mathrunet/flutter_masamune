// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("NullableObjectExtensions.def", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const num? val = 100;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "100";
    const num? nullVal = null;
    expect(val.def(10), 100);
    expect(nullVal.def(10), 10);
    expect(text.def(10), 10);
  });
  test("NullableObjectExtensions.jsonEncodable", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const num? val = 100;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "100";
    const test = _Test();
    const num? nullVal = null;
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
    expect(val.isJsonEncodable, true);
    expect(nullVal.isJsonEncodable, false);
    expect(text.isJsonEncodable, true);
    expect(test.isJsonEncodable, false);
    expect(map.isJsonEncodable, true);
    expect(testObjInMap.isJsonEncodable, false);
    expect(list.isJsonEncodable, true);
    expect(testObjInList.isJsonEncodable, false);
    expect(set.isJsonEncodable, false);
    expect(intMap.isJsonEncodable, false);
  });
}

class _Test {
  const _Test();
}
