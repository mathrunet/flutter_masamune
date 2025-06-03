// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("UriExtensions.splitLength", () {
    final path = Uri.parse("aaaa/bbbb/cccc/dddd");
    expect(path.splitLength(), 4);
  });
  test("UriExtensions.parentPath", () {
    final path = Uri.parse("aaaa/bbbb/cccc/dddd");
    expect(path.parentPath(), Uri.parse("aaaa/bbbb/cccc"));
  });
  test("UriExtensions.first", () {
    final path = Uri.parse("aaaa/bbbb/cccc/dddd");
    expect(path.first(), "aaaa");
  });
  test("UriExtensions.last", () {
    final path = Uri.parse("aaaa/bbbb/cccc/dddd");
    expect(path.last(), "dddd");
  });
}
