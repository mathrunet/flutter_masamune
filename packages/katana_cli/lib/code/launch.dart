part of katana_cli;

/// Contents of launch.json.
///
/// launch.jsonの中身。
class LaunchCliCode extends CliCode {
  /// Contents of launch.json.
  ///
  /// launch.jsonの中身。
  const LaunchCliCode();

  @override
  String get name => "launch";

  @override
  String get prefix => "launch";

  @override
  String get directory => ".vscode";

  @override
  String get description =>
      "Create launch.json for VSCode. VSCode用のlaunch.jsonを作成します。";

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
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=dev", "--web-renderer", "html", "--web-port=5555"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=stg", "--web-renderer", "html", "--web-port=5555"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=prod", "--web-renderer", "html", "--web-port=5555", "--release"]
    }
  ]
}
""";
  }
}
