import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("DateTimeExtensions.isToday", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isToday(DateTime(2022, 12, 23)), true);
    expect(dateTime.isToday(DateTime(2023, 12, 23)), false);
    expect(dateTime.isToday(DateTime(2022, 11, 23)), false);
    expect(dateTime.isToday(DateTime(2022, 12, 29)), false);
  });
  test("DateTimeExtensions.isThisMonth", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isThisMonth(DateTime(2022, 12, 23)), true);
    expect(dateTime.isThisMonth(DateTime(2023, 12, 23)), false);
    expect(dateTime.isThisMonth(DateTime(2022, 11, 23)), false);
    expect(dateTime.isThisMonth(DateTime(2022, 12, 29)), true);
  });
  test("DateTimeExtensions.isThisYear", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isThisYear(DateTime(2022, 12, 23)), true);
    expect(dateTime.isThisYear(DateTime(2023, 12, 23)), false);
    expect(dateTime.isThisYear(DateTime(2022, 11, 23)), true);
    expect(dateTime.isThisYear(DateTime(2022, 12, 29)), true);
  });
  test("DateTimeExtensions.isThisHour", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isThisHour(DateTime(2022, 12, 23, 10, 24, 30)), true);
    expect(dateTime.isThisHour(DateTime(2022, 12, 23, 10, 32, 30)), true);
    expect(dateTime.isThisHour(DateTime(2022, 12, 23, 10, 32, 10)), true);
    expect(dateTime.isThisHour(DateTime(2023, 12, 23, 10, 32, 10)), false);
    expect(dateTime.isThisHour(DateTime(2022, 11, 23, 10, 32, 10)), false);
    expect(dateTime.isThisHour(DateTime(2022, 12, 29, 10, 32, 10)), false);
  });
  test("DateTimeExtensions.isThisMinute", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isThisMinute(DateTime(2022, 12, 23, 10, 24, 30)), false);
    expect(dateTime.isThisMinute(DateTime(2022, 12, 23, 10, 32, 30)), true);
    expect(dateTime.isThisMinute(DateTime(2022, 12, 23, 10, 32, 10)), true);
    expect(dateTime.isThisMinute(DateTime(2023, 12, 23, 10, 32, 10)), false);
    expect(dateTime.isThisMinute(DateTime(2022, 11, 23, 10, 32, 10)), false);
    expect(dateTime.isThisMinute(DateTime(2022, 12, 29, 10, 32, 10)), false);
  });
  test("DateTimeExtensions.isThisSecond", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.isThisSecond(DateTime(2022, 12, 23, 10, 24, 30)), false);
    expect(dateTime.isThisSecond(DateTime(2022, 12, 23, 10, 32, 30)), false);
    expect(dateTime.isThisSecond(DateTime(2022, 12, 23, 10, 32, 10)), true);
    expect(dateTime.isThisSecond(DateTime(2023, 12, 23, 10, 32, 10)), false);
    expect(dateTime.isThisSecond(DateTime(2022, 11, 23, 10, 32, 10)), false);
    expect(dateTime.isThisSecond(DateTime(2022, 12, 29, 10, 32, 10)), false);
  });
  test("DateTimeExtensions.format", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.format("yyyy/MM/dd HH:mm:ss ww"), "2022/12/23 10:32:10 51");
  });
  test("DateTimeExtensions.yyyyMMdd", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.yyyyMMdd(), "2022/12/23");
  });
  test("DateTimeExtensions.HHmmss", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.HHmmss(), "10:32:10");
  });
  test("DateTimeExtensions.yyyyMMddHHmmss", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.yyyyMMddHHmmss(), "2022/12/23 10:32:10");
  });
  test("DateTimeExtensions.toDate", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.toDate(), DateTime(2022, 12, 23));
  });
  test("DateTimeExtensions.toDateID", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.toDateID(), "20221223");
  });
  test("DateTimeExtensions.toDateTimeID", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.toDateTimeID(), "20221223103210");
  });
  test("DateTimeExtensions.weekNumber", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.weekNumber, 51);
  });
  test("DateTimeExtensions.toUnUtc", () {
    final dateTime = DateTime(2022, 12, 23, 10, 32, 10);
    expect(dateTime.toUnUtc(), DateTime(2022, 12, 23, 19, 32, 10));
  });
  test("DateTimeExtensions.age", () {
    final dateTime = DateTime(1984, 8, 2);
    expect(dateTime.age(DateTime(2022, 10, 26)), const DateDuration(38, 2, 24));
  });
  test("DateTimeExtensions.dateToNextBirthday", () {
    final dateTime = DateTime(1984, 8, 2);
    expect(
      dateTime.dateToNextBirthday(DateTime(2022, 10, 26)),
      const DateDuration(0, 9, 7),
    );
  });
}
