import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("NumExtensions.duration", () {
    expect(100.microseconds, const Duration(microseconds: 100));
    expect(100.milliseconds, const Duration(milliseconds: 100));
    expect(100.seconds, const Duration(seconds: 100));
    expect(100.minutes, const Duration(minutes: 100));
    expect(100.hours, const Duration(hours: 100));
    expect(100.days, const Duration(days: 100));
    expect(100.ms, const Duration(milliseconds: 100));
  });
}
