// Dart imports:
import "dart:io";

/// A prepared, validated set of AI Debugger file changes.
class DebuggableProjectPlan {
  /// Creates a prepared set of changes.
  const DebuggableProjectPlan({
    required this.adapterFile,
    required this.adapterContent,
    required this.projectId,
  });

  /// The adapter file to update.
  final File adapterFile;

  /// The fully updated adapter file content.
  final String adapterContent;

  /// The SamuraiAI project identifier derived from the physical project path.
  final String projectId;
}

/// Validates and configures a standard Masamune project for AI debugging.
class DebuggableProjectSynchronizer {
  /// Creates a synchronizer rooted at [projectDirectory].
  const DebuggableProjectSynchronizer(this.projectDirectory);

  /// Default SamuraiAI endpoint added to missing flavor settings.
  static const defaultEndpoint =
      "https://mathrumacmini.tail5dcd55.ts.net/__samurai";

  /// Project root to configure.
  final Directory projectDirectory;

  /// Validates the project and prepares all source changes without writing.
  Future<DebuggableProjectPlan> createPlan() async {
    final root = _physicalProjectDirectory();
    final pubspecFile = File("${root.path}/pubspec.yaml");
    final adapterFile = File("${root.path}/lib/adapter.dart");
    final mainFile = File("${root.path}/lib/main.dart");
    if (!pubspecFile.existsSync()) {
      throw StateError(
          "Cannot find pubspec.yaml. Run this command at the project root.");
    }
    if (!adapterFile.existsSync() || !mainFile.existsSync()) {
      throw StateError(
        "Cannot find the standard Masamune lib/adapter.dart and lib/main.dart files.",
      );
    }

    final mainContent = await mainFile.readAsString();
    _validateMain(mainContent);
    final adapterContent = await adapterFile.readAsString();
    final updatedAdapter = _updateAdapter(adapterContent);
    return DebuggableProjectPlan(
      adapterFile: adapterFile,
      adapterContent: updatedAdapter,
      projectId: _projectId(root),
    );
  }

  /// Applies a previously validated [plan].
  Future<void> apply(DebuggableProjectPlan plan) async {
    if (await plan.adapterFile.readAsString() != plan.adapterContent) {
      await plan.adapterFile.writeAsString(plan.adapterContent);
    }
    final dartDefinesDirectory =
        Directory("${_physicalProjectDirectory().path}/dart_defines");
    if (!dartDefinesDirectory.existsSync()) {
      await dartDefinesDirectory.create(recursive: true);
    }
    for (final flavor in const ["dev", "test", "stg", "prod"]) {
      await _ensureEnvironment(
        File("${dartDefinesDirectory.path}/$flavor.env"),
        plan.projectId,
      );
    }
  }

  Directory _physicalProjectDirectory() {
    if (!projectDirectory.existsSync()) {
      throw StateError("The project directory does not exist.");
    }
    return Directory(projectDirectory.resolveSymbolicLinksSync());
  }

  String _projectId(Directory root) =>
      root.path.replaceFirst(RegExp(r"^/+"), "").replaceAll("/", "-");

  void _validateMain(String content) {
    final hasRunMasamuneApp = content.contains("runMasamuneApp(");
    final passesAdapters = RegExp(
      r"masamuneAdapters\s*:\s*masamuneAdapters\s*,",
    ).hasMatch(content);
    final hasMasamuneApp = content.contains("MasamuneApp(");
    final propagatesAdapters = RegExp(
      r"masamuneAdapters\s*:\s*ref\.adapters\s*,",
    ).hasMatch(content);
    if (!hasRunMasamuneApp ||
        !passesAdapters ||
        !hasMasamuneApp ||
        !propagatesAdapters) {
      throw StateError(
        "lib/main.dart does not use the standard Masamune adapter propagation structure.",
      );
    }
  }

  String _updateAdapter(String original) {
    var content = original;
    const importLine =
        'import "package:masamune_ai_debugger/masamune_ai_debugger.dart";';
    if (!content.contains(importLine)) {
      final imports = RegExp(r"^import\s+[^;]+;\s*$", multiLine: true)
          .allMatches(content)
          .toList();
      if (imports.isEmpty) {
        throw StateError("lib/adapter.dart does not contain an import block.");
      }
      final lastImport = imports.last;
      content = content.replaceRange(
        lastImport.end,
        lastImport.end,
        "\n$importLine",
      );
    }

    final adapterMatches = RegExp(
      r"^final\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*AIDebuggerMasamuneAdapter\s*\([\s\S]*?\)\s*;",
      multiLine: true,
    ).allMatches(content).toList();
    if (adapterMatches.length > 1) {
      throw StateError(
          "Multiple AIDebuggerMasamuneAdapter instances were found.");
    }
    if (adapterMatches.isEmpty &&
        RegExp(r"\bAIDebuggerMasamuneAdapter\s*\(").hasMatch(content)) {
      throw StateError(
        "The existing AIDebuggerMasamuneAdapter must be a top-level final variable.",
      );
    }
    var adapterVariable = "aiDebuggerMasamuneAdapter";
    final masamuneDeclaration = RegExp(
      r"^final\s+(?:List<MasamuneAdapter>\s+)?masamuneAdapters\s*=",
      multiLine: true,
    ).firstMatch(content);
    if (masamuneDeclaration == null) {
      throw StateError("Cannot find the primary masamuneAdapters declaration.");
    }
    if (adapterMatches.isEmpty) {
      const declaration =
          "final aiDebuggerMasamuneAdapter = AIDebuggerMasamuneAdapter();\n\n";
      content = content.replaceRange(
        masamuneDeclaration.start,
        masamuneDeclaration.start,
        declaration,
      );
    } else {
      adapterVariable = adapterMatches.single.group(1)!;
    }

    final aliasPattern = RegExp(
      r"^final\s+(?:List<MasamuneAdapter>\s+)?masamuneAdapters\s*=\s*runtimeMasamuneAdapters\s*;",
      multiLine: true,
    );
    final aliasMatch = aliasPattern.firstMatch(content);
    if (aliasMatch != null) {
      content = content.replaceRange(
        aliasMatch.start,
        aliasMatch.end,
        "final masamuneAdapters = <MasamuneAdapter>[\n"
        "  ...runtimeMasamuneAdapters,\n"
        "  $adapterVariable,\n"
        "];",
      );
      return content;
    }

    final listPattern = RegExp(
      r"^final\s+(?:masamuneAdapters\s*=\s*<MasamuneAdapter>|List<MasamuneAdapter>\s+masamuneAdapters\s*=)\s*\[([\s\S]*?)(^\]\s*;)",
      multiLine: true,
    );
    final listMatch = listPattern.firstMatch(content);
    if (listMatch == null) {
      throw StateError(
        "The primary masamuneAdapters declaration is not a supported list.",
      );
    }
    final listBody = listMatch.group(1)!;
    if (RegExp("\\b${RegExp.escape(adapterVariable)}\\b").hasMatch(listBody)) {
      return content;
    }
    final prefix =
        listBody.trim().isEmpty || listBody.endsWith("\n") ? "" : "\n";
    final insertionOffset = listMatch.end - listMatch.group(2)!.length;
    content = content.replaceRange(
      insertionOffset,
      insertionOffset,
      "$prefix  $adapterVariable,\n",
    );
    return content;
  }

  Future<void> _ensureEnvironment(File file, String projectId) async {
    final original = file.existsSync() ? await file.readAsString() : "";
    var content = original;
    content = _appendMissingEnvironmentValue(
      content,
      "MASAMUNE_AI_DEBUGGER_PROJECT_ID",
      projectId,
    );
    content = _appendMissingEnvironmentValue(
      content,
      "MASAMUNE_AI_DEBUGGER_ENDPOINT",
      defaultEndpoint,
    );
    content = _appendMissingEnvironmentValue(
      content,
      "MASAMUNE_AI_DEBUGGER_API_KEY",
      "",
    );
    if (content != original) {
      await file.writeAsString(content);
    }
  }

  String _appendMissingEnvironmentValue(
    String content,
    String key,
    String value,
  ) {
    if (RegExp("^${RegExp.escape(key)}=", multiLine: true).hasMatch(content)) {
      return content;
    }
    final separator = content.isEmpty || content.endsWith("\n") ? "" : "\n";
    return "$content$separator$key=$value\n";
  }
}
