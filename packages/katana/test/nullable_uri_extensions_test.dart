// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana/katana.dart";

void main() {
  test("NullableUriExtensions.isEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Uri? text = Uri.tryParse("https://mathru.net");
    const Uri? nullText = null;
    expect(text.isEmpty, false);
    expect("".isEmpty, true);
    expect(nullText.isEmpty, true);
  });
  test("NullableUriExtensions.isNotEmpty", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final Uri? text = Uri.tryParse("https://mathru.net");
    const Uri? nullText = null;
    expect(text.isNotEmpty, true);
    expect("".isNotEmpty, false);
    expect(nullText.isNotEmpty, false);
  });
}
