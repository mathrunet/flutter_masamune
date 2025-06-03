// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("NulableListExtensions.containsIndex", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final List<int>? array = [3, 2, 1, 5, 4, 6];
    const List<int>? nullableArray = null;
    expect(array.containsIndex(0), true);
    expect(array.containsIndex(5), true);
    expect(array.containsIndex(6), false);
    expect(array.containsIndex(7), false);
    expect(nullableArray.containsIndex(7), false);
  });
  test("ListExtensions.get", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final List<int>? array = [1, 2, 3, 4, 5];
    const List<int>? nullableArray = null;
    expect(array.get(2, 100), 3);
    expect(array.get(-1, 100), 100);
    expect(array.get(5, 100), 100);
    expect(nullableArray.get(0, 100), 100);
  });
}
