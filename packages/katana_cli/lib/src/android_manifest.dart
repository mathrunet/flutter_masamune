// Dart imports:
import "dart:io";

// Package imports:
import "package:katana/katana.dart";
import "package:xml/xml.dart";

/// Synchronizes environment-style AndroidManifest placeholders with Flutter
/// Dart defines in the application Gradle file.
///
/// 環境変数形式のAndroidManifestプレースホルダーを、アプリケーションのGradle内で
/// FlutterのDart defineと同期します。
class AndroidManifestPlaceholderSynchronizer {
  /// Synchronizes environment-style AndroidManifest placeholders with Flutter
  /// Dart defines in the application Gradle file.
  ///
  /// 環境変数形式のAndroidManifestプレースホルダーを、アプリケーションのGradle内で
  /// FlutterのDart defineと同期します。
  const AndroidManifestPlaceholderSynchronizer({
    this.manifestPath = "android/app/src/main/AndroidManifest.xml",
    this.kotlinGradlePath = "android/app/build.gradle.kts",
    this.groovyGradlePath = "android/app/build.gradle",
  });

  /// Path to AndroidManifest.xml.
  ///
  /// AndroidManifest.xmlへのパス。
  final String manifestPath;

  /// Path to the Kotlin DSL application Gradle file.
  ///
  /// Kotlin DSLのアプリケーションGradleファイルへのパス。
  final String kotlinGradlePath;

  /// Path to the Groovy application Gradle file.
  ///
  /// GroovyのアプリケーションGradleファイルへのパス。
  final String groovyGradlePath;

  static const _definitionsStart =
      "// KATANA DART DEFINE MANIFEST PLACEHOLDERS:START";
  static const _definitionsEnd =
      "// KATANA DART DEFINE MANIFEST PLACEHOLDERS:END";
  static const _assignmentStart =
      "// KATANA MANIFEST PLACEHOLDER ASSIGNMENT:START";
  static const _assignmentEnd = "// KATANA MANIFEST PLACEHOLDER ASSIGNMENT:END";

  /// Returns whether both the Manifest and an application Gradle file exist.
  ///
  /// ManifestとアプリケーションGradleファイルの両方が存在するか返します。
  bool get hasFiles => File(manifestPath).existsSync() && _gradleFile != null;

  /// Applies the synchronized placeholder settings.
  ///
  /// 同期したプレースホルダー設定を反映します。
  Future<void> apply() async {
    final manifestFile = File(manifestPath);
    final gradleFile = _gradleFile;
    if (!manifestFile.existsSync() || gradleFile == null) {
      return;
    }
    final document = XmlDocument.parse(await manifestFile.readAsString());
    final placeholders = document.descendants
        .whereType<XmlElement>()
        .expand((element) => element.attributes)
        .map((attribute) => _placeholderName(attribute.value))
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    var gradle = await gradleFile.readAsString();
    final isKotlin = gradleFile.path.endsWith(".kts");
    gradle = _removeLegacyGoogleMapsCode(gradle);
    gradle = _replaceManagedBlock(
      gradle,
      _definitionsStart,
      _definitionsEnd,
      placeholders.isEmpty
          ? null
          : (isKotlin
              ? _kotlinDefinitions(placeholders)
              : _groovyDefinitions(placeholders)),
    );
    gradle = _replaceDefaultConfigBlock(
      gradle,
      placeholders.isEmpty
          ? null
          : "manifestPlaceholders.putAll(katanaManifestPlaceholders)",
    );
    if (isKotlin) {
      gradle = _synchronizeKotlinBase64Import(
        gradle,
        required: placeholders.isNotEmpty,
      );
    }
    await gradleFile.writeAsString(gradle);
  }

  File? get _gradleFile {
    final kotlin = File(kotlinGradlePath);
    if (kotlin.existsSync()) {
      return kotlin;
    }
    final groovy = File(groovyGradlePath);
    return groovy.existsSync() ? groovy : null;
  }

  static String? _placeholderName(String value) {
    return RegExp(r"^\$\{([A-Z][A-Z0-9_]*)\}$").firstMatch(value)?.group(1);
  }

  static String _replaceManagedBlock(
    String source,
    String start,
    String end,
    String? body,
  ) {
    final pattern = RegExp(
      "^[ \\t]*${RegExp.escape(start)}[\\s\\S]*?^[ \\t]*${RegExp.escape(end)}[ \\t]*(?:\\n[ \\t]*)*",
      multiLine: true,
    );
    final replacement = body == null ? "" : "$start\n$body\n$end\n\n";
    if (pattern.hasMatch(source)) {
      return source.replaceFirst(pattern, replacement);
    }
    if (body == null) {
      return source;
    }
    final android =
        RegExp(r"^android\s*\{", multiLine: true).firstMatch(source);
    if (android == null) {
      return source;
    }
    return source.replaceRange(android.start, android.start, replacement);
  }

  static String _replaceDefaultConfigBlock(String source, String? assignment) {
    final defaultConfig = _findGradleBlock(source, "defaultConfig");
    if (defaultConfig == null) {
      return source;
    }
    final indent = "${defaultConfig.indent}    ";
    final managedBlock = RegExp(
      "^[ \\t]*${RegExp.escape(_assignmentStart)}[\\s\\S]*?^[ \\t]*${RegExp.escape(_assignmentEnd)}[ \\t]*\\n?",
      multiLine: true,
    );
    var body = source.substring(
      defaultConfig.openBrace + 1,
      defaultConfig.closeBrace,
    );
    final block = assignment == null
        ? ""
        : "$indent$_assignmentStart\n$indent$assignment\n$indent$_assignmentEnd\n";
    if (managedBlock.hasMatch(body)) {
      body = body.replaceFirst(managedBlock, block);
    } else if (assignment != null) {
      body = body.endsWith("\n") ? "$body$block" : "$body\n$block";
    }
    body = body.replaceFirst(
      RegExp(r"[ \t]*$"),
      defaultConfig.indent,
    );
    return source.replaceRange(
      defaultConfig.openBrace + 1,
      defaultConfig.closeBrace,
      body,
    );
  }

  static _GradleBlock? _findGradleBlock(String source, String name) {
    final declaration = RegExp(
      "^([ \\t]*)${RegExp.escape(name)}\\s*\\{",
      multiLine: true,
    ).firstMatch(source);
    if (declaration == null) {
      return null;
    }
    final openBrace = source.indexOf("{", declaration.start);
    var depth = 0;
    String? quote;
    var escaped = false;
    var lineComment = false;
    var blockComment = false;
    for (var index = openBrace; index < source.length; index++) {
      final character = source[index];
      final next = index + 1 < source.length ? source[index + 1] : "";
      if (lineComment) {
        if (character == "\n") {
          lineComment = false;
        }
        continue;
      }
      if (blockComment) {
        if (character == "*" && next == "/") {
          blockComment = false;
          index++;
        }
        continue;
      }
      if (quote != null) {
        if (escaped) {
          escaped = false;
        } else if (character == "\\") {
          escaped = true;
        } else if (character == quote) {
          quote = null;
        }
        continue;
      }
      if (character == "/" && next == "/") {
        lineComment = true;
        index++;
      } else if (character == "/" && next == "*") {
        blockComment = true;
        index++;
      } else if (character == '"' || character == "'") {
        quote = character;
      } else if (character == "{") {
        depth++;
      } else if (character == "}") {
        depth--;
        if (depth == 0) {
          return _GradleBlock(
            openBrace: openBrace,
            closeBrace: index,
            indent: declaration.group(1) ?? "",
          );
        }
      }
    }
    return null;
  }

  static String _kotlinDefinitions(List<String> placeholders) {
    final names = placeholders.map((name) => '    "$name",').join("\n");
    return '''
val katanaDartDefines = sequenceOf("dart-defines", "DART_DEFINES")
    .mapNotNull { project.findProperty(it)?.toString() }
    .firstOrNull()
    .orEmpty()
    .split(',')
    .filter { it.isNotBlank() }
    .associate { encoded ->
        val decoded = String(Base64.getDecoder().decode(encoded))
        val separator = decoded.indexOf('=')
        require(separator > 0) { "Invalid dart-define entry." }
        decoded.substring(0, separator) to decoded.substring(separator + 1)
    }
val katanaManifestPlaceholderNames = setOf(
$names
)
val katanaManifestPlaceholders = katanaManifestPlaceholderNames.associateWith { name ->
    requireNotNull(katanaDartDefines[name]?.takeIf { it.isNotBlank() }) {
        "\$name is required via --dart-define-from-file=dart_defines/<flavor>.env"
    }
}''';
  }

  static String _synchronizeKotlinBase64Import(
    String source, {
    required bool required,
  }) {
    final import = RegExp(
      r"^import java\.util\.Base64[ \t]*(?:\r?\n)?",
      multiLine: true,
    );
    if (required) {
      if (import.hasMatch(source)) {
        return source;
      }
      return "import java.util.Base64\n\n$source";
    }
    final withoutImport = source.replaceFirst(import, "");
    if (withoutImport.contains("Base64.")) {
      return source;
    }
    return withoutImport;
  }

  static String _groovyDefinitions(List<String> placeholders) {
    final names = placeholders.map((name) => '    "$name",').join("\n");
    return '''
def katanaDartDefines = ["dart-defines", "DART_DEFINES"]
    .collect { project.findProperty(it)?.toString() }
    .find { it != null } ?: ""
def katanaDecodedDartDefines = katanaDartDefines
    .split(',')
    .findAll { !it.isEmpty() }
    .collectEntries { encoded ->
        def decoded = new String(encoded.decodeBase64())
        def separator = decoded.indexOf('=')
        if (separator <= 0) {
            throw new GradleException("Invalid dart-define entry.")
        }
        [(decoded.substring(0, separator)): decoded.substring(separator + 1)]
    }
def katanaManifestPlaceholderNames = [
$names
] as Set
def katanaManifestPlaceholders = katanaManifestPlaceholderNames.collectEntries { name ->
    def value = katanaDecodedDartDefines[name]
    if (!value) {
        throw new GradleException("\$name is required via --dart-define-from-file=dart_defines/<flavor>.env")
    }
    [(name): value]
}''';
  }

  static String _removeLegacyGoogleMapsCode(String source) {
    final legacyDefinitions = RegExp(
      r'^val dartDefines = sequenceOf\("dart-defines", "DART_DEFINES"\)[\s\S]*?^val googleMapsAndroidApiKey = requireNotNull\([\s\S]*?^\) \{ "[A-Z][A-Z0-9_]* is required via --dart-define-from-file=dart_defines/<flavor>\.env" \}\s*',
      multiLine: true,
    );
    final hadLegacyDefinitions = legacyDefinitions.hasMatch(source);
    var result = source.replaceFirst(legacyDefinitions, "");
    result = result.replaceAll(
      RegExp(
        r'^[ \t]*manifestPlaceholders\["[A-Z][A-Z0-9_]*"\][ \t]*=[ \t]*googleMapsAndroidApiKey[ \t]*\n?',
        multiLine: true,
      ),
      "",
    );
    if (hadLegacyDefinitions && !result.contains("Base64.")) {
      result = result.replaceFirst(
        RegExp(r"^import java\.util\.Base64[ \t]*\n?", multiLine: true),
        "",
      );
    }
    return result;
  }
}

class _GradleBlock {
  const _GradleBlock({
    required this.openBrace,
    required this.closeBrace,
    required this.indent,
  });

  final int openBrace;
  final int closeBrace;
  final String indent;
}

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
  billing("com.android.vending.BILLING"),

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

  /// Fully qualified permission name written to AndroidManifest.xml.
  ///
  /// AndroidManifest.xmlへ書き込む完全修飾パーミッション名。
  String get permissionName => id.contains(".") ? id : "android.permission.$id";

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
            p1.value == permissionName))) {
      switch (this) {
        case AndroidManifestPermissionType.readPrivilegedPhoneState:
          manifest.first.children.add(
            XmlElement(
              XmlName("uses-permission"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  permissionName,
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
                  permissionName,
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

/// AndroidManifestの既知のqueryを修復し、必要なqueryを追加します。
class AndroidManifestQuerySynchronizer {
  /// 対象Manifestを指定します。
  const AndroidManifestQuerySynchronizer({
    this.manifestPath = "android/app/src/main/AndroidManifest.xml",
  });

  /// AndroidManifest.xmlへのパス。
  final String manifestPath;

  /// Android以外のプロジェクトでは処理を省略します。
  bool get hasFile => File(manifestPath).existsSync();

  /// 既存queryの条件を保持して修復します。指定したqueryだけ新規追加します。
  Future<void> apply({
    Iterable<AndroidManifestQueryType> enable = const [],
  }) async {
    final file = File(manifestPath);
    if (!file.existsSync()) {
      return;
    }
    final original = await file.readAsString();
    final document = XmlDocument.parse(original);
    final manifest = document.rootElement;
    if (manifest.name.toString() != "manifest") {
      throw const FormatException("AndroidManifest.xmlにmanifest要素がありません。");
    }
    final queries = manifest.findElements("queries").toList();
    final known = <String, XmlElement>{};
    var changed = false;
    for (final query in queries) {
      for (final intent in query.findElements("intent").toList()) {
        final type = _knownType(intent);
        if (type == null) {
          continue;
        }
        final value = type.scheme ?? type.mimeType;
        if (value != null) {
          final attribute =
              type.scheme == null ? "android:mimeType" : "android:scheme";
          for (final data in intent.findElements("data")) {
            // CLIが生成した既知の誤属性だけを変換します。競合した条件は保持します。
            if (data.getAttribute("android:data") == value &&
                (data.getAttribute(attribute) == null ||
                    data.getAttribute(attribute) == value)) {
              data.setAttribute(attribute, value);
              data.removeAttribute("android:data");
              changed = true;
            }
          }
        }
        final signature = _signature(intent);
        final previous = known[signature];
        if (previous == null) {
          known[signature] = intent;
        } else {
          // 重複したintent内のコメントも失わないよう、残すintentへ移します。
          previous.children.addAll(
            intent.descendants
                .whereType<XmlComment>()
                .map((node) => node.copy())
                .toList(),
          );
          intent.parent!.children.remove(intent);
          changed = true;
        }
      }
    }
    for (final type in enable) {
      final intent = _intent(type);
      final signature = _signature(intent);
      if (known.containsKey(signature)) {
        continue;
      }
      if (queries.isEmpty) {
        final query = XmlElement(XmlName("queries"));
        manifest.children.add(query);
        queries.add(query);
      }
      queries.first.children.add(intent);
      known[signature] = intent;
      changed = true;
    }
    if (changed) {
      await file.writeAsString(
        document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
      );
    }
  }

  static AndroidManifestQueryType? _knownType(XmlElement intent) {
    final actions = intent.findElements("action").toList();
    // 複数actionはユーザー定義の複合queryとして扱います。
    if (actions.length != 1) {
      return null;
    }
    final id = actions.single.getAttribute("android:name");
    return AndroidManifestQueryType.values.firstWhereOrNull((type) {
      if (type.id != id) {
        return false;
      }
      final value = type.scheme ?? type.mimeType;
      if (value == null) {
        return intent.findElements("data").isEmpty;
      }
      final attribute =
          type.scheme == null ? "android:mimeType" : "android:scheme";
      return intent.findElements("data").any((data) =>
          data.getAttribute(attribute) == value ||
          data.getAttribute("android:data") == value);
    });
  }

  static XmlElement _intent(AndroidManifestQueryType type) {
    XmlElement element(String name, String key, String value) => XmlElement(
          XmlName(name),
          [XmlAttribute(XmlName(key), value)],
        );
    return XmlElement(XmlName("intent"), [], [
      element("action", "android:name", type.id),
      if (type.category != null)
        element("category", "android:name", type.category!),
      if (type.scheme != null) element("data", "android:scheme", type.scheme!),
      if (type.mimeType != null)
        element("data", "android:mimeType", type.mimeType!),
    ]);
  }

  // 属性・子要素の順序、空白、コメントを除き、すべての条件を比較します。
  static String _signature(XmlElement element) {
    final attributes = element.attributes
        .map((attribute) => attribute.toXmlString())
        .toList()
      ..sort();
    final children = element.children
        .where((node) =>
            node is! XmlComment &&
            !(node is XmlText && node.value.trim().isEmpty))
        .map((node) =>
            node is XmlElement ? _signature(node) : node.toXmlString())
        .toList()
      ..sort();
    return "<${element.name} ${attributes.join(' ')}>${children.join()}</${element.name}>";
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
  sendAny("android.intent.action.SEND", mimeType: "*/*"),

  /// ブラウザ認証でCustom Tabs対応サービスを検出できるようにします。
  customTabs("android.support.customtabs.action.CustomTabsService");

  /// Query type for AndroidManifest.
  ///
  /// AndroidManifest用のクエリータイプ。
  const AndroidManifestQueryType(
    this.id, {
    this.scheme,
    this.mimeType,
    this.category,
  });

  /// ID of the query.
  ///
  /// クエリーのID。
  final String id;

  /// Scheme Name.
  ///
  /// スキーム名。
  final String? scheme;

  /// 送信データのMIMEタイプ。
  final String? mimeType;

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
    await const AndroidManifestQuerySynchronizer().apply(enable: [this]);
  }
}
