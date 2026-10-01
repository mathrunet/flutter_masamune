/// Firebase App Check の デバッグトークンをホスト側のログから抽出し、
/// プロジェクト直下の `.app_check_debug_tokens.json` に保存するためのユーティリティ群。
library;

// Dart imports:
import "dart:convert";
import "dart:io";

/// デバッグトークン（UUID）の正規表現。
final RegExp appCheckDebugTokenUuidRegExp = RegExp(
  r"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}",
);

/// Android logcat 側のデバッグトークン抽出用の正規表現。
final RegExp appCheckDebugTokenAndroidLogRegExp = RegExp(
  r"Enter this debug secret into the allow list in the Firebase Console for your project:\s*"
  r"([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})",
);

/// iOS シミュレータの `log show` 側のデバッグトークン抽出用の正規表現。
final RegExp appCheckDebugTokenIosLogRegExp = RegExp(
  r"App Check debug token:\s*'?"
  r"([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})",
);

/// 接続中デバイスの情報。
class AppCheckDebugTokenDevice {
  /// 接続中デバイスの情報。
  const AppCheckDebugTokenDevice({
    required this.id,
    required this.platform,
    required this.name,
  });

  /// ホスト側のデバイスID（例: `emulator-5554`、iOSシミュレータの UDID）。
  final String id;

  /// `android` または `ios_simulator`。
  final String platform;

  /// 表示名（デバイスモデル名など）。
  final String name;
}

/// 接続中の Android デバイス（実機・エミュレータ）一覧を取得する。
Future<List<AppCheckDebugTokenDevice>> listAndroidDevices({
  String adb = "adb",
}) async {
  try {
    final result = await Process.run(adb, const ["devices", "-l"]);
    if (result.exitCode != 0) {
      return const [];
    }
    final devices = <AppCheckDebugTokenDevice>[];
    for (final line in (result.stdout as String).split("\n")) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith("List of devices")) {
        continue;
      }
      final match = RegExp(r"^(\S+)\s+device\b(.*)$").firstMatch(trimmed);
      if (match == null) {
        continue;
      }
      final id = match.group(1)!;
      final rest = match.group(2) ?? "";
      final modelMatch = RegExp(r"model:(\S+)").firstMatch(rest);
      final name = modelMatch?.group(1)?.replaceAll("_", " ") ?? id;
      devices.add(
        AppCheckDebugTokenDevice(
          id: id,
          platform: "android",
          name: name,
        ),
      );
    }
    return devices;
  } on ProcessException {
    return const [];
  }
}

/// 起動中の iOS シミュレータ一覧を取得する。
Future<List<AppCheckDebugTokenDevice>> listBootedIosSimulators() async {
  try {
    final result = await Process.run(
      "xcrun",
      const ["simctl", "list", "devices", "booted", "--json"],
    );
    if (result.exitCode != 0) {
      return const [];
    }
    final json = jsonDecode(result.stdout as String);
    final devicesMap = (json as Map)["devices"] as Map? ?? const {};
    final devices = <AppCheckDebugTokenDevice>[];
    for (final entry in devicesMap.entries) {
      final list = entry.value as List? ?? const [];
      for (final item in list) {
        final map = item as Map;
        final state = map["state"]?.toString() ?? "";
        if (state != "Booted") {
          continue;
        }
        final udid = map["udid"]?.toString() ?? "";
        if (udid.isEmpty) {
          continue;
        }
        devices.add(
          AppCheckDebugTokenDevice(
            id: udid,
            platform: "ios_simulator",
            name: map["name"]?.toString() ?? udid,
          ),
        );
      }
    }
    return devices;
  } on ProcessException {
    return const [];
  } on FormatException {
    return const [];
  }
}

/// 指定した Android デバイスの logcat から最新のデバッグトークンを抽出する。
///
/// 見つからない場合は `null` を返す。
Future<String?> extractAndroidDebugToken(
  String deviceId, {
  String adb = "adb",
}) async {
  try {
    final result = await Process.run(
      adb,
      ["-s", deviceId, "logcat", "-d", "-s", "DebugAppCheckProvider"],
    );
    if (result.exitCode != 0) {
      return null;
    }
    final output = result.stdout as String;
    final matches = appCheckDebugTokenAndroidLogRegExp.allMatches(output);
    if (matches.isEmpty) {
      return null;
    }
    return matches.last.group(1);
  } on ProcessException {
    return null;
  }
}

/// 指定した iOS シミュレータの `log show` から最新のデバッグトークンを抽出する。
///
/// 見つからない場合は `null` を返す。
Future<String?> extractIosSimulatorDebugToken(
  String udid, {
  String last = "1h",
}) async {
  try {
    final result = await Process.run(
      "xcrun",
      [
        "simctl",
        "spawn",
        udid,
        "log",
        "show",
        "--last",
        last,
        "--info",
        "--debug",
        "--predicate",
        'eventMessage CONTAINS "App Check debug token"',
      ],
    );
    if (result.exitCode != 0) {
      return null;
    }
    final output = "${result.stdout as String}\n${result.stderr as String}";
    final matches = appCheckDebugTokenIosLogRegExp.allMatches(output);
    if (matches.isEmpty) {
      return null;
    }
    return matches.last.group(1);
  } on ProcessException {
    return null;
  }
}

/// iOS の App Check SDK がデバッグトークンを保存する UserDefaults のキー。
///
/// 新しい AppCheckCore のキーを先に、旧 FirebaseAppCheck のキーを後に並べる。
const List<String> appCheckDebugTokenIosDefaultsKeys = [
  "GACAppCheckDebugToken",
  "FIRAAppCheckDebugToken",
];

/// iOS の App Check SDK が Firebase 登録済みのトークンに付ける UserDefaults キーの接頭辞。
const String appCheckDebugTokenIosRegisteredKeyPrefix =
    "GACAppCheckDebugTokenRegistered___";

/// iOS シミュレータ上のアプリの UserDefaults から読み取ったデバッグトークン。
class IosSimulatorDebugTokenDefaults {
  /// iOS シミュレータ上のアプリの UserDefaults から読み取ったデバッグトークン。
  const IosSimulatorDebugTokenDefaults({
    required this.token,
    required this.registered,
  });

  /// デバッグトークン。
  final String token;

  /// SDK が Firebase 登録済みと記録しているかどうか。
  final bool registered;
}

/// `ios/Runner.xcodeproj/project.pbxproj` からアプリのバンドルIDを解決する。
///
/// テストターゲット（`.RunnerTests` など）を除外し、最も多く出現する値を返す。
/// 見つからない場合は `null` を返す。
String? resolveIosBundleId({
  String pbxprojPath = "ios/Runner.xcodeproj/project.pbxproj",
}) {
  final file = File(pbxprojPath);
  if (!file.existsSync()) {
    return null;
  }
  final counts = <String, int>{};
  final regExp = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*"?([^";]+)"?;');
  for (final match in regExp.allMatches(file.readAsStringSync())) {
    final id = match.group(1)!.trim();
    if (id.isEmpty || id.contains(r"$") || id.endsWith("Tests")) {
      continue;
    }
    counts[id] = (counts[id] ?? 0) + 1;
  }
  if (counts.isEmpty) {
    return null;
  }
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.first.key;
}

/// 指定した iOS シミュレータ上のアプリの UserDefaults からデバッグトークンを読み取る。
///
/// App Check の debug provider は初回利用時にトークンを生成して UserDefaults に保存するため、
/// ログにトークンが出力されていなくても取得できる。
/// アプリ未インストールやトークン未生成の場合は `null` を返す。
Future<IosSimulatorDebugTokenDefaults?> readIosSimulatorDebugTokenFromDefaults(
  String udid, {
  required String bundleId,
}) async {
  try {
    final container = await Process.run(
      "xcrun",
      ["simctl", "get_app_container", udid, bundleId, "data"],
    );
    if (container.exitCode != 0) {
      return null;
    }
    final containerPath = (container.stdout as String).trim();
    if (containerPath.isEmpty) {
      return null;
    }
    final plist = File(
      "$containerPath/Library/Preferences/$bundleId.plist",
    );
    if (!plist.existsSync()) {
      return null;
    }
    // `plutil -convert json` は Data / Date 型を含む plist で失敗するため、キー単位で読む。
    String? token;
    for (final key in appCheckDebugTokenIosDefaultsKeys) {
      final result = await Process.run(
        "plutil",
        ["-extract", key, "raw", "-o", "-", plist.path],
      );
      if (result.exitCode != 0) {
        continue;
      }
      final value = (result.stdout as String).trim();
      if (appCheckDebugTokenUuidRegExp.firstMatch(value)?.group(0) == value) {
        token = value;
        break;
      }
    }
    if (token == null) {
      return null;
    }
    final printed = await Process.run("plutil", ["-p", plist.path]);
    final registered = printed.exitCode == 0 &&
        RegExp(
          '"${RegExp.escape(appCheckDebugTokenIosRegisteredKeyPrefix)}[^"]*"\\s*=>\\s*(true|1)\\b',
        ).hasMatch(printed.stdout as String);
    return IosSimulatorDebugTokenDefaults(token: token, registered: registered);
  } on ProcessException {
    return null;
  } on FormatException {
    return null;
  }
}

/// `.app_check_debug_tokens.json` を管理するストア。
class AppCheckDebugTokenStore {
  /// 指定した [file] を保存先とするストアを生成する。
  AppCheckDebugTokenStore(this.file);

  /// 既定の保存先ファイル（`.app_check_debug_tokens.json`）を使うストアを生成する。
  factory AppCheckDebugTokenStore.defaultFile() =>
      AppCheckDebugTokenStore(File(".app_check_debug_tokens.json"));

  /// 保存先のファイル。
  final File file;

  static const int _version = 1;

  Map<String, dynamic> _load() {
    if (!file.existsSync()) {
      return <String, dynamic>{
        "version": _version,
        "devices": <String, dynamic>{},
      };
    }
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is Map<String, dynamic>) {
        final devices = decoded["devices"];
        return <String, dynamic>{
          "version": _version,
          "devices": devices is Map<String, dynamic>
              ? Map<String, dynamic>.from(devices)
              : <String, dynamic>{},
        };
      }
    } on FormatException {
      // 壊れたファイルは黙って空扱いにする（既存の壊れた値で上書きされないよう注意）。
    }
    return <String, dynamic>{
      "version": _version,
      "devices": <String, dynamic>{},
    };
  }

  /// 指定デバイスのトークンを上書き保存する（他のデバイスのエントリは保持）。
  void upsert({
    required AppCheckDebugTokenDevice device,
    required String token,
    required DateTime updatedAt,
  }) {
    final data = _load();
    final devices = data["devices"] as Map<String, dynamic>;
    devices[device.id] = <String, dynamic>{
      "platform": device.platform,
      "name": device.name,
      "token": token,
      "updatedAt": updatedAt.toUtc().toIso8601String(),
    };
    data["devices"] = devices;
    const encoder = JsonEncoder.withIndent("  ");
    file.writeAsStringSync("${encoder.convert(data)}\n");
  }
}
