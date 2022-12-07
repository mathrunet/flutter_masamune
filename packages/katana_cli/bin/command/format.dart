part of katana_cli;

/// Dart file formatting.
///
/// Dartファイルのフォーマッティングを行います。
class FormatCliCommand extends CliCommand {
  /// Dart file formatting.
  ///
  /// Dartファイルのフォーマッティングを行います。
  const FormatCliCommand();

  @override
  String get description => "Dart file formatting. Dartファイルのフォーマッティングを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final dart = bin.get("dart", "dart");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await Process.start(
        melos,
        [
          "exec",
          "--",
          "$dart format .",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    } else {
      await Process.start(
        dart,
        [
          "format",
          ".",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    }
  }
}
