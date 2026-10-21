part of "code.dart";

/// Expand `${NAME}` in `dart_defines/<flavor>.env` and write the result to `build/katana/dart_defines/<flavor>.env`.
///
/// `dart_defines/<flavor>.env`の`${NAME}`を展開し、`build/katana/dart_defines/<flavor>.env`に書き出します。
class CodeDartDefinesCliCommand extends CliCommand {
  /// Expand `${NAME}` in `dart_defines/<flavor>.env` and write the result to `build/katana/dart_defines/<flavor>.env`.
  ///
  /// `dart_defines/<flavor>.env`の`${NAME}`を展開し、`build/katana/dart_defines/<flavor>.env`に書き出します。
  const CodeDartDefinesCliCommand();

  @override
  String get description =>
      "Expand `\${NAME}` in `dart_defines/<flavor>.env` with environment variables and write it to `$kResolvedDartDefinesDirectory/<flavor>.env`. All flavors are processed when no flavor is given. Files without `\${` are copied as is. Used by the VSCode `preLaunchTask`. `dart_defines/<flavor>.env`の`\${NAME}`を環境変数で展開し`$kResolvedDartDefinesDirectory/<flavor>.env`に書き出します。フレーバーを省略すると全フレーバーを処理します。`\${`を含まないファイルはそのままコピーします。VSCodeの`preLaunchTask`で使用します。";

  @override
  String? get example => "katana code dart_defines [flavor]";

  @override
  Future<void> exec(ExecContext context) async {
    final flavors = context.args.skip(2).where((e) => !e.startsWith("-"));
    final paths = <String>[];
    if (flavors.isEmpty) {
      final directory = Directory("dart_defines");
      if (directory.existsSync()) {
        paths.addAll(
          directory
              .listSync()
              .whereType<File>()
              .map((e) => e.path)
              .where((e) => e.endsWith(".env"))
              .toList()
            ..sort(),
        );
      }
      if (paths.isEmpty) {
        error("Cannot find `dart_defines/*.env`.");
        return;
      }
    } else {
      for (final flavor in flavors) {
        if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(flavor)) {
          error("Invalid flavor: $flavor");
          return;
        }
        final path = "dart_defines/$flavor.env";
        if (!File(path).existsSync()) {
          error("Cannot find `$path`.");
          return;
        }
        paths.add(path);
      }
    }
    for (final path in paths) {
      try {
        final output = resolveDartDefinesFile(path, alwaysWrite: true);
        stdout.writeln("$path -> $output");
      } on KatanaEnvironmentVariableException catch (e) {
        error(e.toString());
        return;
      } on KatanaDartDefinesException catch (e) {
        error(e.toString());
        return;
      }
    }
  }
}
