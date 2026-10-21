import "package:katana_cli/katana_cli.dart";

const _environment = {
  "TOKEN": "secret-token",
  "HOST": "api.example.com",
  "EMPTY": "",
};

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void main() {
  final yaml = loadKatanaYaml(
    r"""
whole: ${TOKEN}
partial: https://${HOST}/v1
fallback: ${UNDEFINED:-default}
empty_fallback: ${EMPTY:-default}
defined_fallback: ${TOKEN:-default}
escaped: $${TOKEN}
plain: $TOKEN
number: 10
flag: true
nested:
  list:
    - ${TOKEN}
    - value: ${HOST}
${TOKEN}: key
""",
    environment: _environment,
  ) as Map;
  _check(yaml["whole"] == "secret-token", "whole value");
  _check(yaml["partial"] == "https://api.example.com/v1", "partial value");
  _check(yaml["fallback"] == "default", "default for undefined");
  _check(yaml["empty_fallback"] == "default", "default for empty");
  _check(yaml["defined_fallback"] == "secret-token", "defined over default");
  _check(yaml["escaped"] == r"${TOKEN}", "escape");
  _check(yaml["plain"] == r"$TOKEN", "braces required");
  _check(yaml["number"] == 10, "number kept");
  _check(yaml["flag"] == true, "bool kept");
  final list = (yaml["nested"] as Map)["list"] as List;
  _check(list[0] == "secret-token", "list value");
  _check((list[1] as Map)["value"] == "api.example.com", "nested map value");
  _check(yaml[r"${TOKEN}"] == "key", "keys are not expanded");
  yaml["added"] = "modifiable";

  final raw = {"value": r"${TOKEN}"};
  expandEnvironmentVariables(raw, environment: _environment);
  _check(raw["value"] == r"${TOKEN}", "input is not mutated");

  try {
    expandEnvironmentVariables(
      {"a": r"${MISSING_A}", "b": r"${MISSING_B}", "c": r"${TOKEN}"},
      environment: _environment,
      source: "katana_secrets.yaml",
    );
    throw StateError("undefined variables must throw");
  } on KatanaEnvironmentVariableException catch (e) {
    final message = e.toString();
    _check(
      e.names.length == 2 &&
          e.names.contains("MISSING_A") &&
          e.names.contains("MISSING_B"),
      "all undefined names are reported",
    );
    _check(message.contains("katana_secrets.yaml"), "source is reported");
    _check(!message.contains("secret-token"), "values are not reported");
  }

  // ignore: avoid_print
  print("environment_test: OK");
}
