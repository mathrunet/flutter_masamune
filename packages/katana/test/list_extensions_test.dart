// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("ListExtensions.insertFirst", () {
    final array = [1, 2, 3, 4, 5];
    expect(array.insertFirst(0), [0, 1, 2, 3, 4, 5]);
  });
  test("ListExtensions.insertLast", () {
    final array = [1, 2, 3, 4, 5];
    expect(array.insertLast(6), [1, 2, 3, 4, 5, 6]);
  });
  test("ListExtensions.insertWhere", () {
    final array = [1, 2, 3, 4, 5];
    expect(
      array.insertWhere(10, (prev, current, next) => current == 3),
      [1, 2, 10, 3, 4, 5],
    );
  });
  test("ListExtensions.get", () {
    final array = [1, 2, 3, 4, 5];
    expect(array.get(2, 100), 3);
    expect(array.get(-1, 100), 100);
    expect(array.get(5, 100), 100);
  });
  test("ListExtensions.getRandom", () {
    final array = [1, 2, 3, 4, 5];
    expect(
      array.getRandom(10),
      1,
    );
  });
  test("ListExtensions.sortTo", () {
    final array = [3, 2, 1, 5, 4, 6];
    expect(
      array.sortTo((a, b) => a - b),
      [1, 2, 3, 4, 5, 6],
    );
  });
  test("ListExtensions.containsIndex", () {
    final array = [3, 2, 1, 5, 4, 6];
    expect(array.containsIndex(0), true);
    expect(array.containsIndex(5), true);
    expect(array.containsIndex(6), false);
    expect(array.containsIndex(7), false);
  });
}
