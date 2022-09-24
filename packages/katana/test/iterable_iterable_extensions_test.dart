import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("IterableIterableExtensions.joinToList", () {
    final arrayOfArray = [
      [1, 2, 3],
      [5, 6],
      [8, 9]
    ];
    expect(arrayOfArray.joinToList(), [1, 2, 3, 5, 6, 8, 9]);
    expect(arrayOfArray.joinToList(4), [1, 2, 3, 4, 5, 6, 4, 8, 9]);
  });
}
