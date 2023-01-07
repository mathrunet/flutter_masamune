part of katana_cli.app;

/// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
///
/// `CertificateSigningRequest.certSigningRequest`を自動出力します。
class AppCsrCliCommand extends CliCommand {
  /// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
  ///
  /// `CertificateSigningRequest.certSigningRequest`を自動出力します。
  const AppCsrCliCommand();

  @override
  String get description =>
      "Automatically outputs `CertificateSigningRequest.certSigningRequest` for authentication at AppStore. The key is stored in `ios/ios_enterprise.key` and the CertificateSigningRequest is output to `ios/CertificateSigningRequest.certSigningRequest`. You can add initial information in `katana.yaml` with the `init` option. AppStoreでの認証を行うための`CertificateSigningRequest.certSigningRequest`を自動出力します。`ios/ios_enterprise.key`にキーが保存され、`ios/CertificateSigningRequest.certSigningRequest`にCertificateSigningRequestが出力されます。initオプションで`katana.yaml`の初期情報を追加できます。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final openssl = bin.get("openssl", "openssl");
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      print("The item [app] is missing. Please add an item.");
      return;
    }
    final csr = app.getAsMap("csr");
    if (csr.isEmpty) {
      print("The item [app]->[csr] is missing. Please add an item.");
      return;
    }
    final email = csr.get("email", "");
    if (email.isEmpty) {
      print(
        "The item [app]->[csr]->[email] is missing. Please provide an email address to create a CertificateSigningRequest.",
      );
      return;
    }
    if (!File("ios/CertificateSigningRequest.certSigningRequest")
        .existsSync()) {
      label("Create a CertificateSigningRequest.certificateSigningRequest");
      final process = await Process.start(
        openssl,
        [
          "req",
          "-nodes",
          "-newkey",
          "rsa:2048",
          "-keyout",
          "ios/ios_enterprise.key",
          "-out",
          "ios/CertificateSigningRequest.certSigningRequest",
        ],
        runInShell: true,
        mode: ProcessStartMode.normal,
      );
      process.stdout.transform(utf8.decoder).forEach(print);
      process.stdin.write(".\n");
      process.stdin.write(".\n");
      process.stdin.write(".\n");
      process.stdin.write(".\n");
      process.stdin.write(".\n");
      process.stdin.write(".\n");
      process.stdin.write("$email\n");
      process.stdin.write("\n");
      process.stdin.write("\n");
      await process.exitCode;
    }
    label("Rewrite `.gitignore`.");
    final gitignore = File("ios/.gitignore");
    if (!gitignore.existsSync()) {
      print("Cannot find `ios/.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (!gitignores.any((e) => e.startsWith("**/*.p12"))) {
      gitignores.add("**/*.p12");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.p8"))) {
      gitignores.add("**/*.p8");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.mobileprovision"))) {
      gitignores.add("**/*.mobileprovision");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.pem"))) {
      gitignores.add("**/*.pem");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.cer"))) {
      gitignores.add("**/*.cer");
    }
    if (!gitignores.any((e) => e.startsWith("**/*.certSigningRequest"))) {
      gitignores.add("**/*.certSigningRequest");
    }
    if (!gitignores
        .any((e) => e.startsWith("**/ios_certificate_password.key"))) {
      gitignores.add("**/ios_certificate_password.key");
    }
    if (!gitignores.any((e) => e.startsWith("**/ios_enterprise.key"))) {
      gitignores.add("**/ios_enterprise.key");
    }
    await gitignore.writeAsString(gitignores.join("\n"));
  }
}
