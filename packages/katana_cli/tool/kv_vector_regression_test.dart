import "dart:convert";
import "package:katana_cli/action/cloudflare/kv.dart";

void check(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void main() {
  const initial = '{"vars":{"FLAVOR":"dev"}}';
  final once = updateKvVectorCoordinatorBinding(initial,
      binding: "KV_VECTOR",
      className: "MasamuneKvVectorCoordinator",
      tag: "kv-vector-v1");
  final twice = updateKvVectorCoordinatorBinding(once,
      binding: "KV_VECTOR",
      className: "MasamuneKvVectorCoordinator",
      tag: "kv-vector-v1");
  check(once == twice, "再実行でKV coordinator設定が変わりました。");
  final config = jsonDecode(twice) as Map;
  check((config["durable_objects"]["bindings"] as List).length == 1,
      "KV coordinator bindingが重複しています。");
  check((config["migrations"] as List).length == 1,
      "KV coordinator migrationが重複しています。");
  var rejected = false;
  try {
    updateKvVectorCoordinatorBinding(once,
        binding: "KV_VECTOR", className: "Other", tag: "kv-vector-v1");
  } on StateError {
    rejected = true;
  }
  check(rejected, "異なるKV coordinator classを許可しました。");
  // ignore: avoid_print
  print("KV Vectorize coordinator binding・migration: 成功");
}
