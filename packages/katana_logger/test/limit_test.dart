// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_logger/katana_logger.dart';

void main() {
  test("LoggerDatabase.limit", () async {
    final database = LoggerDatabase();
    database.setLimit(100);
    for (var i = 0; i < 101; i++) {
      await database.write("item$i", dateTime: DateTime(2000, 1, i + 1));
    }
    final logs = await database.read();
    expect(logs.length, 100);
    expect(logs.entries.first.key, DateTime(2000, 1, 2).toIso8601String());
  });
}
