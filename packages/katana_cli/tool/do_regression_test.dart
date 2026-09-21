import "dart:convert";
import "package:katana_cli/action/cloudflare/durable_object.dart";

void main() {
  const initial = '{"vars":{"FLAVOR":"dev"}}';
  String update(String source) => updateDurableObjectBindings(source,
      binding: "DB",
      className: "Database",
      coordinatorBinding: "QUEUE",
      coordinatorClass: "Queue",
      tag: "v1");
  final once = update(initial);
  final twice = update(once);
  if (once != twice) {
    throw StateError("再実行で設定が変わりました。");
  }
  final config = jsonDecode(twice) as Map;
  if ((config["durable_objects"]["bindings"] as List).length != 2 ||
      (config["migrations"] as List).length != 1) {
    throw StateError("重複しています。");
  }
  var rejected = false;
  try {
    update(twice.replaceAll('"v1"', '"v2"'));
  } on StateError {
    rejected = true;
  }
  if (!rejected) {
    throw StateError("異なるtagが許可されました。");
  }
  // ignore: avoid_print
  print("DO binding・class migrationの冪等性と衝突拒否: 成功");
}
