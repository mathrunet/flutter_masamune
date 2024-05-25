// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_value/katana_value.dart';

@DataValue()
class Person {
  Person({
    required Map<String, List<Set<int?>>?>? text,
    String? name,
    PersonBase? person,
  });
}

class PersonBaseConverter extends DataValueJsonConverter {
  const PersonBaseConverter();

  @override
  Map<String, dynamic>? toJson(dynamic value) {
    if (value is PersonBase) {
      return value.toJson();
    }
    return null;
  }

  @override
  dynamic fromJson(String key, Map<String, dynamic> json) {
    return PersonBase.fromJson(json[key] as Map<String, Object?>? ?? {});
  }
}

class PersonBase {
  const PersonBase({
    required this.name,
  });
  final String? name;

  factory PersonBase.fromJson(Map<String, Object?> json) {
    return PersonBase(
      name: json["name"] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "name": name,
    };
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}

void main() {
  test("Value macro json test", () {
    DataValueJsonConverter.register(const PersonBaseConverter());
    const personBase = PersonBase(name: "aaa");
    final json = {
      "text": {
        "a": [
          {1, 2},
          {3, 4}
        ]
      },
      "name": "aaa",
      "person": {"name": "aaa"}
    };
    final person = Person(
      text: {
        "a": [
          {1, 2},
          {3, 4}
        ]
      },
      name: "aaa",
      person: const PersonBase(name: "aaa"),
    );
    expect(person.text, {
      "a": [
        {1, 2},
        {3, 4}
      ]
    });
    expect(person.person?.name, personBase.name);
    expect(person.name, "aaa");
    final copyed = person.copyWith(text: {"a": []});
    expect(
      copyed.hashCode,
      Person(
        text: {"a": []},
        name: "aaa",
        person: personBase,
      ).hashCode,
    );
    expect(
      copyed,
      Person(
        text: {"a": []},
        name: "aaa",
        person: personBase,
      ),
    );
    expect(copyed.text, {"a": []});
    expect(person.name, "aaa");
    expect(copyed.toString(),
        "Person(text: {a: []}, name: aaa, person: Instance of 'PersonBase')");
    final fromJson = Person.fromJson(json);
    expect(fromJson.text, person.text);
    expect(fromJson.person, personBase);
    expect(person.toJson(), json);
  });
}
