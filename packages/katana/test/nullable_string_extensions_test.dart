// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana/katana.dart';

void main() {
  test("NullableStringExtensions.isEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "abcde";
    const String? nullText = null;
    expect(text.isEmpty, false);
    expect("".isEmpty, true);
    expect(nullText.isEmpty, true);
  });
  test("NullableStringExtensions.isNotEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "abcde";
    const String? nullText = null;
    expect(text.isNotEmpty, true);
    expect("".isNotEmpty, false);
    expect(nullText.isNotEmpty, false);
  });
  test("NullableStringExtensions.length", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "abcde";
    const String? nullText = null;
    expect(text.length, 5);
    expect("".length, 0);
    expect(nullText.length, 0);
  });
  test("NullableStringExtensions.toAny", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? i = "100";
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? d = "10.5";
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? b = "true";
    const String? n = null;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? s = "abc";
    expect(i.toAny(), 100);
    expect(d.toAny(), 10.5);
    expect(b.toAny(), true);
    expect(n.toAny(), null);
    expect(s.toAny(), "abc");
  });
}
