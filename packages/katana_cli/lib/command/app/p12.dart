part of katana_cli.app;

/// Convert the cer file created by Certificate in AppleDeveloperProgram from `CertificateSigningRequest.certSigningRequest` to a p12 file.
///
/// `CertificateSigningRequest.certSigningRequest`からAppleDeveloperProgramのCertificateにて作成されたcerファイルをp12ファイルに変換します。
class AppP12CliCommand extends CliCommand {
  /// Convert the cer file created by Certificate in AppleDeveloperProgram from `CertificateSigningRequest.certSigningRequest` to a p12 file.
  ///
  /// `CertificateSigningRequest.certSigningRequest`からAppleDeveloperProgramのCertificateにて作成されたcerファイルをp12ファイルに変換します。
  const AppP12CliCommand();

  @override
  String get description =>
      "Convert the cer file created by Certificate in AppleDeveloperProgram from `CertificateSigningRequest.certSigningRequest` to a p12 file. First create a `CertificateSigningRequest.certSigningRequest` from `katana app csr`, then go to https://mathru.notion.site/AppStoreConnect-ID-f516ff1a767146 f69acd6780fbcf20fe to download the cer file. `CertificateSigningRequest.certSigningRequest`からAppleDeveloperProgramのCertificateにて作成されたcerファイルをp12ファイルに変換します。最初に`katana app csr`から`CertificateSigningRequest.certSigningRequest`を作成し、https://mathru.notion.site/AppStoreConnect-ID-f516ff1a767146f69acd6780fbcf20fe を参考にcerファイルをダウンロードしてください。";

  @override
  Future<void> exec(ExecContext context) async {
    final regExp = RegExp(r".cer$");
    final bin = context.yaml.getAsMap("bin");
    final openssl = bin.get("openssl", "openssl");
    label("Find cer file");
    final cer = await find(Directory("ios"), regExp);
    if (cer == null) {
      print(
        "Could not find the cer file in the IOS folder. First create a `CertificateSigningRequest.certSigningRequest` from `katana app csr` and download it from https://mathru.notion.site/AppStoreConnect-ID-f516ff1a767146 f69acd6780fbcf20fe to download the cer file to your IOS folder.",
      );
      return;
    }
    final key = File("ios/ios_enterprise.key");
    if (!key.existsSync()) {
      print(
        "Could not find `ios/ios_enterprise.key`. Please run `katana app csr` first.",
      );
      return;
    }
    final passwordFile = File("ios/ios_certificate_password.key");
    if (!passwordFile.existsSync()) {
      final password = generateCode(16);
      await passwordFile.writeAsString(password);
    }
    final password = await passwordFile.readAsString();
    if (password.isEmpty) {
      print("Password is missing in `ios/ios_certificate_password.key`.");
      return;
    }
    await command(
      "Converts a cer file to a pem file.",
      [
        openssl,
        "x509",
        "-in",
        cer.path,
        "-inform",
        "DER",
        "-out",
        cer.path.replaceAll(regExp, ".pem"),
        "-outform",
        "PEM"
      ],
    );
    await command(
      "Converts a pem file to a p12 file.",
      [
        openssl,
        "pkcs12",
        "-export",
        "-in",
        cer.path.replaceAll(regExp, ".pem"),
        "-out",
        cer.path.replaceAll(regExp, ".p12"),
        "-inkey",
        "ios/ios_enterprise.key",
        "-password",
        "pass:$password",
      ],
    );
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
