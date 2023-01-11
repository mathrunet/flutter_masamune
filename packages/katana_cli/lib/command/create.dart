import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

/// Package to import.
///
/// インポートするパッケージ。
final importPackages = [
  "masamune",
  "freezed_annotation",
  "json_annotation",
];

/// Package for dev to import.
///
/// インポートするdev用パッケージ。
final importDevPackages = [
  "build_runner",
  "masamune_builder",
  "freezed",
  "json_serializable",
];

/// List of code snippets to be generated.
///
/// 生成するコードスニペットのリスト。
const codeSnippets = [
  PageCliCode(),
  CollectionModelCliCode(),
  DocumentModelCliCode(),
  ControllerCliCode(),
  ControllerGroupCliCode(),
  ValueCliCode(),
  RedirectQueryCliCode(),
];

/// Other generated files.
///
/// その他の生成ファイル。
const otherFiles = {
  "launch.json": LaunchCliCode(),
};

/// Create a new Flutter project.
///
/// 新しいFlutterプロジェクトを作成します。
class CreateCliCommand extends CliCommand {
  /// Create a new Flutter project.
  ///
  /// 新しいFlutterプロジェクトを作成します。
  const CreateCliCommand();

  @override
  String get description =>
      "Create a new Flutter project. 新しいFlutterプロジェクトを作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final packageName = context.args.get(1, "");
    if (packageName.isEmpty) {
      print(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana create [package name]",
      );
      return;
    }
    final projectName = packageName.split(".").lastOrNull;
    final domain = packageName
        .split(".")
        .sublist(0, packageName.split(".").length - 1)
        .join(".");
    if (projectName.isEmpty || domain.isEmpty) {
      print(
        "The format of the package name should be specified in the following format.\r\nパッケージ名の形式は下記の形式で指定してください。\r\n\r\n[Domain].[ProjectName]\r\ne.g. net.mathru.website",
      );
      return;
    }
    await command(
      "Create a Flutter project.",
      [
        flutter,
        "create",
        "--org",
        domain,
        "--project-name",
        projectName!,
        ".",
      ],
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        ...importPackages,
      ],
    );
    await command(
      "Import dev packages.",
      [
        flutter,
        "pub",
        "add",
        "--dev",
        ...importDevPackages,
      ],
    );
    label("Replace lib/main.dart");
    await const MainCliCode().generateDartCode("lib/main");
    label("Generate code-snippets for VSCode");
    for (final code in codeSnippets) {
      await code.generateCodeSnippet(".vscode");
    }
    for (final file in otherFiles.entries) {
      await file.value.generateFile(file.key);
    }
    label("Create a katana.yaml");
    await const KatanaCliCode().generateFile("katana.yaml");
    label("Create a katana_secrets.yaml");
    await const KatanaSecretsCliCode().generateFile("katana_secrets.yaml");
    label("Create a pubspec_overrides.yaml");
    await const PubspecOverridesCliCode()
        .generateFile("pubspec_overrides.yaml");
    label("Edit a analysis_options.yaml");
    await const AnalysisOptionsCliCode().generateFile("analysis_options.yaml");
    label("Edit a widget_test.dart");
    await const WidgetTestCliCode().generateFile("widget_test.dart");
    label("Create a assets directory");
    final assetsDirectory = Directory("assets");
    if (!assetsDirectory.existsSync()) {
      await assetsDirectory.create();
    }
    label("Replace pubspec.yaml");
    final pubspecFile = File("pubspec.yaml");
    final pubspec = await pubspecFile.readAsString();
    await pubspecFile.writeAsString(
      pubspec.replaceAll(
        RegExp(
          r"# assets:[\s\S]+#   - images/a_dot_burr.jpeg[\s\S]+#   - images/a_dot_ham.jpeg",
        ),
        "assets:\n    - assets/\n",
      ),
    );
    label("Rewrite `.gitignore`.");
    final gitignore = File(".gitignore");
    if (!gitignore.existsSync()) {
      print("Cannot find `.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (!gitignores.any((e) => e.startsWith("pubspec_overrides.yaml"))) {
      gitignores.add("pubspec_overrides.yaml");
    }
    if (!gitignores.any((e) => e.startsWith("katana_secrets.yaml"))) {
      gitignores.add("katana_secrets.yaml");
    }
    await gitignore.writeAsString(gitignores.join("\n"));
    await command(
      "Run the project's build_runner to generate code.",
      [
        flutter,
        "packages",
        "pub",
        "run",
        "build_runner",
        "build",
        "--delete-conflicting-outputs",
      ],
    );
    await command(
      "Run `pod install`.",
      [
        "pod",
        "install",
      ],
      workingDirectory: "ios",
    );
  }
}
