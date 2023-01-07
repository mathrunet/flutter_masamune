part of katana_cli;

/// Contents of lefthook.yaml.
///
/// lefthook.yamlの中身。
class LefthookCliCode extends CliCode {
  /// Contents of lefthook.yaml.
  ///
  /// lefthook.yamlの中身。
  const LefthookCliCode();

  @override
  String get name => "lefthook";

  @override
  String get prefix => "lefthook";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create lefthook.yaml for itHook. GitHook用ののlefthook.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
pre-commit:
  parallel: false
  commands:
    linter:
      run: dart fix --apply lib && git add {staged_files}
    import_sorter:
      glob: "*.dart"
      run: flutter pub run import_sorter:main {staged_files} && git add {staged_files}
    formatter:
      glob: "*.dart"
      run: dart format {staged_files} && git add {staged_files}
    analyzer:
      run: flutter analyze
""";
  }
}
