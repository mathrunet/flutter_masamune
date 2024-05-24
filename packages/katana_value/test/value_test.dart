import 'package:katana_value/katana_value.dart';
import 'package:test/test.dart';

@DataValue()
class Person {
  Person({
    required Map<String, List<Set<int?>>?>? text,
    String? name,
  });
}

class PersonBase {
  const PersonBase({
    required this.name,
  });
  final String? name;
}

void main() {
  test("Value macro json test", () {
    final json = {
      "text": {
        "a": [
          {1, 2},
          {3, 4}
        ]
      },
      "name": "aaa",
    };
    final person = Person(
      text: {
        "a": [
          {1, 2},
          {3, 4}
        ]
      },
      name: "aaa",
    );
    expect(person.text, {
      "a": [
        {1, 2},
        {3, 4}
      ]
    });
    expect(person.name, "aaa");
    final copyed = person.copyWith(text: {"a": []});
    expect(
      copyed.hashCode,
      Person(
        text: {"a": []},
        name: "aaa",
      ).hashCode,
    );
    expect(
      copyed,
      Person(
        text: {"a": []},
        name: "aaa",
      ),
    );
    expect(copyed.text, {"a": []});
    expect(person.name, "aaa");
    expect(copyed.toString(), "Person(text: {a: []}, name: aaa)");
    final fromJson = Person.fromJson(json);
    expect(fromJson.text, person.text);
    expect(person.toJson(), json);
  });
}
