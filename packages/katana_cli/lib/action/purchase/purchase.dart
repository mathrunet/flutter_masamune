// Dart imports:

// Package imports:

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/action/post/firebase_deploy_post_action.dart';
import 'package:katana_cli/config.dart';
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/android_manifest.dart';

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
    final enable = purchase.get("enable", false);
    if (!enable) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final purchase = context.yaml.getAsMap("purchase");
    final googlePlay = purchase.getAsMap("google_play");
    final appStore = purchase.getAsMap("app_store");
    final googlePlayPubsubTopic = googlePlay.get("pubsub_topic", "");
    final appStoreSharedSecret = appStore.get("shared_secret", "");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final function = firebase.getAsMap("functions");
    final enableFunctions = function.get("enable", false);
    final region = function.get("region", "");
    final enableGooglePlay = googlePlay.get("enable", false);
    final enableAppStore = appStore.get("enable", false);
    late final String androidServiceAccountEmail;
    late final String androidServiceAccountPrivateKey;
    if (enableGooglePlay) {
      final serviceAccountFile = await find(
        Directory("android"),
        RegExp("([a-z0-9_-]+).json"),
        recursive: false,
      );
      if (serviceAccountFile == null) {
        error(
          "Json for service account not found, please refer to https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b to set it up. サービスアカウント用のJsonが見つかりません。https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b を参考に設定してください。",
        );
        return;
      }
      final serviceAccountMap =
          (await serviceAccountFile.readAsString()).toJsonMap();
      androidServiceAccountEmail = serviceAccountMap.get("client_email", "");
      androidServiceAccountPrivateKey =
          serviceAccountMap.get("private_key", "");
      if (androidServiceAccountPrivateKey.isEmpty ||
          androidServiceAccountEmail.isEmpty) {
        error(
          "Json for service account is broken, please refer to https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b to set it up. サービスアカウント用のJsonが壊れています。https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b を参考に設定してください。",
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
    await addFlutterImport(
      [
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
      label("Edit app/build.gradle.");
      final appGradle = AppGradle();
      await appGradle.load();
      if (!appGradle.dependencies.any((element) => element.packageName
          .startsWith("com.android.billingclient:billing"))) {
        appGradle.dependencies.add(
          GradleDependencies(
            group: "implementation",
            packageName:
                "com.android.billingclient:billing:${Config.androidBillingVersion}",
          ),
        );
      }
      appGradle.android?.compileSdkVersion =
          "configProperties[\"flutter.compileSdkVersion\"].toInteger()";
      await appGradle.save();
      label("Edit build.gradle.");
      final gradle = BuildGradle();
      await gradle.load();
      gradle.buildScript.kotlinVersion = Config.androidKotlinVersion;
      await gradle.save();
      label("Edit settings.gradle.");
      final settingsGradle = SettingsGradle();
      await settingsGradle.load();
      if (!settingsGradle.plugins.any((element) =>
          element.package.startsWith("com.google.gms.google-services"))) {
        settingsGradle.plugins.add(
          SettingsGradlePlugins(
            package: "com.google.gms.google-services",
            version: Config.googleServicesVersion,
            apply: false,
          ),
        );
      }
      await settingsGradle.save();
      label("Edit config.properties");
      final configPropertiesFile = File("android/config.properties");
      if (!configPropertiesFile.existsSync()) {
        await configPropertiesFile.writeAsString("");
      }
      final configProperties = await configPropertiesFile.readAsLines();
      if (!configProperties
          .any((element) => element.startsWith("flutter.compileSdkVersion"))) {
        await configPropertiesFile.writeAsString([
          ...configProperties,
          "flutter.compileSdkVersion=${Config.billingCompileSdkVersion}",
        ].join("\n"));
      }
      label("Edit AndroidManifest.xml.");
      await AndroidManifestPermissionType.billing.enablePermission();
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
      if (!manifest.first.attributes
          .any((p0) => p0.name.toString() == "xmlns:tools")) {
        manifest.first.attributes.add(
          XmlAttribute(
            XmlName("xmlns:tools"),
            "http://schemas.android.com/tools",
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
                Config.androidBillingVersion,
              ),
              XmlAttribute(
                XmlName("tools:replace"),
                "android:value",
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
    if (enableAppStore || enableGooglePlay) {
      label("Add firebase functions");
      final functions = Fuctions();
      await functions.load();
      if (enableAppStore) {
        if (!functions.functions
            .any((e) => e.startsWith("consumableVerifyIOS"))) {
          functions.functions.add("consumableVerifyIOS()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("nonconsumableVerifyIOS"))) {
          functions.functions.add("nonconsumableVerifyIOS()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("subscriptionVerifyIOS"))) {
          functions.functions.add("subscriptionVerifyIOS()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("purchaseWebhookIOS"))) {
          functions.functions.add("purchaseWebhookIOS()");
        }
      }
      if (enableGooglePlay) {
        if (!functions.functions
            .any((e) => e.startsWith("consumableVerifyAndroid"))) {
          functions.functions.add("consumableVerifyAndroid()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("nonconsumableVerifyAndroid"))) {
          functions.functions.add("nonconsumableVerifyAndroid()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("subscriptionVerifyAndroid"))) {
          functions.functions.add("subscriptionVerifyAndroid()");
        }
        if (!functions.functions
            .any((e) => e.startsWith("purchaseWebhookAndroid"))) {
          functions.functions.add(
              "purchaseWebhookAndroid({topic: \"$googlePlayPubsubTopic\"})");
        }
      }
      await functions.save();
      label("Set firebase functions config.");
      final env = FunctionsEnv();
      await env.load();
      env["PURCHASE_SUBSCRIPTIONPATH"] = "plugins/iap/subscription";
      if (enableGooglePlay) {
        env["PURCHASE_ANDROID_SERVICEACCOUNT_EMAIL"] =
            androidServiceAccountEmail;
        env["PURCHASE_ANDROID_SERVICEACCOUNT_PRIVATE_KEY"] =
            androidServiceAccountPrivateKey.replaceAll("\n", "\\n");
      }
      if (enableAppStore) {
        env["PURCHASE_IOS_SHAREDSECRET"] = appStoreSharedSecret;
      }
      await env.save();
      context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
      // await command(
      //   "Deploy firebase functions.",
      //   [
      //     firebaseCommand,
      //     "deploy",
      //     "--only",
      //     "functions",
      //   ],
      //   workingDirectory: "firebase",
      // );
    }
  }
}
