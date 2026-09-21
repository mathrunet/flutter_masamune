part of "/masamune_model_d1.dart";

String? _normalizeD1DatabasePrefix(String? value) {
  var normalized = value?.trim() ?? "";
  normalized = normalized.replaceFirst(RegExp(r"_+$"), "");
  if (normalized.isEmpty) {
    return null;
  }
  if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(normalized)) {
    throw ArgumentError.value(value, "prefix", "Invalid database prefix.");
  }
  return "${normalized}_";
}
