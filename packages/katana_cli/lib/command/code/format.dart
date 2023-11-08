part of "code.dart";

/// Dart file formatting.
///
/// Dartファイルのフォーマッティングを行います。
class CodeFormatCliCommand extends CliCommand {
  /// Dart file formatting.
  ///
  /// Dartファイルのフォーマッティングを行います。
  const CodeFormatCliCommand();

  @override
  String get description => "Dart file formatting. Dartファイルのフォーマッティングを行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final dart = bin.get("dart", "dart");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await command(
        "Format all packages.",
        [
          melos,
          "exec",
          "--",
          "$dart format .",
        ],
      );
    } else {
      await command(
        "Format the current project.",
        [
          dart,
          "format",
          ".",
        ],
      );
    }
  }
}
