import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("NullableObjectExtensions.def", () {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const num? val = 100;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    const String? text = "100";
    const num? nullVal = null;
    expect(val.def(10), 100);
    expect(nullVal.def(10), 10);
    expect(text.def(10), 10);
  });
}
