import "dart:io";
import "dart:convert";
import "package:katana_cli/action/firebase/firestore.dart";

void main() {
  const sync = FirebaseFirestoreCliAction.synchronizeFirestoreConfig;
  void check(bool ok, String message) {
    if (!ok) {
      throw StateError(message);
    }
  }

  final map = {
    "database": "(default)",
    "location": "asia-northeast1",
    "custom": {"keep": true},
    "rules": "old"
  };
  final first = sync(map, const []);
  check((first as Map)["location"] == "asia-northeast1",
      "Preserve Tokyo location");
  check(first["custom"] == map["custom"], "Preserve unmanaged metadata");
  check(jsonEncode(sync(first, const [])) == jsonEncode(first),
      "Map idempotence");
  final multi = [
    map,
    {"database": "other", "location": "nam5", "rules": "other.rules"}
  ];
  final updated = sync(multi, const ["(default)", "new"]) as List;
  check(updated.length == 3 && updated[1]["rules"] == "other.rules",
      "Preserve other databases");
  check(
      updated[0]["location"] == "asia-northeast1" &&
          updated[2]["database"] == "new",
      "Merge by database name");
  check(
      jsonEncode(sync(updated, const ["(default)", "new"])) ==
          jsonEncode(updated),
      "List idempotence");
  check((sync(multi, const []) as List)[1]["location"] == "nam5",
      "Preserve list shape and metadata");
  check((sync(null, const []) as Map)["rules"] == "firestore.rules",
      "Empty map initialization");
  check((sync(null, const ["new"]) as List).single["database"] == "new",
      "Empty list initialization");
  stdout.writeln(
      "Firestore preservation: map/list/empty/multiple databases/idempotence PASS");
}
