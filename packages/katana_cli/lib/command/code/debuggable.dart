part of "code.dart";

/// Make a Masamune application debuggable with the AI Debugger.
///
/// MasamuneアプリをAI Debuggerでデバッグ可能にします。
class CodeDebuggableCliCommand extends CliCommand {
  /// Make a Masamune application debuggable with the AI Debugger.
  ///
  /// MasamuneアプリをAI Debuggerでデバッグ可能にします。
  const CodeDebuggableCliCommand();

  @override
  String get description =>
      "Configure the Masamune AI Debugger. Masamune AI Debuggerを利用するための設定を行います。";

  @override
  String? get example => "katana code debuggable";

  @override
  Future<void> exec(ExecContext context) async {
    final synchronizer = DebuggableProjectSynchronizer(Directory.current);
    late final DebuggableProjectPlan plan;
    try {
      plan = await synchronizer.createPlan();
    } on Object catch (exception) {
      error(exception.toString());
      return;
    }

    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    label("Add the masamune_ai_debugger package if it is missing.");
    await addFlutterImport(
      const ["masamune_ai_debugger"],
      flutterCommand: flutter,
    );
    if (isError) {
      return;
    }

    label("Configure Masamune AI Debugger.");
    await synchronizer.apply(plan);
    // ignore: avoid_print
    print("Masamune AI Debugger configuration is complete.");
  }
}
