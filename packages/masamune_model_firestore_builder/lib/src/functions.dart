part of "/masamune_model_firestore_builder.dart";

/// Create a function.
///
/// 関数を生成する。
StringBuffer createFunction(
  StringBuffer buffer, {
  required String functionName,
  required String parameters,
  required String body,
  String indent = "    ",
}) {
  if (!buffer.toString().contains(functionName)) {
    return buffer;
  }
  buffer.writeln("${indent}function $functionName($parameters) {");
  buffer.writeln(
    "$indent  $body",
  );
  buffer.writeln("$indent}");
  return buffer;
}
