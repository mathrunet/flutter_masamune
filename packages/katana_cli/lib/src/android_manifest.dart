// Dart imports:
import "dart:io";

// Package imports:
import "package:katana/katana.dart";
import "package:xml/xml.dart";

/// Permission type for AndroidManifest.
///
/// AndroidManifest用のパーミッションタイプ。
enum AndroidManifestPermissionType {
  /// Permissions to location information.
  ///
  /// 位置情報へのパーミッション。
  accessFineLocation("ACCESS_FINE_LOCATION"),

  /// Permissions to location information in the background.
  ///
  /// バックグラウンドでの位置情報へのパーミッション。
  accessBackgroundLocation("ACCESS_BACKGROUND_LOCATION"),

  /// Permissions for monitoring phone status.
  ///
  /// 電話状態の監視用のパーミッション。
  readPhoneState("READ_PHONE_STATE"),

  /// Internet permissions.
  ///
  /// インターネットのパーミッション。
  internet("INTERNET"),

  /// Recording permissions.
  ///
  /// 録音のパーミッション。
  recordAudio("RECORD_AUDIO"),

  /// Camera permissions.
  ///
  /// カメラのパーミッション。
  camera("CAMERA"),

  /// Permissions for audio settings.
  ///
  /// オーディオ設定のパーミッション。
  modifyAudioSettings("MODIFY_AUDIO_SETTINGS"),

  /// Permissions to access network state.
  ///
  /// ネットワークの状態へのアクセスのパーミッション。
  accessNetworkState("ACCESS_NETWORK_STATE"),

  /// BLUETOOTH permissions.
  ///
  /// BLUETOOTHのパーミッション。
  bluetooth("BLUETOOTH"),

  /// BLUETOOTH permissions.
  ///
  /// BLUETOOTHのパーミッション。
  bluetoothAdmin("BLUETOOTH_ADMIN"),

  /// BLUETOOTH permissions.
  ///
  /// BLUETOOTHのパーミッション。
  bluetoothConnect("BLUETOOTH_CONNECT"),

  /// Permissions for access to Wifi status.
  ///
  /// Wifiの状態へのアクセスのパーミッション。
  accessWifiState("ACCESS_WIFI_STATE"),

  /// Permissions to read to external storage.
  ///
  /// 外部ストレージへの読み込みのパーミッション。
  readExternalStorage("READ_EXTERNAL_STORAGE"),

  /// Permission to screen always on.
  ///
  /// 画面常時点灯へのパーミッション。
  wakeLock("WAKE_LOCK"),

  /// Permissions when using SIM information.
  ///
  /// SIM情報利用時のパーミッション。
  readPrivilegedPhoneState("READ_PRIVILEGED_PHONE_STATE"),

  /// Permissions for billing.
  ///
  /// 課金用のパーミッション。
  billing("BILLING"),

  /// Permissions for alarm scheduling.
  ///
  /// アラームスケジュール用のパーミッション。
  scheduleExactAlarm("SCHEDULE_EXACT_ALARM", maxSdkVersion: "32"),

  /// Permissions for alarm scheduling.
  ///
  /// アラームスケジュール用のパーミッション。
  useExactAlarm("USE_EXACT_ALARM");

  /// Permission type for AndroidManifest.
  ///
  /// AndroidManifest用のパーミッションタイプ。
  const AndroidManifestPermissionType(this.id, {this.maxSdkVersion});

  /// Permission ID.
  ///
  /// パーミッションのID。
  final String id;

  /// Maximum SDK version to be applied.
  ///
  /// 適用する最大のSDKバージョン。
  final String? maxSdkVersion;

  /// Grant the `uses-permission` tag in AndroidManifest.
  ///
  /// AndroidManifestの`uses-permission`タグを付与します。
  Future<void> enablePermission() async {
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
            p1.value == "android.permission.$id"))) {
      switch (this) {
        case AndroidManifestPermissionType.readPrivilegedPhoneState:
          manifest.first.children.add(
            XmlElement(
              XmlName("uses-permission"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.permission.$id",
                ),
                XmlAttribute(
                  XmlName("tools:ignore"),
                  "ProtectedPermissions",
                ),
                if (maxSdkVersion.isNotEmpty)
                  XmlAttribute(
                    XmlName("android:maxSdkVersion"),
                    maxSdkVersion!,
                  ),
              ],
              [],
            ),
          );
          break;
        default:
          manifest.first.children.add(
            XmlElement(
              XmlName("uses-permission"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.permission.$id",
                ),
                if (maxSdkVersion.isNotEmpty)
                  XmlAttribute(
                    XmlName("android:maxSdkVersion"),
                    maxSdkVersion!,
                  ),
              ],
              [],
            ),
          );
          break;
      }
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
  }
}

/// Query type for AndroidManifest.
///
/// AndroidManifest用のクエリータイプ。
enum AndroidManifestQueryType {
  /// Allows you to open external Web sites.
  ///
  /// 外部のWebサイトを開けるようにします。
  openLinkHttps(
    "android.intent.action.VIEW",
    scheme: "https",
    category: "android.intent.category.BROWSABLE",
  ),

  /// Ensure that the phone is open.
  ///
  /// 電話を開けるようにします。
  dialTel("android.intent.action.DIAL", scheme: "tel"),

  /// Allows you to open your mail.
  ///
  /// メールを開けるようにします。
  sendEmail("android.intent.action.SENDTO", scheme: "mailto"),

  /// Make SpeechToText available.
  ///
  /// SpeechToTextを利用できるようにします。
  speechToText("android.speech.RecognitionService"),

  /// Make TextToSpeech available.
  ///
  /// TextToSpeechを利用できるようにします。
  textToSpeech("android.intent.action.TTS_SERVICE"),

  /// Enables other data to be sent.
  ///
  /// その他データを送れるようにします。
  sendAny("android.intent.action.SEND", scheme: "*/*");

  /// Query type for AndroidManifest.
  ///
  /// AndroidManifest用のクエリータイプ。
  const AndroidManifestQueryType(this.id, {this.scheme, this.category});

  /// ID of the query.
  ///
  /// クエリーのID。
  final String id;

  /// Scheme Name.
  ///
  /// スキーム名。
  final String? scheme;

  /// Category Name.
  ///
  /// カテゴリー名。
  final String? category;

  /// Tag the `queries` in AndroidManifest.
  ///
  /// AndroidManifestの`queries`にタグを付与します。
  Future<void> enableQuery() async {
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
    final queries = manifest.first.children.firstWhereOrNull(
            (p0) => p0 is XmlElement && p0.name.toString() == "queries") ??
        () {
          final q = XmlElement(XmlName("queries"), [], []);
          manifest.first.children.insertFirst(q);
          return q;
        }();
    if (scheme.isEmpty) {
      if (!queries.children.any((p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "intent" &&
          p0.children.any((p1) =>
              p1 is XmlElement &&
              p1.name.toString() == "action" &&
              p1.attributes.any((p2) =>
                  p2.name.toString() == "android:name" && p2.value == id)))) {
        queries.children.add(
          XmlElement(
            XmlName("intent"),
            [],
            [
              XmlElement(
                XmlName("action"),
                [
                  XmlAttribute(
                    XmlName("android:name"),
                    id,
                  ),
                ],
                [],
              ),
            ],
          ),
        );
      }
    } else {
      if (!queries.children.any((p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "intent" &&
          p0.children.any((p1) =>
              p1 is XmlElement &&
              p1.name.toString() == "action" &&
              p1.attributes.any((p2) =>
                  p2.name.toString() == "android:name" && p2.value == id)) &&
          p0.children.any((p1) =>
              p1 is XmlElement &&
              p1.name.toString() == "data" &&
              p1.attributes.any((p2) =>
                  p2.name.toString() == "android:data" &&
                  p2.value == scheme)))) {
        queries.children.add(
          XmlElement(
            XmlName("intent"),
            [],
            [
              XmlElement(
                XmlName("action"),
                [
                  XmlAttribute(
                    XmlName("android:name"),
                    id,
                  ),
                ],
                [],
              ),
              if (category != null)
                XmlElement(
                  XmlName("category"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      category!,
                    ),
                  ],
                  [],
                ),
              XmlElement(
                XmlName("data"),
                [
                  XmlAttribute(
                    XmlName("android:data"),
                    scheme!,
                  ),
                ],
                [],
              ),
            ],
          ),
        );
      }
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
  }
}
