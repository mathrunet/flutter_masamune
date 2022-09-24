import 'package:katana/katana.dart';
import 'package:test/test.dart';

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
}
