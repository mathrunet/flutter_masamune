import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";
import "package:yaml/yaml.dart";

void main() {
  final template = katanaYamlCode(true);
  final yaml = loadYaml(template) as Map;

  _expectEnvironmentMap(yaml, ["firebase", "project_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "project_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "turso", "organization"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "turso", "group"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "tidb", "project_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "tidb", "cluster_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "kv", "binding"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "kv", "namespace_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "storage", "bucket_name"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "storage", "public_base_url"]);

  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: const {},
    arguments: const ["apply"],
  );
  _expect(
    resolved.flavor == KatanaFlavor.dev,
    "A generated environment-aware template must default to dev.",
  );
}

void _expectEnvironmentMap(Map root, List<String> path) {
  Object? current = root;
  for (final key in path) {
    if (current is! Map || !current.containsKey(key)) {
      throw StateError("Template field was not found: ${path.join(".")}");
    }
    current = current[key];
  }
  _expect(
    current is Map &&
        current.length == 2 &&
        current.containsKey("dev") &&
        current.containsKey("prod"),
    "Template field must contain only dev/prod: ${path.join(".")}",
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
