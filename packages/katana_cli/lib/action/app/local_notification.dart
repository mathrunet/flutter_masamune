// Dart imports:
import 'dart:io';

// Package imports:
import 'package:image/image.dart';
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/action/firebase/messaging.dart';
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
    final notificationIcon =
        localNotification.get("android_notification_icon", "");
    label("Edit build.gradle.");
    final gradle = AppGradle();
    await gradle.load();
    final compileOptions = GradleAndroidCompileOptions(
      sourceCompatibility: "JavaVersion.VERSION_11",
      targetCompatibility: "JavaVersion.VERSION_11",
      coreLibraryDesugaringEnabled: true,
    );
    gradle.android?.compileOptions = compileOptions;
    final defaultConfig = gradle.android?.defaultConfig;
    if (defaultConfig == null) {
      throw Exception("defaultConfig is not found. Please check build.gradle.");
    }
    defaultConfig.multiDexEnabled = "true";
    if (!gradle.dependencies.any((e) =>
        e.group == "coreLibraryDesugaring" &&
        e.packageName == "com.android.tools:desugar_jdk_libs:2.1.4")) {
      gradle.dependencies.add(
        GradleDependencies(
          group: "coreLibraryDesugaring",
          packageName: "com.android.tools:desugar_jdk_libs:2.1.4",
          isKotlin: gradle.isKotlin,
        ),
      );
    }
    await gradle.save();
    if (notificationIcon.isNotEmpty) {
      label("Create notification icon.");
      final iconFile = File(notificationIcon);
      if (!iconFile.existsSync()) {
        error("Icon file not found in $notificationIcon.");
        return;
      }
      final iconImage = decodeImage(iconFile.readAsBytesSync())!;
      if (iconImage.width != 1024 || iconImage.height != 1024) {
        error("Icon files should be 1024 x 1024.");
        return;
      }
      for (final tmp in kSizeListNotificationIcon.entries) {
        label("Resize & Save to ${tmp.key}");
        final dir = Directory(tmp.key.parentPath());
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        final file = File(tmp.key);
        if (file.existsSync()) {
          await file.delete();
        }
        final resized = adjustColor(
          copyResize(
            iconImage,
            height: tmp.value,
            width: tmp.value,
            interpolation: Interpolation.average,
          ),
          mids: ColorUint8.rgb(255, 255, 255),
          blacks: ColorUint8.rgb(255, 255, 255),
          whites: ColorUint8.rgb(255, 255, 255),
        );
        await file.writeAsBytes(encodePng(resized, level: 9));
      }
    }
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
    if (notificationIcon.isNotEmpty &&
        !application.first.children.any((p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            (p0.attributes.any((item) =>
                item.name.toString() == "android:name" &&
                item.value ==
                    "com.google.firebase.messaging.default_notification_icon")))) {
      application.first.children.add(
        XmlElement(
          XmlName("meta-data"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.google.firebase.messaging.default_notification_icon",
            ),
            XmlAttribute(
              XmlName("android:resource"),
              "@mipmap/ic_launcher_notification",
            ),
          ],
          [],
        ),
      );
    }
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
