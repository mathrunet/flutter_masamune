part of katana_cli;

/// Contents of katana.yaml.
///
/// katana_secrets.yamlの中身。
class KatanaSecretsCliCode extends CliCode {
  /// Contents of katana.yaml.
  ///
  /// katana_secrets.yamlの中身。
  const KatanaSecretsCliCode();

  @override
  String get name => "katana_secrets";

  @override
  String get prefix => "katana_secrets";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create katana_secrets.yaml for katana_cli. katana_cli用のkatana_secrets.yamlを作成します。";

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
# Describe Github secret information.
# Githubのシークレット情報を記述します。
github:
  # Please describe the Github token.
  # Githubのトークンを記載してください。
  token:
""";
  }
}
