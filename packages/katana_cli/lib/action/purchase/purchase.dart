// Dart imports:

// Package imports:

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use InAppPurchase.
///
/// InAppPurchaseを利用するためのモジュールを追加します。
class PurchaseCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use InAppPurchase.
  ///
  /// InAppPurchaseを利用するためのモジュールを追加します。
  const PurchaseCliAction();

  @override
  String get description =>
      "Add a module to use InAppPurchase. InAppPurchaseを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final purchase = context.yaml.getAsMap("purchase");
    final googlePlay = purchase.getAsMap("google_play");
    final appStore = purchase.getAsMap("app_store");
    final enableGooglePlay = googlePlay.get("enable", false);
    final enableAppStore = appStore.get("enable", false);
    if (!enableAppStore && !enableGooglePlay) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebaseCommand = bin.get("firebase", "firebase");
    final purchase = context.yaml.getAsMap("purchase");
    final googlePlay = purchase.getAsMap("google_play");
    final appStore = purchase.getAsMap("app_store");
    final googlePlayClientId = googlePlay.get("oauth_client_id", "");
    final googlePlayClientSecret = googlePlay.get("oauth_client_secret", "");
    final googlePlayRefreshToken = googlePlay.get("refresh_token", "");
    final appStoreSharedSecret = appStore.get("shared_secret", "");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final function = firebase.getAsMap("functions");
    final enableFunctions = function.get("enable", false);
    final region = function.get("region", "");
    final enableGooglePlay = googlePlay.get("enable", false);
    final enableAppStore = appStore.get("enable", false);
    if (!enableFunctions) {
      error(
        "The item [firebase]->[functions]->[enable] is false. Please set it to true.",
      );
      return;
    }
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
    }
    if (enableAppStore) {
      if (appStoreSharedSecret.isEmpty) {
        error(
          "The item [purchase]->[app_store]->[shared_secret] is empty. Please set it.",
        );
        return;
      }
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
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_purchase_mobile",
        "katana_functions_firebase",
      ],
    );
    if (enableAppStore) {
      label("Edit XCode.");
      final xcode = XCode();
      await xcode.load();
      xcode.addFramework(frameworkName: "StoreKit");
      await xcode.save();
    }
    if (enableGooglePlay) {
      label("Edit build.gradle.");
      final gradle = AppGradle();
      await gradle.load();
      if (!gradle.dependencies.any((element) => element.packageName
          .startsWith("com.android.billingclient:billing"))) {
        gradle.dependencies.add(
          GradleDependencies(
            group: "implementation",
            packageName: "com.android.billingclient:billing:5.2.0",
          ),
        );
      }
      await gradle.save();
      label("Edit AndroidManifest.xml.");
      final file = File("android/app/src/main/AndroidManifest.xml");
      if (!file.existsSync()) {
        throw Exception(
          "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final document = XmlDocument.parse(await file.readAsString());
      final manifest = document.findAllElements("manifest");
      if (manifest.isEmpty) {
        throw Exception(
          "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
        );
      }
      if (!manifest.first.children.any((p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "uses-permission" &&
          p0.attributes.any((p1) =>
              p1.name.toString() == "android:name" &&
              p1.value == "com.android.vending.BILLING"))) {
        manifest.first.children.add(
          XmlElement(
            XmlName("uses-permission"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.android.vending.BILLING",
              ),
            ],
            [],
          ),
        );
      }
      final application = document.findAllElements("application");
      if (!application.first.children.any(
        (p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            p0.attributes.any(
              (p1) =>
                  p1.name.toString() == "android:name" &&
                  p1.value == "com.google.android.play.billingclient.version",
            ),
      )) {
        application.first.children.add(
          XmlElement(
            XmlName("meta-data"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.google.android.play.billingclient.version",
              ),
              XmlAttribute(
                XmlName("android:value"),
                "5.2.0",
              ),
            ],
            [],
          ),
        );
      }
      await file.writeAsString(
        document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
      );
    }
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e == "androidAuthCode")) {
      functions.functions.add("androidAuthCode");
    }
    if (!functions.functions.any((e) => e == "androidToken")) {
      functions.functions.add("androidToken");
    }
    if (enableAppStore) {
      if (!functions.functions.any((e) => e == "consumableVerifyIOS")) {
        functions.functions.add("consumableVerifyIOS");
      }
      if (!functions.functions.any((e) => e == "nonconsumableVerifyIOS")) {
        functions.functions.add("nonconsumableVerifyIOS");
      }
      if (!functions.functions.any((e) => e == "subscriptionVerifyIOS")) {
        functions.functions.add("subscriptionVerifyIOS");
      }
      if (!functions.functions.any((e) => e == "purchaseWebhookIOS")) {
        functions.functions.add("purchaseWebhookIOS");
      }
    }
    if (enableGooglePlay) {
      if (!functions.functions.any((e) => e == "consumableVerifyAndroid")) {
        functions.functions.add("consumableVerifyAndroid");
      }
      if (!functions.functions.any((e) => e == "nonconsumableVerifyAndroid")) {
        functions.functions.add("nonconsumableVerifyAndroid");
      }
      if (!functions.functions.any((e) => e == "subscriptionVerifyAndroid")) {
        functions.functions.add("subscriptionVerifyAndroid");
      }
      if (!functions.functions.any((e) => e == "purchaseWebhookAndroid")) {
        functions.functions.add("purchaseWebhookAndroid");
      }
      if (!functions.topics.keys.any((e) => e == "purchaseWebhookAndroid")) {
        functions.topics["purchaseWebhookAndroid"] = "\"purchasing\"";
      }
    }
    await functions.save();
    await command(
      "Set firebase functions config.",
      [
        firebaseCommand,
        "functions:config:set",
        "purchase.subscription_path=plugins/iap/subscription",
        if (enableGooglePlay) ...[
          "purchase.android.refresh_token=$googlePlayRefreshToken",
          "purchase.android.client_id=$googlePlayClientId",
          "purchase.android.client_secret=$googlePlayClientSecret",
        ],
        if (enableAppStore) ...[
          "purchase.ios.shared_secret=$appStoreSharedSecret",
        ],
      ],
      workingDirectory: "firebase",
    );
    await command(
      "Deploy firebase functions.",
      [
        firebaseCommand,
        "deploy",
        "--only",
        "functions",
      ],
      workingDirectory: "firebase",
    );
  }
}
