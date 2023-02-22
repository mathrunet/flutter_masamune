part of katana_cli.code;

/// Output the Dart code in a hardened Zip file.
///
/// DartのコードをZipに固めて出力します。
class CodeZipCliCommand extends CliCommand {
  /// Output the Dart code in a hardened Zip file.
  ///
  /// DartのコードをZipに固めて出力します。
  const CodeZipCliCommand();

  @override
  String get description =>
      "Output the Dart code in a hardened Zip file. DartのコードをZipに固めて出力します。";

  @override
  Future<void> exec(ExecContext context) async {
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
        r"\.zip$",
        r"\.exe$",
        r"\.bat$",
        r"\.github/",
        r"^test/",
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
        r"katana\.yaml",
        r"lefthook\.yaml",
        r"/node_modules/",
        r"functions/lib/",
        r"\.firebase/",
        r"gradle-wrapper\.jar$",
        r"/\.gradle$",
        r"/captures/",
        r"/gradlew",
        r"/gradlew\.bat",
        r"GeneratedPluginRegistrant\.java",
        r"pubspec_overrides\.yaml",
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

extension _ZipFileEncoderExtensions on ZipFileEncoder {
  void checkAndAddDirectory(
    String dirPath, [
    List<String> ignoredList = const [],
  ]) {
    final dir = Directory(dirPath);
    final list = dir.listSync(recursive: true);
    for (final tmp in list) {
      final path = tmp.path.replaceAll(r"\", "/").replaceAll(dirPath, "");
      if (path.contains(".git/") || path.contains("/node_modules/")) {
        continue;
      }
      label("Check: $path");
      if (ignoredList.any((element) => path.contains(RegExp(element)))) {
        continue;
      }
      final file = File(path);
      if (!file.existsSync()) {
        continue;
      }
      label("Contain: $path");
      addFile(file, path);
    }
  }
}
