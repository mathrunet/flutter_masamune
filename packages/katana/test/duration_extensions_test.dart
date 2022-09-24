import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("DurationExtensions.format", () {
    const duration = Duration(
      days: 1,
      hours: 2,
      minutes: 12,
      seconds: 56,
      milliseconds: 765,
      microseconds: 354,
    );
    expect(duration.format("d HH:mm:ss.S.M"), "1 02:12:56.765.354");
  });
}
