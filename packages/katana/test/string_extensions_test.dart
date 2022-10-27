import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("StringExtensions.splitLength", () {
    const path = "aaaa/bbbb/cccc/dddd";
    expect(path.splitLength(), 4);
  });
  test("StringExtensions.parentPath", () {
    const path = "aaaa/bbbb/cccc/dddd";
    expect(path.parentPath(), "aaaa/bbbb/cccc");
  });
  test("StringExtensions.splitByCharacter", () {
    const text = "abcde";
    expect(text.splitByCharacter(), ["a", "b", "c", "d", "e"]);
  });
  test("StringExtensions.splitByBigram", () {
    const text = "abcde";
    expect(text.splitByBigram(), ["ab", "bc", "cd", "de"]);
  });
  test("StringExtensions.splitByTrigram", () {
    const text = "abcde";
    expect(text.splitByTrigram(), ["abc", "bcd", "cde"]);
  });
  test("StringExtensions.splitByTrigram", () {
    const url = "https://google.com?q=searchtext";
    expect(url.trimQuery(), "https://google.com");
  });
  test("StringExtensions.trimString", () {
    const text = "__text___";
    expect(text.trimString("_"), "text");
  });
  test("StringExtensions.trimStringLeft", () {
    const text = "__text___";
    expect(text.trimStringLeft("_"), "text___");
  });
  test("StringExtensions.trimStringRight", () {
    const text = "__text___";
    expect(text.trimStringRight("_"), "__text");
  });
  test("StringExtensions.toSnakeCase", () {
    const text1 = "SnakeCaseText";
    const text2 = "Snake_Case_Text";
    expect(text1.toSnakeCase(), "snake_case_text");
    expect(text2.toSnakeCase(), "snake_case_text");
  });
  test("StringExtensions.toCamelCase", () {
    const text1 = "CAMEL_CASE_TEXT";
    const text2 = "camel_case_text";
    expect(text1.toCamelCase(), "camelCaseText");
    expect(text2.toCamelCase(), "camelCaseText");
  });
  test("StringExtensions.toPascalCase", () {
    const text1 = "PASCAL_CASE_TEXT";
    const text2 = "pascal_case_text";
    expect(text1.toPascalCase(), "PascalCaseText");
    expect(text2.toPascalCase(), "PascalCaseText");
  });
  test("StringExtensions.toInt", () {
    const text1 = "100";
    const text2 = "abc";
    expect(text1.toInt(10), 100);
    expect(text2.toInt(10), 10);
  });
  test("StringExtensions.toDouble", () {
    const text1 = "100.5";
    const text2 = "abc";
    expect(text1.toDouble(10.0), 100.5);
    expect(text2.toDouble(10.0), 10);
  });
  test("StringExtensions.toBool", () {
    const text1 = "true";
    const text2 = "abc";
    expect(text1.toBool(false), true);
    expect(text2.toBool(false), false);
  });
  test("StringExtensions.toAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const i = "100";
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const d = "10.5";
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const b = "true";
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const s = "abc";
    expect(i.toAny(), 100);
    expect(d.toAny(), 10.5);
    expect(b.toAny(), true);
    expect(s.toAny(), "abc");
  });
  test("StringExtensions.toDateTime", () {
    const text1 = "2022-12-18 12:18:30";
    const text2 = "20230814214539";
    expect(text1.toDateTime(), DateTime(2022, 12, 18, 12, 18, 30));
    expect(text2.toDateTime(), DateTime(2023, 8, 14, 21, 45, 39));
  });
  test("StringExtensions.toBase64", () {
    const text = "abcdefg";
    const base64 = "YWJjZGVmZw==";
    expect(text.toBase64(), base64);
  });
  test("StringExtensions.fromBase64", () {
    const text = "abcdefg";
    const base64 = "YWJjZGVmZw==";
    expect(base64.fromBase64(), text);
  });
  test("StringExtensions.toBase64Url", () {
    const text = "abcdefg";
    const base64 = "YWJjZGVmZw==";
    expect(text.toBase64Url(), base64);
  });
  test("StringExtensions.fromBase64Url", () {
    const text = "abcdefg";
    const base64 = "YWJjZGVmZw==";
    expect(base64.fromBase64Url(), text);
  });
  test("StringExtensions.toSHA1", () {
    const text = "abcdefg";
    const sha1 = "2fb5e13419fc89246865e7a324f476ec624e8740";
    expect(text.toSHA1(), sha1);
  });
  test("StringExtensions.toSHA256", () {
    const text = "abcdefg";
    const sha256 =
        "d9336b64efb7f37c90dda486f5fea21c1d74fa40a4d7b633d362b9e60afd57f7";
    expect(text.toSHA256("password"), sha256);
  });
  test("StringExtensions.toAES", () {
    const text = "abcdefg";
    const aes = "APiehLA37rFz2cgp1LikjA==";
    expect(text.toAES("abcdefghijklmnopqlstuvwxyz1234567890"), aes);
  });
  test("StringExtensions.fromAES", () {
    const text = "abcdefg";
    const aes = "APiehLA37rFz2cgp1LikjA==";
    expect(aes.fromAES("abcdefghijklmnopqlstuvwxyz1234567890"), text);
  });
  test("StringExtensions.format", () {
    const text = "%s %d %o %x %.1f";
    expect(text.format(["abc", 100, 64, 255, 10.5]), "abc 100 100 ff 10.5");
  });
  test("StringExtensions.format", () {
    const text = "%s %d %o %x %.1f";
    expect(text.format(["abc", 100, 64, 255, 10.5]), "abc 100 100 ff 10.5");
  });
  test("StringExtensions.first", () {
    const path = "aaaa/bbbb/cccc/dddd";
    expect(path.first(), "aaaa");
  });
  test("StringExtensions.last", () {
    const path = "aaaa/bbbb/cccc/dddd";
    expect(path.last(), "dddd");
  });
  test("StringExtensions.limit", () {
    const text = "abcdefghijklmn";
    expect(text.limit(5), "abcde...");
  });
  test("StringExtensions.capitalize", () {
    const text = "capitalize";
    expect(text.capitalize(), "Capitalize");
  });
  test("StringExtensions.toJsonObject", () {
    const text = "[\"aaa\",\"bbb\",\"ccc\"]";
    expect(text.toJsonObject(), ['aaa', 'bbb', 'ccc']);
  });
  test("StringExtensions.toJsonMap", () {
    const text = "{\"aaa\":1,\"bbb\":2,\"ccc\":3}";
    expect(text.toJsonMap(), {"aaa": 1, "bbb": 2, "ccc": 3});
  });
  test("StringExtensions.toJsonList", () {
    const text = "[\"aaa\",\"bbb\",\"ccc\"]";
    expect(text.toJsonList(), ['aaa', 'bbb', 'ccc']);
  });
}
