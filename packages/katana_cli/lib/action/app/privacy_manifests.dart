// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Create and set `PrivacyInfo.xcprivacy`.
///
/// `PrivacyInfo.xcprivacy`を作成し設定します。
class AppPrivacyManifestsCliAction extends CliCommand with CliActionMixin {
  /// Create and set `PrivacyInfo.xcprivacy`.
  ///
  /// `PrivacyInfo.xcprivacy`を作成し設定します。
  const AppPrivacyManifestsCliAction();

  @override
  String get description =>
      "Create and set `PrivacyInfo.xcprivacy`. `PrivacyInfo.xcprivacy`を作成し設定します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("privacy_manifests");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final privacyManifest = app.getAsMap("privacy_manifests");
    if (privacyManifest.isEmpty) {
      error(
          "The item [app]->[privacy_manifests] is missing. Please add an item.");
      return;
    }
    final manifests = privacyManifest.getAsList<Map>("manifests").map((item) {
      return item.map((key, value) => MapEntry(key.toString(), value));
    });
    if (manifests.isEmpty) {
      error(
          "The item [app]->[privacy_manifests]->[manifests] is missing. Please add an item.");
      return;
    }
    label("Edit PrivacyInfo.xcprivacy.");
    for (final manifest in manifests) {
      final value = XCodePrivacyManifests.values.firstWhereOrNull(
        (item) => item.id == manifest.get("type", ""),
      );
      if (value == null) {
        continue;
      }
      await value.setPrivacyManifestToXCode(manifest.get("reason", ""));
    }
  }
}
