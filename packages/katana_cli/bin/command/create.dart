part of katana_cli;

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
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    if (args.length < 2 || args[1].isEmpty) {
      print(
        "Please provide the name of the package.\r\nパッケージ名を記載してください。\r\n\r\nkatana create [package name]",
      );
      return;
    }
    final packageName = args[1];
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
    await Process.start(
      flutter,
      [
        "create",
        "--org",
        domain,
        "--project-name",
        projectName!,
        ".",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
    await Process.start(
      flutter,
      [
        "pub",
        "add",
        "freezed_annotation",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
    await Process.start(
      flutter,
      [
        "pub",
        "add",
        "json_annotation",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
    await Process.start(
      flutter,
      [
        "pub",
        "add",
        "--dev",
        "build_runner",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
    await Process.start(
      flutter,
      [
        "pub",
        "add",
        "--dev",
        "freezed",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
    await Process.start(
      flutter,
      [
        "pub",
        "add",
        "--dev",
        "json_serializable",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    ).print();
  }
}
