import 'package:katana/katana.dart';
import 'package:katana_value/katana_value.dart';
import 'package:test/test.dart';

@DataValue()
class Person {
  Person({
    required Map<String, List<Set<int>>> text,
  });

  factory Person.fromJson(Map<String, Object?> json) {
    return Person(
      text: (json["text"] as Map?)?.map(
            (k, v) => MapEntry(
              k as String,
              (v as List?)
                      ?.map(
                        (e) =>
                            (e as Set?)
                                ?.map((e) => _$FromJsonParam<int>(e))
                                .toSet() ??
                            const {},
                      )
                      .toList() ??
                  [],
            ),
          ) ??
          {},
    );
  }

  Map<String, Object?> toJson() {
    return {
      "text": text.map(
        (k, v) => MapEntry(
          k,
          v.map(
            (e) => e.map((e) => _$ToJsonParam(e)).toList(),
          ),
        ),
      ),
    }..removeWhere((k, v) => v == null);
  }

  // factory Person.fromJson(Map<String, Object?> json) {
  //   return Person(
  //     text: _$FromJsonParam(json["text"]) as String,
  //     age: _$FromJsonParam<int?>(json["age"]),
  //     height: _$FromJsonParam<double>(json["height"]),
  //     weight: _$FromJsonParam<double?>(json["weight"]),
  //     success: _$FromJsonParam<bool>(json["success"]),
  //     lists: (json["lists"] as List?)?.map((e) => e as String).toList(),
  //     sets: (json["sets"] as List?)?.map((e) => e as int).toSet(),
  //     map: (json["map"] as Map?)?.map((k, v) => MapEntry(k as String, v)),
  //   );
  // }

  static TValue _$FromJsonParam<TValue>(dynamic o) {
    return o as TValue;
  }

  // Map<String, Object?> toJson() {
  //   return {
  //     "text": _$ToJsonParam(text),
  //     "age": _$ToJsonParam(age),
  //     "height": _$ToJsonParam(height),
  //     "weight": _$ToJsonParam(weight),
  //     "success": _$ToJsonParam(success),
  //     "lists":
  //         lists?.map((e) => _$ToJsonParam(e)).where((e) => e != null).toList(),
  //     "sets":
  //         sets?.map((e) => _$ToJsonParam(e)).where((e) => e != null).toSet(),
  //     "map": map?.map((k, v) => MapEntry(k, _$ToJsonParam(v)))
  //       ?..removeWhere((k, v) => v == null),
  //   }..removeWhere((k, v) => v == null);
  // }

  static Object? _$ToJsonParam(dynamic o) {
    return o;
  }
}

class PersonBase {
  const PersonBase({
    required this.name,
  });
  final String? name;
}

void main() {
  test("Value macro test", () {
    final person = Person(
      text: {
        "a": [
          {1, 2},
          {3, 4}
        ]
      },
    );
    // final person = Person(
    //   text: "aaa",
    //   age: 10,
    //   height: 1.0,
    //   success: true,
    //   lists: ["a", "b"],
    //   sets: {1, 2},
    //   map: {"a": 1, "b": "2"},
    // );
    // expect(person.text, "aaa");
    // final personCopied = person.copyWith(text: "bbb");
    // expect(personCopied.text, "bbb");
    // expect(personCopied.toString(),
    //     "Person(text: bbb, age: 10, height: 1.0, success: true)");
    // expect(personCopied.toJson(),
    //     {"text": "bbb", "age": 10, "height": 1.0, "success": true});
    // final personGenerated =
    //     Person.fromJson({"text": "ccc", "height": 1.0, "success": false});
    // expect(personGenerated,
    //     Person(text: "ccc", height: 1.0, success: false));
    // expect(personGenerated.toString(),
    //     "Person(text: ccc, height: 1.0, success: false, )");
  });
}
