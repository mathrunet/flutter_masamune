// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("DateTimeIterableExtensions.nearestOrNull", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    final dateTimes =
        List.generate(10, (i) => dateTime.add(Duration(days: i * 10)));
    expect(
      dateTimes.nearestOrNull(DateTime(2021, 12, 25)),
      DateTime(2022, 12, 23, 10, 32, 10),
    );
    expect(
      dateTimes.nearestOrNull(DateTime(2022, 12, 25)),
      DateTime(2022, 12, 23, 10, 32, 10),
    );
    expect(
      dateTimes.nearestOrNull(DateTime(2023, 1, 8)),
      DateTime(2023, 1, 12, 10, 32, 10),
    );
    expect(
      dateTimes.nearestOrNull(DateTime(2024, 1, 1)),
      DateTime(2023, 3, 23, 10, 32, 10),
    );
  });
  test("DateTimeIterableExtensions.min", () {
    final minDateTime = DateTime(2022, 12, 23, 10, 32, 10);
    final maxDateTime = DateTime(2023, 12, 23, 10, 32, 10);
    final dateTimes = [
      ...List.generate(10, (i) => minDateTime.add(Duration(days: i * 10))),
      maxDateTime,
    ];
    expect(dateTimes.min().millisecondsSinceEpoch,
        minDateTime.millisecondsSinceEpoch);
  });
  test("DateTimeIterableExtensions.max", () {
    final minDateTime = DateTime(2022, 12, 23, 10, 32, 10);
    final maxDateTime = DateTime(2023, 12, 23, 10, 32, 10);
    final dateTimes = [
      ...List.generate(10, (i) => minDateTime.add(Duration(days: i * 10))),
      maxDateTime,
    ];
    expect(dateTimes.max().millisecondsSinceEpoch,
        maxDateTime.millisecondsSinceEpoch);
  });
}
