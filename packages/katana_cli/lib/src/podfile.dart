// Dart imports:
import 'dart:io';

// Package imports:
import 'package:katana/katana.dart';

/// Permission type for Podfile.
///
/// Podfile用のパーミッションタイプ。
enum PodfilePermissionType {
  /// Permissions for camera use.
  ///
  /// カメラ利用時のパーミッション。
  cameraUsage("PERMISSION_CAMERA"),

  /// Permissions for microphone use.
  ///
  /// マイク利用時のパーミッション。
  microphoneUsage("PERMISSION_MICROPHONE"),

  /// Permission for constant use of location information.
  ///
  /// 位置情報常時利用時のパーミッション。
  locationUsage("PERMISSION_LOCATION"),

  /// Permissions for motion sensor use.
  ///
  /// モーションセンサー利用時のパーミッション。
  motionUsageDescription("PERMISSION_SENSORS"),

  /// Permissions when using media services.
  ///
  /// メディアサービス利用時のパーミッション。
  serviceMediaLibrary("PERMISSION_MEDIA_LIBRARY"),

  /// Permissions for photo library use.
  ///
  /// フォトライブラリ利用時のパーミッション。
  photoLibraryUsage("PERMISSION_PHOTOS"),

  /// Permissions when using the Add to Photo Library feature.
  ///
  /// フォトライブラリへの追加機能利用時のパーミッション。
  photoLibraryAddUsage("PERMISSION_PHOTOS"),

  /// Permissions when using contacts.
  ///
  /// 連絡先利用時のパーミッション。
  contactsUsage("PERMISSION_CONTACTS"),

  /// Permissions for calendar use.
  ///
  /// カレンダー利用時のパーミッション。
  calendarsUsage("PERMISSION_EVENTS"),

  /// Permissions for reminder use.
  ///
  /// リマインダー利用時のパーミッション。
  remindersUsage("PERMISSION_REMINDERS"),

  /// Permissions for Bluetooth use.
  ///
  /// Bluetooth利用時のパーミッション。
  bluetoothUsage("PERMISSION_BLUETOOTH"),

  /// Permissions when using voice recognition.
  ///
  /// 音声認識利用時のパーミッション。
  speechRecognitionUsage("PERMISSION_SPEECH_RECOGNIZER"),

  /// Permissions when using user tracking.
  ///
  /// ユーザートラッキング利用時のパーミッション。
  userTrackingUsage("PERMISSION_APP_TRACKING_TRANSPARENCY");

  /// Permission type for Podfile.
  ///
  /// Podfile用のパーミッションタイプ。
  const PodfilePermissionType(this.id);

  /// Permission ID.
  ///
  /// パーミッションのID。
  final String id;

  static final _permissionsRegExp = RegExp(
    r"target.build_configurations.each do \|config\|[\s]+config.build_settings\['GCC_PREPROCESSOR_DEFINITIONS'\] \|\|= \[([\s\S]+)\][\s]+end",
  );

  /// Rewrite the podfile so that the specified permissions are available.
  ///
  /// 指定されたパーミッションを利用できるようにPodfileを書き換えます。
  Future<void> enablePermissionToPodfile() async {
    final podfile = File("ios/Podfile");
    if (!podfile.existsSync()) {
      throw Exception(
        "ios/Podfile does not exist. Please run `flutter create .` first.",
      );
    }
    final rawData = await podfile.readAsString();
    final match = _permissionsRegExp.firstMatch(rawData);
    if (match != null) {
      final permissionsText = match.group(1);
      final permissions = permissionsText!
          .split(",")
          .map((e) => e.trim().trimString("'"))
          .where((element) => element != r"$(inherited)")
          .map((e) => e.replaceAll("=1", ""))
          .where((element) => element.isNotEmpty)
          .toList();
      permissions.add(id);
      final distincted = permissions.distinct();
      final replaced = rawData.replaceAll(
        _permissionsRegExp,
        """target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '\$(inherited)',
${distincted.map(
              (e) => "        '$e=1',",
            ).join("\n")}
      ]
    end""",
      );
      await podfile.writeAsString(replaced);
    } else {
      final replaced = rawData.replaceAll(
          "flutter_additional_ios_build_settings(target)",
          """flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '\$(inherited)',
        '$id=1',
      ]
    end""");
      await podfile.writeAsString(replaced);
    }
  }
}
