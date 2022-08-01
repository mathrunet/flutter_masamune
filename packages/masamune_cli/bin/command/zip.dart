part of masamune_cli;

class ZipCliCommand extends CliCommand {
  const ZipCliCommand();

  @override
  String get description => "プロジェクト内を配布用のファイルのみ抽出しZIPで固めます。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final fileName = Directory.current.path.replaceAll(r"\", "/").last();
    final encoder = ZipFileEncoder();
    encoder.create("$fileName.zip");
    encoder.checkAndAddDirectory(
      "./",
      [
        r"\.class$",
        r"\.log$",
        r"\.pyc$",
        r"\.swp$",
        r"\.DS_Store",
        r"\.atom/",
        r"\.buildlog/",
        r"\.history$",
        r"\.svn/",
        r"\.iml$",
        r"\.ipr$",
        r"\.iws$",
        r"\.idea/",
        // r"\.apk$",
        r"\.aab$",
        r"\.exe$",
        r"\.bat$",
        r"^test/",
        r"codemagic\.",
        r"\.vscode/",
        r"doc/api/",
        r"ios/Flutter/\.last_build_id",
        r"\.dart_tool/",
        r"\.flutter-plugins",
        r"\.flutter-plugins-dependencies",
        r"\.packages$",
        r"\.pub-cache/",
        r"\.pub/",
        r"^build/",
        r"lib/generated_plugin_registrant\.dart",
        r"app\.[^.]+\.symbols",
        r"app\.[^.]+\.map.json",
        r"archived\.zip$",
        r"\.md$",
        r"masamune\.dart$",
        r"masamune\.yaml$",
        r"masamune\.yaml$",
        r"/node_modules/",
        r"functions/lib/",
        r"functions/home/",
        r"\.firebase/",
        r"gradle-wrapper\.jar$",
        r"/\.gradle$",
        r"/captures/",
        r"/gradlew",
        r"/gradlew\.bat",
        r"/local.properties",
        r"GeneratedPluginRegistrant\.java",
        r"\.keystore",
        r"\.p12",
        r"fingerprint\.",
        r".mode1v3$",
        r"\.mode2v3$",
        r"\.moved-aside$",
        r"\.pbxuser$",
        r"\.perspectivev3$",
        r"/.+sync/",
        r".sconsign.dblite",
        r".tags",
        r"/\.vagrant/",
        r"/DerivedData/",
        r"/Pods/",
        r"/\.symlinks/",
        r"profile",
        r"xcuserdata",
        r"/\.generated/",
        r"Flutter/App\.framework",
        r"Flutter/Flutter\.framework",
        r"Flutter/Flutter\.podspec",
        r"Flutter/Generated\.xcconfig",
        r"Flutter/app\.flx",
        r"Flutter/app\.zip",
        r"Flutter/flutter_assets/",
        r"Flutter/flutter_export_environment\.sh",
        r"ServiceDefinitions\.json",
        r"Runner/GeneratedPluginRegistrant\.",
      ],
    );
    encoder.close();
  }
}
