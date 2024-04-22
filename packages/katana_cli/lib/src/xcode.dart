// Dart imports:
import 'dart:io';

// Package imports:
import 'package:katana/katana.dart';
import 'package:xml/xml.dart';

/// Utility to edit XCode's project.pbxproj.
///
/// XCodeのproject.pbxprojを編集するためのユーティリティ。
class XCode {
  /// Utility to edit XCode's project.pbxproj.
  ///
  /// XCodeのproject.pbxprojを編集するためのユーティリティ。
  XCode();

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// PBXProject data.
  ///
  /// PBXProjectのデータ。
  PBXProject? pbxProject;

  /// BuildFile data.
  ///
  /// BuildFileのデータ。
  List<PBXBuildFile> get pbxBuildFile => _pbxBuildFile;
  late List<PBXBuildFile> _pbxBuildFile;

  /// FileReference data.
  ///
  /// FileReferenceのデータ。
  List<PBXFileReference> get pbxFileReference => _pbxFileReference;
  late List<PBXFileReference> _pbxFileReference;

  /// PBXGroup data.
  ///
  /// PBXGroupのデータ。
  List<PBXGroup> get pbxGroup => _pbxGroup;
  late List<PBXGroup> _pbxGroup;

  /// ResourcesBuildPhase data.
  ///
  /// ResourcesBuildPhaseのデータ。
  List<PBXResourcesBuildPhase> get pbxResourcesBuildPhase =>
      _pbxResourcesBuildPhase;
  late List<PBXResourcesBuildPhase> _pbxResourcesBuildPhase;

  /// VariantGroup data.
  ///
  /// VariantGroupのデータ。
  List<PBXVariantGroup> get pbxVariantGroup => _pbxVariantGroup;
  late List<PBXVariantGroup> _pbxVariantGroup;

  /// BuildConfiguration data.
  ///
  /// BuildConfigurationのデータ。
  List<PBXBuildConfiguration> get pbxBuildConfiguration =>
      _pbxBuildConfiguration;
  late List<PBXBuildConfiguration> _pbxBuildConfiguration;

  /// PBXFrameworksBuildPhase data.
  ///
  /// PBXFrameworksBuildPhaseのデータ。
  List<PBXFrameworksBuildPhase> get pbxFrameworksBuildPhase =>
      _pbxFrameworksBuildPhase;
  late List<PBXFrameworksBuildPhase> _pbxFrameworksBuildPhase;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    _rawData = await pbx.readAsString();
    _pbxBuildFile = PBXBuildFile._load(_rawData);
    _pbxFileReference = PBXFileReference._load(_rawData);
    _pbxGroup = PBXGroup._load(_rawData);
    _pbxResourcesBuildPhase = PBXResourcesBuildPhase._load(_rawData);
    _pbxVariantGroup = PBXVariantGroup._load(_rawData);
    _pbxBuildConfiguration = PBXBuildConfiguration._load(_rawData);
    _pbxFrameworksBuildPhase = PBXFrameworksBuildPhase._load(_rawData);
    pbxProject = PBXProject._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = PBXProject._save(_rawData, pbxProject);
    _rawData = PBXVariantGroup._save(_rawData, _pbxVariantGroup);
    _rawData = PBXResourcesBuildPhase._save(_rawData, _pbxResourcesBuildPhase);
    _rawData = PBXGroup._save(_rawData, _pbxGroup);
    _rawData = PBXFileReference._save(_rawData, _pbxFileReference);
    _rawData = PBXBuildFile._save(_rawData, _pbxBuildFile);
    _rawData = PBXBuildConfiguration._save(_rawData, _pbxBuildConfiguration);
    _rawData =
        PBXFrameworksBuildPhase._save(_rawData, _pbxFrameworksBuildPhase);
    // _rawData = _rawData.replaceFirstMapped(
    //   RegExp(r"objectVersion = ([0-9]+);"),
    //   (m) => "objectVersion = ${(int.tryParse(m.group(1) ?? "") ?? 0) + 1};",
    // );
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    await pbx.writeAsString(_rawData);
  }

  /// Add a new framework.
  ///
  /// [frameworkName] should be a name that does not include up to `.framework`.
  ///
  /// 新しいフレームワークを追加します。
  ///
  /// [frameworkName]は`.framework`まで含めない名前を記述します。
  void addFramework({
    required String frameworkName,
  }) {
    if (pbxFileReference.any((e) => e.name == "$frameworkName.framework")) {
      return;
    }
    final id = generateId();
    final fileId = generateId();
    pbxFileReference.add(
      PBXFileReference(
        id: fileId,
        name: "$frameworkName.framework",
        comment: "$frameworkName.framework",
        path: "System/Library/Frameworks/$frameworkName.framework",
        sourceTree: "SDKROOT",
        lastKnownFileType: "wrapper.framework",
      ),
    );
    final frameworksBuildPhase = pbxFrameworksBuildPhase.first;
    if (!frameworksBuildPhase.files
        .any((e) => e.fileName == "$frameworkName.framework")) {
      frameworksBuildPhase.files.add(
        PBXFrameworksBuildPhaseFiles(
          id: id,
          fileName: "$frameworkName.framework",
          fileDir: "Frameworks",
        ),
      );
    }
    final frameworkGroup =
        pbxGroup.firstWhere((item) => item.name == "Frameworks");
    if (!frameworkGroup.children
        .any((e) => e.comment == "$frameworkName.framework")) {
      frameworkGroup.children.add(
        PBXGroupChild(
          id: fileId,
          comment: "$frameworkName.framework",
        ),
      );
    }
    if (!pbxBuildFile
        .any((element) => element.fileName == "$frameworkName.framework")) {
      pbxBuildFile.add(
        PBXBuildFile(
          id: id,
          fileName: "$frameworkName.framework",
          fileDir: "Frameworks",
          fileRef: fileId,
        ),
      );
    }
  }

  /// Create an ID for XCode.
  ///
  /// XCode用のIDを作成します。
  static String generateId() {
    return generateCode(24, charSet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  }

  /// Create InfoPlist.strings in the language given in [locales] and update project.pbxproj.
  ///
  /// [locales]で与えた言語でInfoPlist.stringsを作成し、project.pbxprojを更新します。
  static Future<void> createIOSInfoPlistStrings(
    List<String> locales,
  ) async {
    for (final tmp in locales) {
      final dir = Directory(
        "ios/Runner/$tmp.lproj",
      );
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final file = File("${dir.path}/InfoPlist.strings");
      if (!file.existsSync()) {
        await file.writeAsString("");
      }
    }
    final dir = Directory("ios/Runner/Base.lproj");
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final file = File("${dir.path}/InfoPlist.strings");
    if (!file.existsSync()) {
      await file.writeAsString("");
    }
    final xcode = XCode();
    await xcode.load();
    late String variantGroupId;
    late String buildFileId;
    final fileIds = <String, String>{};
    for (final tmp in locales) {
      if (tmp.isEmpty) {
        continue;
      }
      final ref = xcode.pbxFileReference.firstWhereOrNull((e) => e.name == tmp);
      if (ref == null) {
        final id = XCode.generateId();
        fileIds[tmp] = id;
        xcode.pbxFileReference.add(
          PBXFileReference(
            id: id,
            name: tmp,
            path: "$tmp.lproj/InfoPlist.strings",
            comment: tmp,
            sourceTree: '"<group>"',
            lastKnownFileType: "text.plist.strings",
          ),
        );
      } else {
        fileIds[tmp] = ref.id;
      }
    }
    final variantGroup = xcode.pbxVariantGroup
        .firstWhereOrNull((e) => e.name == "InfoPlist.strings");
    if (variantGroup != null) {
      variantGroupId = variantGroup.id;
      variantGroup.children.clear();
      variantGroup.children.addAll(
        fileIds.toList(
          (key, value) => PBXVariantGroupChild(
            id: value,
            comment: key,
          ),
        ),
      );
    } else {
      variantGroupId = XCode.generateId();
      xcode.pbxVariantGroup.add(
        PBXVariantGroup(
          id: variantGroupId,
          children: fileIds
              .toList(
                (key, value) => PBXVariantGroupChild(
                  id: value,
                  comment: key,
                ),
              )
              .toList(),
          name: "InfoPlist.strings",
          sourceTree: '"<group>"',
        ),
      );
    }
    final runner = xcode.pbxGroup.firstWhereOrNull((e) => e.path == "Runner");
    if (runner == null) {
      throw Exception("Runner is not associated with XCode.");
    }
    if (!runner.children.any((e) => e.id == variantGroupId)) {
      runner.children.add(
        PBXGroupChild(id: variantGroupId, comment: "InfoPlist.strings"),
      );
    }
    final buildFile =
        xcode.pbxBuildFile.firstWhereOrNull((e) => e.fileRef == variantGroupId);
    if (buildFile != null) {
      buildFileId = buildFile.id;
    } else {
      buildFileId = XCode.generateId();
      xcode.pbxBuildFile.add(
        PBXBuildFile(
          id: buildFileId,
          fileRef: variantGroupId,
          fileName: "InfoPlist.strings",
          fileDir: "Resources",
        ),
      );
    }
    final buildPhase = xcode.pbxResourcesBuildPhase.firstWhereOrNull(
      (item) => item.files.any((element) =>
          element.fileName == "AppFrameworkInfo.plist" &&
          element.fileDir == "Resources"),
    );
    if (buildPhase != null &&
        !buildPhase.files.any((e) => e.id == buildFileId)) {
      buildPhase.files.add(
        PBXResourcesBuildPhaseFile(
          id: buildFileId,
          fileName: "InfoPlist.strings",
          fileDir: "Resources",
        ),
      );
    }
    await xcode.save();
  }

  /// Create an empty Runner.entitlements and update project.pbxproj.
  ///
  /// 空のRunner.entitlementsを作成し、project.pbxprojを更新します。
  static Future<void> createRunnerEntitlements() async {
    final entitlements = File("ios/Runner/Runner.entitlements");
    if (!entitlements.existsSync()) {
      await entitlements.writeAsString(
        """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
</dict>
</plist>""",
      );
    }
    final xcode = XCode();
    await xcode.load();
    late String fileId;
    final ref = xcode.pbxFileReference
        .firstWhereOrNull((e) => e.path == "Runner.entitlements");
    if (ref == null) {
      final id = XCode.generateId();
      fileId = id;
      xcode.pbxFileReference.add(
        PBXFileReference(
          id: id,
          path: "Runner.entitlements",
          comment: "Runner.entitlements",
          sourceTree: '"<group>"',
          lastKnownFileType: "text.plist.entitlements",
        ),
      );
    } else {
      fileId = ref.id;
    }
    final runner = xcode.pbxGroup.firstWhereOrNull((e) => e.path == "Runner");
    if (runner == null) {
      throw Exception("Runner is not associated with XCode.");
    }
    if (!runner.children.any((e) => e.id == fileId)) {
      runner.children.add(
        PBXGroupChild(id: fileId, comment: "Runner.entitlements"),
      );
    }
    final buildConfigurations = xcode.pbxBuildConfiguration
        .where((element) => element.baseConfigurationReference.isNotEmpty);
    for (final buildConfiguration in buildConfigurations) {
      final buildSetting = buildConfiguration.buildSettings;
      if (!buildSetting.any((e) => e.key == "CODE_SIGN_ENTITLEMENTS")) {
        buildConfiguration.buildSettings.add(
          PBXBuildConfigurationSettings(
            key: "CODE_SIGN_ENTITLEMENTS",
            value: "Runner/Runner.entitlements",
          ),
        );
      }
    }
    await xcode.save();
  }

  /// Create an empty PrivacyInfo.xcprivacy and update project.pbxproj.
  ///
  /// 空のPrivacyInfo.xcprivacyを作成し、project.pbxprojを更新します。
  static Future<void> createPrivacyManifests() async {
    final entitlements = File("ios/PrivacyInfo.xcprivacy");
    if (!entitlements.existsSync()) {
      await entitlements.writeAsString(
        """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
</dict>
</plist>
""",
      );
    }
    final xcode = XCode();
    await xcode.load();
    late String fileId;
    late String buildFileId;
    final ref = xcode.pbxFileReference
        .firstWhereOrNull((e) => e.path == "PrivacyInfo.xcprivacy");
    if (ref == null) {
      final id = XCode.generateId();
      fileId = id;
      xcode.pbxFileReference.add(
        PBXFileReference(
          id: id,
          path: "PrivacyInfo.xcprivacy",
          comment: "PrivacyInfo.xcprivacy",
          sourceTree: '"<group>"',
          lastKnownFileType: "text.xml",
        ),
      );
    } else {
      fileId = ref.id;
    }
    final root = xcode.pbxGroup
        .firstWhereOrNull((e) => e.path.isEmpty && e.name.isEmpty);
    if (root == null) {
      throw Exception("Root is not associated with XCode.");
    }
    if (!root.children.any((e) => e.id == fileId)) {
      root.children.add(
        PBXGroupChild(id: fileId, comment: "PrivacyInfo.xcprivacy"),
      );
    }
    final buildFile = xcode.pbxBuildFile
        .firstWhereOrNull((element) => element.fileRef == fileId);
    if (buildFile != null) {
      buildFileId = buildFile.id;
    } else {
      buildFileId = XCode.generateId();
      xcode.pbxBuildFile.add(
        PBXBuildFile(
          id: buildFileId,
          fileRef: fileId,
          fileName: "PrivacyInfo.xcprivacy",
          fileDir: "Resources",
        ),
      );
    }

    final buildPhase = xcode.pbxResourcesBuildPhase.firstWhereOrNull(
      (item) => item.files.any((element) =>
          element.fileName == "AppFrameworkInfo.plist" &&
          element.fileDir == "Resources"),
    );
    if (buildPhase != null &&
        !buildPhase.files.any((e) => e.id == buildFileId)) {
      buildPhase.files.add(
        PBXResourcesBuildPhaseFile(
          id: buildFileId,
          fileName: "PrivacyInfo.xcprivacy",
          fileDir: "Resources",
        ),
      );
    }
    await xcode.save();
  }
}

/// Permission message type for XCode.
///
/// XCode用のパーミッションメッセージタイプ。
enum XCodePermissionType {
  /// Permissions for camera use.
  ///
  /// カメラ利用時のパーミッション。
  cameraUsage("NSCameraUsageDescription"),

  /// Permissions for microphone use.
  ///
  /// マイク利用時のパーミッション。
  microphoneUsage("NSMicrophoneUsageDescription"),

  /// Permissions when using location information.
  ///
  /// 位置情報利用時のパーミッション。
  locationWhenInUseUsage("NSLocationWhenInUseUsageDescription"),

  /// Permission for constant use of location information.
  ///
  /// 位置情報常時利用時のパーミッション。
  locationAlwaysAndWhenInUseUsage(
    "NSLocationAlwaysAndWhenInUseUsageDescription",
  ),

  /// Permission for constant use of location information.
  ///
  /// 位置情報常時利用時のパーミッション。
  locationAlwaysUsage("NSLocationAlwaysUsageDescription"),

  /// Permissions for motion sensor use.
  ///
  /// モーションセンサー利用時のパーミッション。
  motionUsageDescription("NSMotionUsageDescription"),

  /// Permissions when using media services.
  ///
  /// メディアサービス利用時のパーミッション。
  serviceMediaLibrary("kTCCServiceMediaLibrary"),

  /// Permissions for photo library use.
  ///
  /// フォトライブラリ利用時のパーミッション。
  photoLibraryUsage("NSPhotoLibraryUsageDescription"),

  /// Permissions when using the Add to Photo Library feature.
  ///
  /// フォトライブラリへの追加機能利用時のパーミッション。
  photoLibraryAddUsage("NSPhotoLibraryAddUsageDescription"),

  /// Permissions when using contacts.
  ///
  /// 連絡先利用時のパーミッション。
  contactsUsage("NSContactsUsageDescription"),

  /// Permissions for calendar use.
  ///
  /// カレンダー利用時のパーミッション。
  calendarsUsage("NSCalendarsUsageDescription"),

  /// Permissions for reminder use.
  ///
  /// リマインダー利用時のパーミッション。
  remindersUsage("NSRemindersUsageDescription"),

  /// Permissions for Bluetooth use.
  ///
  /// Bluetooth利用時のパーミッション。
  bluetoothPeripheralUsage("NSBluetoothPeripheralUsageDescription"),

  /// Permissions for Bluetooth use.
  ///
  /// Bluetooth利用時のパーミッション。
  bluetoothAlwaysUsage("NSBluetoothAlwaysUsageDescription"),

  /// Permissions when using Apple Music.
  ///
  /// Apple Music利用時のパーミッション。
  appleMusicUsage("NSAppleMusicUsageDescription"),

  /// Permissions when using voice recognition.
  ///
  /// 音声認識利用時のパーミッション。
  speechRecognitionUsage("NSSpeechRecognitionUsageDescription"),

  /// Permissions when using user tracking.
  ///
  /// ユーザートラッキング利用時のパーミッション。
  userTrackingUsage("NSUserTrackingUsageDescription");

  /// Permission message type for XCode.
  ///
  /// XCode用のパーミッションメッセージタイプ。
  const XCodePermissionType(this.id);

  /// Permission ID.
  ///
  /// パーミッションのID。
  final String id;

  /// Add a message for authorization permission based on the language (key) and message (value) given in [messages].
  ///
  /// [messages]で与えた言語（キー）とメッセージ（値）を元に権限許可用のメッセージを追加します。
  Future<void> setMessageToXCode(Map<String, String> messages) async {
    await XCode.createIOSInfoPlistStrings(messages.keys.toList());
    for (final tmp in messages.entries) {
      if (tmp.key.isEmpty) {
        continue;
      }
      final dir = Directory(
        "ios/Runner/${tmp.key}.lproj",
      );
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final text = '$id = "${tmp.value}";';
      final file = File("${dir.path}/InfoPlist.strings");
      if (!file.existsSync()) {
        await file.writeAsString(text);
      } else {
        final data = await file.readAsString();
        final regExp = RegExp(id + r'[\s]*=[\s]*"([^"]+)";');
        if (regExp.hasMatch(data)) {
          await file.writeAsString(data.replaceAll(regExp, text));
        } else {
          await file.writeAsString("$data\n$text");
        }
      }
    }
    final base = messages.entries.firstWhereOrNull((item) => item.key == "") ??
        messages.entries.firstOrNull;
    if (base != null) {
      final dir = Directory("ios/Runner/Base.lproj");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final text = '$id = "${base.value}";';
      final file = File("${dir.path}/InfoPlist.strings");
      if (!file.existsSync()) {
        await file.writeAsString(text);
      } else {
        final data = await file.readAsString();
        final regExp = RegExp(id + r'[\s]*=[\s]*"([^"]+)";');
        if (regExp.hasMatch(data)) {
          await file.writeAsString(data.replaceAll(regExp, text));
        } else {
          await file.writeAsString("$data\n$text");
        }
      }
      final plist = File("ios/Runner/Info.plist");
      final document = XmlDocument.parse(await plist.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      final node = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == id;
      });
      if (node == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText(id)],
            ),
            XmlElement(
              XmlName("string"),
              [],
              [XmlText(base.value)],
            ),
          ],
        );
      } else {
        final value = node.nextElementSibling;
        if (value != null) {
          final text = value.children
              .firstWhereOrNull((item) => item is XmlText) as XmlText?;
          text?.value = base.value;
        }
      }
      await plist.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
  }
}

/// Privacy Manifest for XCode.
///
/// XCode用のプライバシーマニフェスト。
enum XCodePrivacyManifests {
  /// `active_keyboards` type.
  ///
  /// `active_keyboards`のタイプ。
  activeKeyboards(
    id: "active_keyboards",
    type: "NSPrivacyAccessedAPICategoryActiveKeyboards",
    reasons: [
      "3EC4.1", // Custom keyboard app on-device, per documentation
      "54BD.1", // Customize UI on-device, per documentation
    ],
  ),

  /// `file_timestamp` type.
  ///
  /// `file_timestamp`のタイプ。
  fileTimestamp(
    id: "file_timestamp",
    type: "NSPrivacyAccessedAPICategoryFileTimestamp",
    reasons: [
      "0A2A.1", // 3rd-party SDK wrapper on-device, per documentation
      "3B52.1", // Files provided to app by user, per documentation
      "C617.1", // Inside app or group container, per documentation
      "DDA9.1", // Display to user on-device, per documentation
    ],
  ),

  /// `system_boot_time` type.
  ///
  /// `system_boot_time`のタイプ。
  systemBootTime(
    id: "system_boot_time",
    type: "NSPrivacyAccessedAPICategorySystemBootTime",
    reasons: [
      "35F9.1", // Measure time on-device, per documentation
    ],
  ),

  /// `disk_space` type.
  ///
  /// `disk_space`のタイプ。
  diskSpace(
    id: "disk_space",
    type: "NSPrivacyAccessedAPICategoryDiskSpace",
    reasons: [
      "85F4.1", // Display to user on-device, per documentation
      "7D9E.1", // User-initiated bug report, per documentation
      "E174.1", // Write or delete file on-device, per documentation
    ],
  ),

  /// `user_defaults` type.
  ///
  /// `user_defaults`のタイプ。
  userDefaults(
    id: "user_defaults",
    type: "NSPrivacyAccessedAPICategoryUserDefaults",
    reasons: [
      "C56D.1", // 3rd-party SDK wrapper on-device, per documentation
      "1C8F.1", // Access info from same App Group, per documentation
      "AC6B.1", // Access managed app configuration, per documentation
      "CA92.1", // Access info from same app, per documentation
    ],
  );

  /// Privacy Manifest for XCode.
  ///
  /// XCode用のプライバシーマニフェスト。
  const XCodePrivacyManifests({
    required this.id,
    required this.type,
    required this.reasons,
  });

  /// Type ID.
  ///
  /// タイプのID.
  final String id;

  /// Keys in XCode of type.
  ///
  /// タイプのXCode内でのキー。
  final String type;

  /// ID list of reasons.
  ///
  /// 理由のIDリスト。
  final List<String> reasons;

  /// Set the privacy manifest based on the ID given in [reasonId].
  ///
  /// If [reasonId] does not match, an error is output.
  ///
  /// [reasonId]で与えたIDを元にプライバシーマニフェストの設定を行います。
  ///
  /// [reasonId]が一致しない場合エラーが出力されます。
  Future<void> setPrivacyManifestToXCode(String reasonId) async {
    if (!reasons.any((element) => element == reasonId)) {
      throw Exception("The reason ID does not match the list of reasons.");
    }
    await XCode.createPrivacyManifests();
    final manifests = File("ios/PrivacyInfo.xcprivacy");
    final document = XmlDocument.parse(await manifests.readAsString());
    final dict = document.findAllElements("dict").firstOrNull;
    if (dict == null) {
      throw Exception(
        "Could not find `dict` element in `ios/PrivacyInfo.xcprivacy`. File is corrupt.",
      );
    }
    final typesKey = dict.children.firstWhereOrNull((p0) {
      return p0 is XmlElement &&
          p0.name.toString() == "key" &&
          p0.innerText == "NSPrivacyAccessedAPITypes";
    });
    if (typesKey == null) {
      dict.children.addAll(
        [
          XmlElement(
            XmlName("key"),
            [],
            [XmlText("NSPrivacyAccessedAPITypes")],
          ),
          XmlElement(
            XmlName("array"),
            [],
            [
              XmlElement(
                XmlName("dict"),
                [],
                [
                  XmlElement(
                    XmlName("key"),
                    [],
                    [XmlText("NSPrivacyAccessedAPIType")],
                  ),
                  XmlElement(
                    XmlName("string"),
                    [],
                    [XmlText(type)],
                  ),
                  XmlElement(
                    XmlName("key"),
                    [],
                    [XmlText("NSPrivacyAccessedAPITypeReasons")],
                  ),
                  XmlElement(
                    XmlName("array"),
                    [],
                    [
                      XmlElement(
                        XmlName("string"),
                        [],
                        [XmlText(reasonId)],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      final types = typesKey.nextElementSibling;
      final node = types?.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "dict" &&
            p0.children.any((p1) {
              return p1 is XmlElement &&
                  p1.name.toString() == "string" &&
                  p1.innerText == type;
            });
      });
      if (node != null) {
        final reasonKey = node.children.firstWhereOrNull((item) {
          return item is XmlElement &&
              item.name.toString() == "key" &&
              item.innerText == "NSPrivacyAccessedAPITypeReasons";
        });
        final array = reasonKey?.nextElementSibling;
        if (array != null) {
          final value = array.children.firstWhereOrNull((item) {
            return item is XmlElement &&
                item.name.toString() == "string" &&
                item.innerText == reasonId;
          });
          if (value != null) {
            final text = value.children
                .firstWhereOrNull((item) => item is XmlText) as XmlText?;
            text?.value = reasonId;
          }
        }
      } else {
        types?.children.addAll([
          XmlElement(
            XmlName("dict"),
            [],
            [
              XmlElement(
                XmlName("key"),
                [],
                [XmlText("NSPrivacyAccessedAPIType")],
              ),
              XmlElement(
                XmlName("string"),
                [],
                [XmlText(type)],
              ),
              XmlElement(
                XmlName("key"),
                [],
                [XmlText("NSPrivacyAccessedAPITypeReasons")],
              ),
              XmlElement(
                XmlName("array"),
                [],
                [
                  XmlElement(
                    XmlName("string"),
                    [],
                    [XmlText(reasonId)],
                  ),
                ],
              ),
            ],
          ),
        ]);
      }
    }
    await manifests.writeAsString(
      document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
    );
  }
}

/// BuildFile data.
///
/// BuildFileのデータ。
class PBXBuildFile {
  /// BuildFile data.
  ///
  /// BuildFileのデータ。
  factory PBXBuildFile({
    String? id,
    required String fileRef,
    required String fileName,
    required String fileDir,
  }) {
    return PBXBuildFile._(
      fileDir: fileDir,
      fileName: fileName,
      fileRef: fileRef,
      id: id ?? XCode.generateId(),
    );
  }
  PBXBuildFile._({
    required this.id,
    required this.fileRef,
    required this.fileName,
    required this.fileDir,
  });

  static List<PBXBuildFile> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXBuildFile section \*/([\s\S]+)/\* End PBXBuildFile section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r"([0-9A-Z]{24}) /\* ([a-zA-Z_.-]+) in ([a-zA-Z_.-]+) \*/ = {isa = PBXBuildFile; fileRef = ([0-9A-Z]{24}) /\* ([a-zA-Z_.-]+) \*/; };",
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXBuildFile._(
        id: e.group(1) ?? "",
        fileName: e.group(2) ?? "",
        fileDir: e.group(3) ?? "",
        fileRef: e.group(4) ?? "",
      );
    });
  }

  static String _save(String content, List<PBXBuildFile> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXBuildFile section \*/([\s\S]+)/\* End PBXBuildFile section \*/",
      ),
      "/* Begin PBXBuildFile section */\n$code\n/* End PBXBuildFile section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXBuildFile";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Value of `fileRef`.
  ///
  /// `fileRef`の値。
  final String fileRef;

  /// File name for comments.
  ///
  /// コメント用のファイル名。
  final String fileName;

  /// Name of file folder for comments.
  ///
  /// コメント用のファイルフォルダ名。
  final String fileDir;

  @override
  String toString() {
    return "\t\t$id /* $fileName in $fileDir */ = {isa = PBXBuildFile; fileRef = $fileRef /* $fileName */; };";
  }
}

/// FileReference data.
///
/// FileReferenceのデータ。
class PBXFileReference {
  /// FileReference data.
  ///
  /// FileReferenceのデータ。
  factory PBXFileReference({
    String? id,
    String? lastKnownFileType,
    required String path,
    required String comment,
    String? name,
    String? explicitFileType,
    int? fileEncoding,
    int? includeInIndex,
    required String sourceTree,
  }) {
    return PBXFileReference._(
      name: name,
      path: path,
      sourceTree: sourceTree,
      comment: comment,
      lastKnownFileType: lastKnownFileType,
      explicitFileType: explicitFileType,
      fileEncoding: fileEncoding,
      includeInIndex: includeInIndex,
      id: id ?? XCode.generateId(),
    );
  }
  PBXFileReference._({
    required this.id,
    this.lastKnownFileType,
    required this.path,
    required this.comment,
    this.name,
    this.fileEncoding,
    this.explicitFileType,
    this.includeInIndex,
    required this.sourceTree,
  });

  static List<PBXFileReference> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXFileReference section \*/([\s\S]+)/\* End PBXFileReference section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/ = {isa = PBXFileReference; (fileEncoding = (?<fileEncoding>[0-9]+); )?(explicitFileType = (?<explicitFileType>[a-zA-Z_.-]+); )?(includeInIndex = (?<includeInIndex>[0-9]+); )?(lastKnownFileType = (?<lastKnownFileType>[a-zA-Z_.-]+); )?(name = (?<name>[a-zA-Z_."-]+); )?path = (?<path>[a-zA-Z_ ."/-]+); sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+); };',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXFileReference._(
        id: e.namedGroup("id") ?? "",
        lastKnownFileType: e.namedGroup("lastKnownFileType"),
        name: e.namedGroup("name"),
        comment: e.namedGroup("comment") ?? "",
        path: e.namedGroup("path") ?? "",
        sourceTree: e.namedGroup("sourceTree") ?? "",
        fileEncoding: int.tryParse(e.namedGroup("fileEncoding") ?? ""),
        explicitFileType: e.namedGroup("explicitFileType"),
        includeInIndex: int.tryParse(e.namedGroup("includeInIndex") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXFileReference> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXFileReference section \*/([\s\S]+)/\* End PBXFileReference section \*/",
      ),
      "/* Begin PBXFileReference section */\n$code\n/* End PBXFileReference section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXFileReference";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// `lastKnownFileType` information.
  ///
  /// `lastKnownFileType`の情報。
  final String? lastKnownFileType;

  /// File Path.
  ///
  /// ファイルパス。
  final String path;

  /// File Name.
  ///
  /// ファイル名。
  final String? name;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  /// SourceTree data.
  ///
  /// SourceTreeのデータ。
  final String sourceTree;

  /// File encoding number.
  ///
  /// ファイルエンコーディング番号。
  final int? fileEncoding;

  /// Data of `explicitFileType`.
  ///
  /// `explicitFileType`のデータ。
  final String? explicitFileType;

  /// Data for `includeInIndex`.
  ///
  /// `includeInIndex`のデータ。
  final int? includeInIndex;

  @override
  String toString() {
    return '\t\t$id /* $comment */ = {isa = PBXFileReference; ${fileEncoding != null ? "fileEncoding = $fileEncoding; " : ""}${explicitFileType != null ? "explicitFileType = $explicitFileType; " : ""}${includeInIndex != null ? "includeInIndex = $includeInIndex; " : ""}${lastKnownFileType != null ? "lastKnownFileType = $lastKnownFileType; " : ""}${name != null ? "name = $name; " : ""}path = $path; sourceTree = $sourceTree; };';
  }
}

/// PBXGroup data.
///
/// PBXGroupのデータ。
class PBXGroup {
  /// PBXGroup data.
  ///
  /// PBXGroupのデータ。
  factory PBXGroup({
    String? id,
    String? comment,
    required String sourceTree,
    required List<PBXGroupChild> children,
    String? path,
    String? name,
  }) {
    return PBXGroup._(
      sourceTree: sourceTree,
      comment: comment,
      children: children,
      path: path,
      name: name,
      id: id ?? XCode.generateId(),
    );
  }
  PBXGroup._({
    required this.id,
    this.comment,
    this.path,
    this.name,
    required this.sourceTree,
    required this.children,
  });

  static List<PBXGroup> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXGroup section \*/([\s\S]+)/\* End PBXGroup section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXGroup;[\s\t\n]+children = \((?<children>[^\)]+)\);[\s\t\n]+(name = (?<name>[a-zA-Z_."-]+);[\s\t\n]+)?(path = (?<path>[a-zA-Z_ ."-]+);[\s\t\n]+)?sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXGroup._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        name: e.namedGroup("name"),
        path: e.namedGroup("path"),
        sourceTree: e.namedGroup("sourceTree") ?? "",
        children: PBXGroupChild._parse(e.namedGroup("children") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXGroup> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXGroup section \*/([\s\S]+)/\* End PBXGroup section \*/",
      ),
      "/* Begin PBXGroup section */\n$code\n/* End PBXGroup section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXGroup";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// Data for [PBXGroupChild].
  ///
  /// [PBXGroupChild]のデータ。
  final List<PBXGroupChild> children;

  /// Group Name.
  ///
  /// グループ名。
  final String? name;

  /// Group Pass.
  ///
  /// グループパス。
  final String? path;

  /// `soruceTree` data.
  ///
  /// `soruceTree`のデータ。
  final String sourceTree;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n${children.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n${name != null ? "\t\t\tname = $name;\n" : ""}${path != null ? "\t\t\tpath = $path;\n" : ""}\t\t\tsourceTree = $sourceTree;\n\t\t};";
  }
}

/// Class for `children` of [PBXGroup].
///
/// [PBXGroup]の`children`用のクラス。
class PBXGroupChild {
  /// Class for `children` of [PBXGroup].
  ///
  /// [PBXGroup]の`children`用のクラス。
  factory PBXGroupChild({
    String? id,
    required String comment,
  }) {
    return PBXGroupChild._(
      comment: comment,
      id: id ?? XCode.generateId(),
    );
  }
  PBXGroupChild._({
    required this.id,
    required this.comment,
  });

  static List<PBXGroupChild> _parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXGroupChild._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  @override
  String toString() {
    return "\t\t\t\t$id /* $comment */";
  }
}

/// ResourcesBuildPhase data.
///
/// ResourcesBuildPhaseのデータ。
class PBXResourcesBuildPhase {
  /// ResourcesBuildPhase data.
  ///
  /// ResourcesBuildPhaseのデータ。
  factory PBXResourcesBuildPhase({
    String? id,
    String? comment,
    required List<PBXResourcesBuildPhaseFile> files,
    required int buildActionMask,
    required int runOnlyForDeploymentPostprocessing,
  }) {
    return PBXResourcesBuildPhase._(
      buildActionMask: buildActionMask,
      comment: comment,
      files: files,
      runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing,
      id: id ?? XCode.generateId(),
    );
  }
  PBXResourcesBuildPhase._({
    required this.id,
    this.comment,
    required this.buildActionMask,
    required this.runOnlyForDeploymentPostprocessing,
    required this.files,
  });

  static List<PBXResourcesBuildPhase> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXResourcesBuildPhase section \*/([\s\S]+)/\* End PBXResourcesBuildPhase section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXResourcesBuildPhase;[\s\t\n]+buildActionMask = (?<buildActionMask>[0-9]+);[\s\t\n]+files = \((?<files>[^\)]+)\);[\s\t\n]+runOnlyForDeploymentPostprocessing = (?<runOnlyForDeploymentPostprocessing>[0-9]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXResourcesBuildPhase._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        buildActionMask:
            int.tryParse(e.namedGroup("buildActionMask") ?? "") ?? 0,
        runOnlyForDeploymentPostprocessing: int.tryParse(
              e.namedGroup("runOnlyForDeploymentPostprocessing") ?? "",
            ) ??
            0,
        files: PBXResourcesBuildPhaseFile._parse(e.namedGroup("files") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXResourcesBuildPhase> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXResourcesBuildPhase section \*/([\s\S]+)/\* End PBXResourcesBuildPhase section \*/",
      ),
      "/* Begin PBXResourcesBuildPhase section */\n$code\n/* End PBXResourcesBuildPhase section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXResourcesBuildPhase";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment file.
  ///
  /// コメントファイル。
  final String? comment;

  /// List of files in [PBXResourcesBuildPhase].
  ///
  /// [PBXResourcesBuildPhase]のファイル一覧。
  final List<PBXResourcesBuildPhaseFile> files;

  /// Data for `buildActionMask`.
  ///
  /// `buildActionMask`のデータ。
  final int buildActionMask;

  /// Data for `runOnlyForDeploymentPostprocessing`.
  ///
  /// `runOnlyForDeploymentPostprocessing`のデータ。
  final int runOnlyForDeploymentPostprocessing;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = $buildActionMask;\n\t\t\tfiles = (\n${files.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = $runOnlyForDeploymentPostprocessing;\n\t\t};";
  }
}

/// Class for [PBXResourcesBuildPhase] files.
///
/// [PBXResourcesBuildPhase]のファイル用のクラス。
class PBXResourcesBuildPhaseFile {
  /// Class for [PBXResourcesBuildPhase] files.
  ///
  /// [PBXResourcesBuildPhase]のファイル用のクラス。
  factory PBXResourcesBuildPhaseFile({
    String? id,
    required String fileName,
    required String fileDir,
  }) {
    return PBXResourcesBuildPhaseFile._(
      fileName: fileName,
      fileDir: fileDir,
      id: id ?? XCode.generateId(),
    );
  }
  PBXResourcesBuildPhaseFile._({
    required this.id,
    required this.fileName,
    required this.fileDir,
  });

  static List<PBXResourcesBuildPhaseFile> _parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<fileName>[a-zA-Z_.-]+) in (?<fileDir>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXResourcesBuildPhaseFile._(
        id: e.namedGroup("id") ?? "",
        fileName: e.namedGroup("fileName") ?? "",
        fileDir: e.namedGroup("fileDir") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// File name for comments.
  ///
  /// コメント用のファイル名。
  final String fileName;

  /// Name of file folder for comments.
  ///
  /// コメント用のファイルフォルダ名。
  final String fileDir;

  @override
  String toString() {
    return "\t\t\t\t$id /* $fileName in $fileDir */";
  }
}

/// VariantGroup data.
///
/// VariantGroupのデータ。
class PBXVariantGroup {
  /// VariantGroup data.
  ///
  /// VariantGroupのデータ。
  factory PBXVariantGroup({
    String? id,
    String? comment,
    required List<PBXVariantGroupChild> children,
    required String name,
    required String sourceTree,
  }) {
    return PBXVariantGroup._(
      name: name,
      comment: comment,
      children: children,
      sourceTree: sourceTree,
      id: id ?? XCode.generateId(),
    );
  }
  PBXVariantGroup._({
    required this.id,
    this.comment,
    required this.name,
    required this.sourceTree,
    required this.children,
  });

  static List<PBXVariantGroup> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXVariantGroup section \*/([\s\S]+)/\* End PBXVariantGroup section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXVariantGroup;[\s\t\n]+children = \((?<children>[^\)]+)\);[\s\t\n]+name = (?<name>[a-zA-Z_."-]+);[\s\t\n]+sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXVariantGroup._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        name: e.namedGroup("name") ?? "",
        sourceTree: e.namedGroup("sourceTree") ?? "",
        children: PBXVariantGroupChild.parse(e.namedGroup("children") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXVariantGroup> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXVariantGroup section \*/([\s\S]+)/\* End PBXVariantGroup section \*/",
      ),
      "/* Begin PBXVariantGroup section */\n$code\n/* End PBXVariantGroup section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXVariantGroup";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// List of data in the group.
  ///
  /// グループ内のデータ一覧。
  final List<PBXVariantGroupChild> children;

  /// Group Name.
  ///
  /// グループ名。
  final String name;

  /// Data from `sourceTree`.
  ///
  /// `sourceTree`のデータ。
  final String sourceTree;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXVariantGroup;\n\t\t\tchildren = (\n${children.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n\t\t\tname = $name;\n\t\t\tsourceTree = $sourceTree;\n\t\t};";
  }
}

/// Data for `children` in [PBXVariantGroup].
///
/// [PBXVariantGroup]の`children`のデータ。
class PBXVariantGroupChild {
  /// Data for `children` in [PBXVariantGroup].
  ///
  /// [PBXVariantGroup]の`children`のデータ。
  factory PBXVariantGroupChild({
    String? id,
    required String comment,
  }) {
    return PBXVariantGroupChild._(
      comment: comment,
      id: id ?? XCode.generateId(),
    );
  }
  PBXVariantGroupChild._({
    required this.id,
    required this.comment,
  });

  static List<PBXVariantGroupChild> parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXVariantGroupChild._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  @override
  String toString() {
    return "\t\t\t\t$id /* $comment */";
  }
}

/// BuildConfiguration data.
///
/// BuildConfigurationのデータ。
class PBXBuildConfiguration {
  /// BuildConfiguration data.
  ///
  /// BuildConfigurationのデータ。
  factory PBXBuildConfiguration({
    String? id,
    String? comment,
    required List<PBXBuildConfigurationSettings> buildSettings,
    required String name,
    required String baseConfigurationReference,
  }) {
    return PBXBuildConfiguration._(
      name: name,
      comment: comment,
      buildSettings: buildSettings,
      baseConfigurationReference: baseConfigurationReference,
      id: id ?? XCode.generateId(),
    );
  }
  PBXBuildConfiguration._({
    required this.id,
    this.comment,
    required this.name,
    required this.buildSettings,
    this.baseConfigurationReference,
  });

  static List<PBXBuildConfiguration> _load(String content) {
    final region = RegExp(
      r"/\* Begin XCBuildConfiguration section \*/([\s\S]+)/\* End XCBuildConfiguration section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = XCBuildConfiguration;[\s\t\n]+(baseConfigurationReference = (?<baseConfigurationReference>[^;]+);[\s\t\n]+)?buildSettings = \{(?<buildSettings>[^\}]+)\};[\s\t\n]+name = (?<name>[a-zA-Z_."-]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXBuildConfiguration._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        name: e.namedGroup("name") ?? "",
        baseConfigurationReference:
            e.namedGroup("baseConfigurationReference") ?? "",
        buildSettings: PBXBuildConfigurationSettings.parse(
          e.namedGroup("buildSettings") ?? "",
        ),
      );
    });
  }

  static String _save(String content, List<PBXBuildConfiguration> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin XCBuildConfiguration section \*/([\s\S]+)/\* End XCBuildConfiguration section \*/",
      ),
      "/* Begin XCBuildConfiguration section */\n$code\n/* End XCBuildConfiguration section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "XCBuildConfiguration";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// List of data in the group.
  ///
  /// 設定内のデータ一覧。
  final List<PBXBuildConfigurationSettings> buildSettings;

  /// Setting Name.
  ///
  /// 設定名。
  final String name;

  /// Data from `baseConfigurationReference`.
  ///
  /// `baseConfigurationReference`のデータ。
  final String? baseConfigurationReference;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = XCBuildConfiguration;\n\t\t\t${baseConfigurationReference.isNotEmpty ? "baseConfigurationReference = $baseConfigurationReference;\n\t\t\t" : ""}buildSettings = {\n${buildSettings.map((e) => e.toString()).join(";\n")};\n\t\t\t};\n\t\t\tname = $name;\n\t\t};";
  }
}

/// Data from `buildSettings` in [PBXBuildConfiguration].
///
/// [PBXBuildConfiguration]の`buildSettings`のデータ。
class PBXBuildConfigurationSettings {
  /// Data from `buildSettings` in [PBXBuildConfiguration].
  ///
  /// [PBXBuildConfiguration]の`buildSettings`のデータ。
  factory PBXBuildConfigurationSettings({
    required String key,
    required String value,
  }) {
    return PBXBuildConfigurationSettings._(
      key: key,
      value: value,
    );
  }
  PBXBuildConfigurationSettings._({
    required this.key,
    required this.value,
  });

  static List<PBXBuildConfigurationSettings> parse(String text) {
    return RegExp(
      r'(?<key>[a-z0-9A-Z\[\]=\*"_]+) = (?<value>[^;]+);',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXBuildConfigurationSettings._(
        key: e.namedGroup("key") ?? "",
        value: e.namedGroup("value") ?? "",
      );
    });
  }

  /// Key of the element.
  ///
  /// 要素のKey。
  final String key;

  /// Value of the element.
  ///
  /// 要素の値。
  final String value;

  @override
  String toString() {
    return "\t\t\t\t$key = $value";
  }
}

/// FrameworksBuildPhase data.
///
/// FrameworksBuildPhaseのデータ。
class PBXFrameworksBuildPhase {
  /// FrameworksBuildPhase data.
  ///
  /// FrameworksBuildPhaseのデータ。
  factory PBXFrameworksBuildPhase({
    String? id,
    String? comment,
    required String buildActionMask,
    required List<PBXFrameworksBuildPhaseFiles> files,
    int? runOnlyForDeploymentPostprocessing,
  }) {
    return PBXFrameworksBuildPhase._(
      files: files,
      comment: comment,
      buildActionMask: buildActionMask,
      runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing,
      id: id ?? XCode.generateId(),
    );
  }
  PBXFrameworksBuildPhase._({
    required this.id,
    this.comment,
    this.buildActionMask,
    this.runOnlyForDeploymentPostprocessing,
    required this.files,
  });

  static List<PBXFrameworksBuildPhase> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXFrameworksBuildPhase section \*/([\s\S]+)/\* End PBXFrameworksBuildPhase section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXFrameworksBuildPhase;[\s\t\n]+buildActionMask = (?<buildActionMask>[0-9]+);[\s\t\n]+files = \((?<files>[^\)]+)\);[\s\t\n]+runOnlyForDeploymentPostprocessing = (?<runOnlyForDeploymentPostprocessing>[0-9]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXFrameworksBuildPhase._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        buildActionMask: e.namedGroup("buildActionMask"),
        runOnlyForDeploymentPostprocessing: int.tryParse(
            e.namedGroup("runOnlyForDeploymentPostprocessing") ?? "0"),
        files: PBXFrameworksBuildPhaseFiles._parse(e.namedGroup("files") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXFrameworksBuildPhase> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXFrameworksBuildPhase section \*/([\s\S]+)/\* End PBXFrameworksBuildPhase section \*/",
      ),
      "/* Begin PBXFrameworksBuildPhase section */\n$code\n/* End PBXFrameworksBuildPhase section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXFrameworksBuildPhase";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// BuildActionMask data.
  ///
  /// BuildActionMaskデータ。
  final String? buildActionMask;

  /// Data for [PBXFrameworksBuildPhaseFiles].
  ///
  /// [PBXFrameworksBuildPhaseFiles]のデータ。
  final List<PBXFrameworksBuildPhaseFiles> files;

  /// Data from [runOnlyForDeploymentPostprocessing].
  ///
  /// [runOnlyForDeploymentPostprocessing]のデータ。
  final int? runOnlyForDeploymentPostprocessing;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = $buildActionMask;\n\t\t\tfiles = (\n${files.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = ${runOnlyForDeploymentPostprocessing ?? 0};\n\t\t};";
  }
}

/// Class for `files` of [PBXFrameworksBuildPhase].
///
/// [PBXFrameworksBuildPhase]の`files`用のクラス。
class PBXFrameworksBuildPhaseFiles {
  /// Class for `files` of [PBXFrameworksBuildPhase].
  ///
  /// [PBXFrameworksBuildPhase]の`files`用のクラス。
  factory PBXFrameworksBuildPhaseFiles({
    String? id,
    required String fileName,
    required String fileDir,
  }) {
    return PBXFrameworksBuildPhaseFiles._(
      fileName: fileName,
      dirName: fileDir,
      id: id ?? XCode.generateId(),
    );
  }
  PBXFrameworksBuildPhaseFiles._({
    required this.id,
    required this.fileName,
    required this.dirName,
  });

  static List<PBXFrameworksBuildPhaseFiles> _parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<file>[a-zA-Z_.-]+) in (?<dir>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXFrameworksBuildPhaseFiles._(
        id: e.namedGroup("id") ?? "",
        fileName: e.namedGroup("file") ?? "",
        dirName: e.namedGroup("dir") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// Framework file name.
  ///
  /// フレームワークファイル名。
  final String fileName;

  /// Framework folder name
  ///
  /// フレームワークのフォルダ名
  final String dirName;

  @override
  String toString() {
    return "\t\t\t\t$id /* $fileName in $dirName */";
  }
}

/// PBXProject data.
///
/// PBXProjectのデータ。
class PBXProject {
  /// PBXProject data.
  ///
  /// PBXProjectのデータ。
  factory PBXProject({
    required String code,
    String defaultLocale = "en",
    List<String> locales = const [],
  }) {
    return PBXProject._(
      code: code,
      defaultLocale: defaultLocale,
      locales: locales,
    );
  }
  PBXProject._({
    required this.code,
    this.defaultLocale = "en",
    this.locales = const [],
  });

  static PBXProject? _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXProject section \*/(?<code>[\s\S]+)/\* End PBXProject section \*/",
    ).firstMatch(content);
    if (region == null) {
      return null;
    }
    final code = region.namedGroup("code") ?? "";
    if (code.isEmpty) {
      return null;
    }
    final developmentRegion =
        RegExp(r'developmentRegion = (?<defaultRegion>[a-zA-Z]+);')
                .firstMatch(code)
                ?.namedGroup("defaultRegion") ??
            "";
    final regions = RegExp(r'knownRegions = \((?<regions>[^\)]+)\);')
            .firstMatch(code)
            ?.namedGroup("regions") ??
        "";
    final locales = regions
        .split(",")
        .mapAndRemoveEmpty((e) {
          return e.replaceAll("\"", "").replaceAll("'", "").trim();
        })
        .where((e) => e.isNotEmpty)
        .toList();
    return PBXProject(
      code: code,
      defaultLocale: developmentRegion,
      locales: [
        ...locales,
        if (!locales.contains("Base")) "Base",
      ].toList(),
    );
  }

  static String _save(String content, PBXProject? project) {
    if (project == null) {
      return content;
    }
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXProject section \*/(?<code>[\s\S]+)/\* End PBXProject section \*/",
      ),
      "/* Begin PBXProject section */${project.toString()}/* End PBXProject section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXProject";

  /// Default locale.
  ///
  /// デフォルトロケール。
  final String defaultLocale;

  /// List of locales.
  ///
  /// ロケールの一覧。
  final List<String> locales;

  /// Other Codes.
  ///
  /// その他のコード。
  final String code;

  @override
  String toString() {
    return code
        .replaceAll(RegExp(r'developmentRegion = (?<defaultRegion>[a-zA-Z]+);'),
            "developmentRegion = $defaultLocale;")
        .replaceAll(
            RegExp(r'knownRegions = \((?<regions>[^\)]+)\);'),
            "knownRegions = (\n${[
              ...locales,
              if (!locales.contains("Base")) "Base",
            ].where((e) => e.isNotEmpty).map((e) => '				$e').join(",\n")},\n			);");
  }

  /// Copy with new data.
  ///
  /// 新しいデータをコピーする。
  PBXProject copyWith({
    String? defaultLocale,
    List<String>? locales,
  }) {
    return PBXProject(
      code: code,
      defaultLocale: defaultLocale ?? this.defaultLocale,
      locales: locales ?? this.locales,
    );
  }
}
