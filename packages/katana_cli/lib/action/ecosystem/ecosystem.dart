// Dart imports:

// Package imports:

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use the Ecosystem.
///
/// Ecosystemを利用するためのモジュールを追加します。
class EcosystemCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the Ecosystem.
  ///
  /// Ecosystemを利用するためのモジュールを追加します。
  const EcosystemCliAction();

  @override
  String get description =>
      "Add a module to use the Ecosystem. Ecosystemを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final ecosystem = context.yaml.getAsMap("ecosystem");
    final enable = ecosystem.get("enable", false);
    final type = ecosystem.get("type", "");
    if (!enable) {
      return false;
    }
    switch (type) {
      case "point":
        final purchase = context.yaml.getAsMap("purchase");
        final enablePurchase = purchase.get("enable", false);
        final ads = context.yaml.getAsMap("ads");
        final enableAds = ads.get("enable", false);
        if (!enablePurchase || !enableAds) {
          return false;
        }
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final ecosystem = context.yaml.getAsMap("ecosystem");
    final type = ecosystem.get("type", "");
    switch (type) {
      case "point":
        final purchase = context.yaml.getAsMap("purchase");
        final googlePlay = purchase.getAsMap("google_play");
        final appStore = purchase.getAsMap("app_store");
        final googlePlayClientId = googlePlay.get("oauth_client_id", "");
        final googlePlayClientSecret =
            googlePlay.get("oauth_client_secret", "");
        final googlePlayRefreshToken = googlePlay.get("refresh_token", "");
        final googlePlayPubsubTopic = googlePlay.get("pubsub_topic", "");
        final appStoreSharedSecret = appStore.get("shared_secret", "");
        final firebase = context.yaml.getAsMap("firebase");
        final projectId = firebase.get("project_id", "");
        final function = firebase.getAsMap("functions");
        final enableFunctions = function.get("enable", false);
        final region = function.get("region", "");
        final enableGooglePlay = googlePlay.get("enable", false);
        final enableAppStore = appStore.get("enable", false);
        final ads = context.yaml.getAsMap("ads");
        final androidAppId = ads.get("android_app_id", "");
        final iosAppId = ads.get("ios_app_id", "");
        if (enableGooglePlay) {
          if (googlePlayClientId.isEmpty || googlePlayClientSecret.isEmpty) {
            error(
              "The item [purchase]->[google_play]->[oauth_client_id] or [purchase]->[google_play]->[oauth_client_secret] is empty. Please set it.",
            );
            return;
          }
          if (googlePlayRefreshToken.isEmpty) {
            error(
              "The item [purchase]->[google_play]->[refresh_token] is empty. Please set it."
              "After entering [purchase]->[google_play]->[oauth_client_id] and [purchase]->[google_play]->[oauth_client_secret], run `katana store android_token and run `katana store android_token` to get a refresh token.",
            );
            return;
          }
          if (googlePlayPubsubTopic.isEmpty) {
            error(
              "The item [purchase]->[google_play]->[pubsub_topic] is empty. Please set it."
              "Set the topic ID you set in Pubsub.",
            );
            return;
          }
        }
        if (enableAppStore) {
          if (appStoreSharedSecret.isEmpty) {
            error(
              "The item [purchase]->[app_store]->[shared_secret] is empty. Please set it.",
            );
            return;
          }
        }
        if (enableAppStore || enableGooglePlay) {
          if (!enableFunctions) {
            error(
              "The item [firebase]->[functions]->[enable] is false. Please set it to true.",
            );
            return;
          }
          if (projectId.isEmpty) {
            error(
              "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
            );
            return;
          }
          if (region.isEmpty) {
            error(
              "The item [firebase]->[functions]->[region] is missing. Please provide the region for the configuration.",
            );
            return;
          }
          final firebaseDir = Directory("firebase");
          if (!firebaseDir.existsSync()) {
            error(
              "The directory `firebase` does not exist. Initialize Firebase by executing Firebase init.",
            );
            return;
          }
          final functionsDir = Directory("firebase/functions");
          if (!functionsDir.existsSync()) {
            error(
              "The directory `firebase/functions` does not exist. Initialize Firebase by executing Firebase init.",
            );
            return;
          }
        }
        if (androidAppId.isEmpty && iosAppId.isEmpty) {
          throw Exception(
            "Specify the app ID for Android or iOS in [ads]->[android_app_id] or [ads]->[ios_app_id].",
          );
        }
        await addFlutterImport(
          [
            "masamune_point_ecosystem",
          ],
        );
    }
  }
}
