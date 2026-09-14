// Dart imports:
import "dart:io";

// Package imports:
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/command/apply.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/android_manifest.dart";

Future<void> main() async {
  final temporaryRoot = await Directory.systemTemp
      .createTemp("katana_manifest_placeholder_test_");
  try {
    await _verifyQueries(temporaryRoot);
    await _verifyQueryMigration(temporaryRoot);
    await _verifyQueryAuthentication(temporaryRoot);
    await _verifyKotlinDsl(temporaryRoot);
    await _verifyGroovy(temporaryRoot);
    stdout.writeln("All AndroidManifest placeholder checks passed.");
  } finally {
    await temporaryRoot.delete(recursive: true);
  }
}

Future<void> _verifyKotlinDsl(Directory temporaryRoot) async {
  final project = Directory("${temporaryRoot.path}/kotlin");
  final manifest = File("${project.path}/AndroidManifest.xml");
  final gradle = File("${project.path}/build.gradle.kts");
  await project.create(recursive: true);
  await manifest.writeAsString(_manifest(["API_TOKEN", "SECOND_KEY"]));
  await gradle.writeAsString(_kotlinFixture);
  final synchronizer = AndroidManifestPlaceholderSynchronizer(
    manifestPath: manifest.path,
    kotlinGradlePath: gradle.path,
    groovyGradlePath: "${project.path}/missing.gradle",
  );

  await synchronizer.apply();
  final first = await gradle.readAsString();
  await synchronizer.apply();
  final second = await gradle.readAsString();

  _expectEqual(second, first, "Kotlin DSL is idempotent");
  _expectContains(second, '    "API_TOKEN",', "first key is generated");
  _expectContains(second, '    "SECOND_KEY",', "second key is generated");
  _expectNotContains(
    second,
    '"applicationName",',
    "Flutter applicationName is ignored",
  );
  _expectNotContains(
    second,
    "googleMapsAndroidApiKey",
    "legacy Google Maps variable is removed",
  );
  _expectCount(
    second,
    "import java.util.Base64",
    1,
    "Base64 import is generated once",
  );
  _expectContains(
    second,
    "String(Base64.getDecoder().decode(encoded))",
    "imported Base64 decoder is used",
  );
  _expectNotContains(
    second,
    "java.util.Base64.getDecoder()",
    "Gradle DSL-shadowed fully qualified Base64 is not used",
  );
  _expectContains(second, "compose = true", "unknown build feature is kept");
  _expectContains(
    second,
    "useSupportLibrary = true",
    "nested defaultConfig block is kept",
  );
  _expectCount(
    second,
    "KATANA DART DEFINE MANIFEST PLACEHOLDERS:START",
    1,
    "definitions block is generated once",
  );
  _expectCount(
    second,
    "manifestPlaceholders.putAll(katanaManifestPlaceholders)",
    1,
    "assignment is generated once",
  );
  _expectContains(
    second,
    "        // KATANA MANIFEST PLACEHOLDER ASSIGNMENT:END\n    }",
    "defaultConfig closing brace keeps its indentation",
  );

  await manifest.writeAsString(_manifest(["API_TOKEN"]));
  await synchronizer.apply();
  final keyRemoved = await gradle.readAsString();
  _expectContains(keyRemoved, '    "API_TOKEN",', "remaining key is kept");
  _expectNotContains(
    keyRemoved,
    '    "SECOND_KEY",',
    "removed Manifest key is removed from Gradle",
  );

  await manifest.writeAsString(_manifest(const []));
  await synchronizer.apply();
  final allRemoved = await gradle.readAsString();
  _expectNotContains(
    allRemoved,
    "KATANA DART DEFINE MANIFEST PLACEHOLDERS",
    "definitions are removed when no keys remain",
  );
  _expectNotContains(
    allRemoved,
    "katanaManifestPlaceholders",
    "assignment is removed when no keys remain",
  );
  _expectNotContains(
    allRemoved,
    "import java.util.Base64",
    "unused managed Base64 import is removed",
  );
  _expectContains(
    allRemoved,
    "compose = true",
    "unknown Gradle content remains after cleanup",
  );
}

Future<void> _verifyGroovy(Directory temporaryRoot) async {
  final project = Directory("${temporaryRoot.path}/groovy");
  final manifest = File("${project.path}/AndroidManifest.xml");
  final gradle = File("${project.path}/build.gradle");
  await project.create(recursive: true);
  await manifest.writeAsString(_manifest(["API_TOKEN", "SECOND_KEY"]));
  await gradle.writeAsString(_groovyFixture);
  final synchronizer = AndroidManifestPlaceholderSynchronizer(
    manifestPath: manifest.path,
    kotlinGradlePath: "${project.path}/missing.gradle.kts",
    groovyGradlePath: gradle.path,
  );

  await synchronizer.apply();
  final first = await gradle.readAsString();
  await synchronizer.apply();
  final second = await gradle.readAsString();

  _expectEqual(second, first, "Groovy is idempotent");
  _expectContains(second, "encoded.decodeBase64()", "Groovy decoder is used");
  _expectContains(second, '    "API_TOKEN",', "Groovy first key is generated");
  _expectContains(
    second,
    '    "SECOND_KEY",',
    "Groovy second key is generated",
  );
  _expectNotContains(
    second,
    '"applicationName",',
    "Groovy ignores Flutter applicationName",
  );
  _expectContains(
    second,
    "customSetting true",
    "unknown Groovy content is kept",
  );
}

String _manifest(List<String> placeholders) {
  final metadata = placeholders
      .map(
        (name) =>
            '        <meta-data android:name="example.$name" android:value="\${$name}" />',
      )
      .join("\n");
  return '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:name="\${applicationName}">
$metadata
    </application>
</manifest>
''';
}

const _kotlinFixture = r'''
import java.util.Base64

plugins {
    id("com.android.application")
}

val dartDefines = sequenceOf("dart-defines", "DART_DEFINES")
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
val googleMapsAndroidApiKey = requireNotNull(
    dartDefines["API_TOKEN"]?.takeIf { it.isNotBlank() },
) { "API_TOKEN is required via --dart-define-from-file=dart_defines/<flavor>.env" }
val userValue = "keep-me"

android {
    namespace = "com.example.app"

    buildFeatures {
        compose = true
    }

    defaultConfig {
        applicationId = "com.example.app"
        vectorDrawables {
            useSupportLibrary = true
        }
        manifestPlaceholders["API_TOKEN"] = googleMapsAndroidApiKey
    }
}
''';

const _groovyFixture = r"""
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.app'
    customSetting true

    defaultConfig {
        applicationId 'com.example.app'
    }
}
""";

void _expectEqual(String actual, String expected, String message) {
  if (actual != expected) {
    throw StateError("$message\nExpected:\n$expected\nActual:\n$actual");
  }
}

void _expectContains(String actual, String expected, String message) {
  if (!actual.contains(expected)) {
    throw StateError("$message: missing `$expected`");
  }
}

void _expectNotContains(String actual, String expected, String message) {
  if (actual.contains(expected)) {
    throw StateError("$message: unexpected `$expected`");
  }
}

void _expectCount(
  String actual,
  String expected,
  int count,
  String message,
) {
  final actualCount = expected.allMatches(actual).length;
  if (actualCount != count) {
    throw StateError("$message: expected $count, got $actualCount");
  }
}

Future<void> _verifyQueries(Directory temporaryRoot) async {
  final previous = Directory.current;
  final project = Directory("${temporaryRoot.path}/queries");
  final manifest =
      File("${project.path}/android/app/src/main/AndroidManifest.xml");
  await manifest.parent.create(recursive: true);
  await manifest.writeAsString(_manifest(const []));
  try {
    Directory.current = project;
    await AndroidManifestQueryType.openLinkHttps.enableQuery();
    await AndroidManifestQueryType.sendAny.enableQuery();
    final first = await manifest.readAsString();
    _expectContains(first, 'android:scheme="https"', "HTTPSのscheme属性が正しい");
    _expectContains(first, 'android:mimeType="*/*"', "SENDのMIME属性が正しい");
    _expectNotContains(first, "android:data=", "無効なdata属性を生成しない");
    await AndroidManifestQueryType.openLinkHttps.enableQuery();
    await AndroidManifestQueryType.sendAny.enableQuery();
    _expectEqual(await manifest.readAsString(), first, "queryの反復生成は冪等");
  } finally {
    Directory.current = previous;
  }
}

Future<void> _verifyQueryMigration(Directory temporaryRoot) async {
  final previous = Directory.current;
  final project = Directory("${temporaryRoot.path}/query-migration");
  final manifest =
      File("${project.path}/android/app/src/main/AndroidManifest.xml");
  await manifest.parent.create(recursive: true);
  await manifest.writeAsString(_queryFixture);
  final before = XmlDocument.parse(_queryFixture);
  final protected = before
      .findAllElements("intent")
      .where((intent) => intent.getAttribute("test-keep") != null)
      .map((intent) => intent.toXmlString())
      .toList();
  try {
    Directory.current = project;
    // 実際のapplyアクション列から最終query修復へ到達することを検証します。
    await const ApplyCliCommand().exec(ExecContext(yaml: {}, args: []));
    final first = await manifest.readAsString();
    final document = XmlDocument.parse(first);
    _expectCount(first, 'android:scheme="https"', 3, "既知HTTPS修復と条件別queryの維持");
    _expectContains(first, 'android:scheme="tel"', "電話queryの修復");
    _expectContains(first, 'android:scheme="mailto"', "メールqueryの修復");
    _expectContains(first, 'android:mimeType="*/*"', "任意データ送信queryの修復");
    _expectNotContains(first, 'android:data="mailto"', "メールqueryの旧属性を除去");
    _expectCount(first, "android.support.customtabs.action.CustomTabsService",
        1, "既存CustomTabsの等価な重複だけを統合");
    for (final marker in [
      "既存コメント",
      "重複側コメント",
      "ネストしたコメント",
      "com.example.keep",
      'android:host="example.com"',
      'android:pathPrefix="/login"',
      "com.example.CUSTOM",
    ]) {
      _expectContains(first, marker, "コメントとpackageを保持");
    }
    final after = document
        .findAllElements("intent")
        .where((intent) => intent.getAttribute("test-keep") != null)
        .map((intent) => intent.toXmlString())
        .toList();
    // pretty化の空白を除いて未知・複合queryの構造を比較します。
    String compact(String value) => value.replaceAll(RegExp(r">\s+<"), "><");
    _expectEqual(after.map(compact).join(), protected.map(compact).join(),
        "未知query、複合action、競合属性の条件を保護");
    await const ApplyCliCommand().exec(ExecContext(yaml: {}, args: []));
    _expectEqual(await manifest.readAsString(), first, "apply再実行の冪等性");
    // createで使う同じ入口でも、既存の条件等価queryを増やしません。
    await AndroidManifestQueryType.openLinkHttps.enableQuery();
    _expectEqual(await manifest.readAsString(), first, "create/applyの正規化が共通");
  } finally {
    Directory.current = previous;
  }
}

Future<void> _verifyQueryAuthentication(Directory temporaryRoot) async {
  final previous = Directory.current;
  final project = Directory("${temporaryRoot.path}/query-auth");
  final manifest =
      File("${project.path}/android/app/src/main/AndroidManifest.xml");
  await manifest.parent.create(recursive: true);
  const action = AndroidManifestQueryFinalizeCliAction();
  try {
    Directory.current = project;
    for (final provider in ["google", "apple", "facebook", "github", "none"]) {
      for (final enabled in [false, true]) {
        for (final projectId in ["", "firebase-project"]) {
          await manifest.writeAsString(_manifest(const []));
          final context = ExecContext(yaml: {
            "firebase": {
              "project_id": projectId,
              "authentication": {
                "enable": enabled,
                "providers": {
                  if (provider != "none") provider: {"enable": true},
                },
              },
            },
          }, args: []);
          if (!action.checkEnabled(context)) {
            throw StateError("Android Manifestがあればfinalize actionを有効化する");
          }
          await action.exec(context);
          final first = await manifest.readAsString();
          _expectCount(
              first,
              "android.support.customtabs.action.CustomTabsService",
              enabled && projectId.isNotEmpty ? 1 : 0,
              "認証構成 $provider / $enabled / $projectId");
          await action.exec(context);
          _expectEqual(await manifest.readAsString(), first, "各認証構成で冪等");
          if (enabled && projectId.isNotEmpty) {
            await action.exec(ExecContext(yaml: {}, args: []));
            _expectEqual(
                await manifest.readAsString(), first, "無効化しても既存queryを保持");
          }
        }
      }
    }
    await manifest.delete();
    if (action.checkEnabled(ExecContext(yaml: {}, args: []))) {
      throw StateError("Android以外のprojectでは処理しない");
    }
    await action.exec(ExecContext(yaml: {}, args: []));
    if (manifest.existsSync()) {
      throw StateError("Android以外のprojectにManifestを作成しない");
    }
  } finally {
    Directory.current = previous;
  }
}

const _queryFixture = '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <queries>
    <!-- 既存コメント -->
    <package android:name="com.example.keep" />
    <intent><action android:name="android.intent.action.VIEW" /><category android:name="android.intent.category.BROWSABLE" /><data android:data="https" /></intent>
    <intent><!-- 重複側コメント --><data android:scheme="https"><!-- ネストしたコメント --></data><category android:name="android.intent.category.BROWSABLE" /><action android:name="android.intent.action.VIEW" /></intent>
    <intent><action android:name="android.intent.action.VIEW" /><data android:scheme="https" android:host="example.com" android:pathPrefix="/login" /></intent>
    <intent><action android:name="android.intent.action.VIEW" /><category android:name="com.example.CUSTOM" /><data android:scheme="https" /></intent>
    <intent><action android:name="android.intent.action.DIAL" /><data android:data="tel" /></intent>
    <intent><action android:name="android.intent.action.SENDTO" /><data android:data="mailto" /></intent>
    <intent><action android:name="android.intent.action.SEND" /><data android:data="*/*" /></intent>
    <intent test-keep="unknown"><action android:name="com.example.ACTION" /><data android:data="custom" /></intent>
    <intent test-keep="compound"><action android:name="android.intent.action.VIEW" /><action android:name="com.example.ACTION" /><data android:data="https" /></intent>
    <intent test-keep="conflict"><action android:name="android.intent.action.VIEW" /><data android:data="https" android:scheme="custom" /></intent>
    <intent test-keep="unknown-scheme"><action android:name="android.intent.action.VIEW" /><data android:data="ftp" /></intent>
    <intent><action android:name="android.support.customtabs.action.CustomTabsService" /></intent>
  </queries>
  <queries>
    <intent><action android:name="android.support.customtabs.action.CustomTabsService" /></intent>
  </queries>
  <application android:label="keep-app" />
</manifest>
''';
