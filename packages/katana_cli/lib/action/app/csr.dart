// Dart imports:
import "dart:async";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
///
/// `CertificateSigningRequest.certSigningRequest`を自動出力します。
class AppCsrCliAction extends CliCommand with CliActionMixin {
  /// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
  ///
  /// `CertificateSigningRequest.certSigningRequest`を自動出力します。
  const AppCsrCliAction();

  @override
  String get description =>
      "Automatically outputs `CertificateSigningRequest.certSigningRequest` for authentication at AppStore. The key is stored in `ios/ios_enterprise.key` and the CertificateSigningRequest is output to `ios/CertificateSigningRequest.certSigningRequest`. AppStoreでの認証を行うための`CertificateSigningRequest.certSigningRequest`を自動出力します。`ios/ios_enterprise.key`にキーが保存され、`ios/CertificateSigningRequest.certSigningRequest`にCertificateSigningRequestが出力されます。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("csr");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final openssl = bin.get("openssl", "openssl");
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final csr = app.getAsMap("csr");
    if (csr.isEmpty) {
      error("The item [app]->[csr] is missing. Please add an item.");
      return;
    }
    final email = csr.get("email", "");
    if (email.isEmpty) {
      error(
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
      unawaited(
        process.stdout.forEach((e) => stdout.add(e)),
      );
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
      error("Cannot find `ios/.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
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
    } else {
      gitignores.removeWhere((e) => e.startsWith("**/*.p12"));
      gitignores.removeWhere((e) => e.startsWith("**/*.p8"));
      gitignores.removeWhere((e) => e.startsWith("**/*.mobileprovision"));
      gitignores.removeWhere((e) => e.startsWith("**/*.pem"));
      gitignores.removeWhere((e) => e.startsWith("**/*.cer"));
      gitignores.removeWhere((e) => e.startsWith("**/*.certSigningRequest"));
      gitignores
          .removeWhere((e) => e.startsWith("**/ios_certificate_password.key"));
      gitignores.removeWhere((e) => e.startsWith("**/ios_enterprise.key"));
    }
    await gitignore.writeAsString(gitignores.join("\n"));
  }
}
