part of katana_cli.code;

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
];

/// Create a new Flutter project.
///
/// 新しいFlutterプロジェクトを作成します。
class CodeCreateCliCommand extends CliCommand {
  /// Create a new Flutter project.
  ///
  /// 新しいFlutterプロジェクトを作成します。
  const CodeCreateCliCommand();

  @override
  String get description =>
      "Create a new Flutter project. 新しいFlutterプロジェクトを作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final packageName = context.args.get(2, "");
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
  }
}
