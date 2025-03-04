// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/android_manifest.dart';

/// Add a module for local PUSH notification.
///
/// ローカルPUSH通知を行うためのモジュールを追加します。
class AppLocalNotificationCliAction extends CliCommand with CliActionMixin {
  /// Add a module for local PUSH notification.
  ///
  /// ローカルPUSH通知を行うためのモジュールを追加します
  const AppLocalNotificationCliAction();

  @override
  String get description =>
      "Add a module for local PUSH notification. ローカルPUSH通知を行うためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("local_notification");
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
    final localNotification = app.getAsMap("local_notification");
    if (localNotification.isEmpty) {
      error(
          "The item [app]->[local_notification] is missing. Please add an item.");
      return;
    }
    label("Edit build.gradle.");
    final gradle = AppGradle();
    await gradle.load();
    final compileOptions = GradleAndroidCompileOptions(
      sourceCompatibility: "JavaVersion.VERSION_1_8",
      targetCompatibility: "JavaVersion.VERSION_1_8",
      coreLibraryDesugaringEnabled: false,
    );
    gradle.android?.compileOptions = compileOptions;
    final defaultConfig = gradle.android?.defaultConfig;
    if (defaultConfig == null) {
      throw Exception("defaultConfig is not found. Please check build.gradle.");
    }
    defaultConfig.multiDexEnabled = "true";
    if (!gradle.dependencies.any((e) =>
        e.group == "coreLibraryDesugaring" &&
        e.packageName == "com.android.tools:desugar_jdk_libs:1.2.2")) {
      gradle.dependencies.add(
        GradleDependencies(
            group: "coreLibraryDesugaring",
            packageName: "com.android.tools:desugar_jdk_libs:1.2.2"),
      );
    }
    await gradle.save();
    label("Edit Android Permissions.");
    await AndroidManifestPermissionType.scheduleExactAlarm.enablePermission();
    await AndroidManifestPermissionType.useExactAlarm.enablePermission();
    label("Edit AndroidManifest.xml.");
    final manifestFile = File("android/app/src/main/AndroidManifest.xml");
    if (!manifestFile.existsSync()) {
      throw Exception(
        "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final document = XmlDocument.parse(await manifestFile.readAsString());
    final manifest = document.findAllElements("manifest");
    if (manifest.isEmpty) {
      throw Exception(
        "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final application = document.findAllElements("application");
    final scheduledNotificationReceiver =
        application.first.children.firstWhereOrNull(
      (p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "receiver" &&
          p0.attributes.any(
            (p1) =>
                p1.name.toString() == "android:name" &&
                p1.value ==
                    "com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver",
          ),
    );
    if (scheduledNotificationReceiver == null) {
      application.first.children.add(
        XmlElement(
          XmlName("receiver"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver",
            ),
            XmlAttribute(
              XmlName("android:exported"),
              "false",
            ),
          ],
          [],
        ),
      );
    }
    final scheduledNotificationBootReceiver =
        application.first.children.firstWhereOrNull(
      (p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "receiver" &&
          p0.attributes.any(
            (p1) =>
                p1.name.toString() == "android:name" &&
                p1.value ==
                    "com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver",
          ),
    );
    if (scheduledNotificationBootReceiver == null) {
      application.first.children.add(
        XmlElement(
          XmlName("receiver"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver",
            ),
            XmlAttribute(
              XmlName("android:exported"),
              "false",
            ),
          ],
          [
            XmlElement(
              XmlName("intent-filter"),
              [],
              [
                XmlElement(
                  XmlName("action"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.BOOT_COMPLETED",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("action"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.MY_PACKAGE_REPLACED",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("category"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.QUICKBOOT_POWERON",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("category"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "com.htc.intent.action.QUICKBOOT_POWERON",
                    ),
                  ],
                  [],
                ),
              ],
            ),
          ],
        ),
      );
    }
    await manifestFile.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
    label("Edit AppDelegate.swift.");
    final appDelegateFile = File("ios/Runner/AppDelegate.swift");
    if (!appDelegateFile.existsSync()) {
      throw Exception(
        "AppDelegate.swift does not exist in `ios/Runner/AppDelegate.swift`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    var swift = await appDelegateFile.readAsString();
    if (!RegExp(r"UNUserNotificationCenter.current\(\).delegate")
        .hasMatch(swift)) {
      swift = swift.replaceFirst(
        "    GeneratedPluginRegistrant.register",
        "    if #available(iOS 10.0, *) {\n      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate\n    }\n    GeneratedPluginRegistrant.register",
      );
    }
    await appDelegateFile.writeAsString(swift);
    await addFlutterImport(
      [
        "masamune_notification_local",
      ],
    );
  }
}
