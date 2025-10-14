part of "test.dart";

/// Check the test coverage.
///
/// テストのカバレッジを確認します。
class TestCoverageCliCommand extends CliCommand {
  /// Check the test coverage.
  ///
  /// テストのカバレッジを確認します。
  const TestCoverageCliCommand();

  @override
  String get description => "Check the test coverage. テストのカバレッジを確認します。";

  @override
  String? get example => "katana test coverage";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    await command(
      "Check the test coverage.",
      [
        flutter,
        "test",
        "--coverage",
      ],
      catchError: true,
    );
  }
}
