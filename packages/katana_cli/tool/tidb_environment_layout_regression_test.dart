import "package:katana_cli/action/cloudflare/tidb.dart";

void main() {
  final shared = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "dev_app",
    prodDatabase: "app",
  );
  _expect(shared.warnings.isEmpty && shared.error == null,
      "共有clusterの標準構成で警告またはエラーが出ました。");

  final separated = validateTidbEnvironmentLayout(
    devCluster: "dev-cluster",
    prodCluster: "prod-cluster",
    devDatabase: "app",
    prodDatabase: "app",
  );
  _expect(separated.warnings.length == 1 && separated.error == null,
      "別clusterの既存構成は警告のみで続行する必要があります。");

  final collided = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "app",
    prodDatabase: "app",
  );
  _expect(collided.error != null, "同一cluster・同一databaseを拒否しませんでした。");

  final mismatched = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "app_dev",
    prodDatabase: "app",
  );
  _expect(mismatched.warnings.length == 1 && mismatched.error == null,
      "dev_の付け方が異なる場合は警告する必要があります。");

  final incomplete = validateTidbEnvironmentLayout(
    devCluster: "dev-cluster",
    prodCluster: "",
    devDatabase: "app",
    prodDatabase: "",
  );
  _expect(incomplete.warnings.isEmpty && incomplete.error == null,
      "未設定の環境があるときは検査しない必要があります。");
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
