part of katana_cli.app;

/// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
///
/// `CertificateSigningRequest.certSigningRequest`を自動出力します。
class AppKeystoreCliCommand extends CliCommand {
  /// Automatically outputs `CertificateSigningRequest.certSigningRequest`.
  ///
  /// `CertificateSigningRequest.certSigningRequest`を自動出力します。
  const AppKeystoreCliCommand();

  @override
  String get description =>
      "Automatically outputs `CertificateSigningRequest.certSigningRequest` for authentication at AppStore. The key is stored in `ios/ios_enterprise.key` and the CertificateSigningRequest is output to `ios/CertificateSigningRequest.certSigningRequest`. AppStoreでの認証を行うための`CertificateSigningRequest.certSigningRequest`を自動出力します。`ios/ios_enterprise.key`にキーが保存され、`ios/CertificateSigningRequest.certSigningRequest`にCertificateSigningRequestが出力されます。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final keytool = bin.get("keytool", "keytool");
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      print("The item [app] is missing. Please add an item.");
      return;
    }
    final keystore = app.getAsMap("keystore");
    if (keystore.isEmpty) {
      print("The item [app]->[keystore] is missing. Please add an item.");
      return;
    }
    final alias = keystore.get("alias", "");
    if (alias.isEmpty) {
      print(
        "The item [app]->[keystore]->[alias] is missing. Please describe the alias of the keystore.",
      );
      return;
    }
    final name = keystore.get("name", "");
    if (name.isEmpty) {
      print(
        "The item [app]->[keystore]->[name] is missing. Describe the common name of the keytool.",
      );
      return;
    }
    final organization = keystore.get("organization", "");
    if (organization.isEmpty) {
      print(
        "The item [app]->[keystore]->[organization] is missing. Describe the organization of the keytool.",
      );
      return;
    }
    final state = keystore.get("state", "");
    if (state.isEmpty) {
      print(
        "The item [app]->[keystore]->[state] is missing. Describe the state of the keytool.",
      );
      return;
    }
    final country = keystore.get("country", "");
    if (country.isEmpty) {
      print(
        "The item [app]->[keystore]->[country] is missing. Describe the country of the keytool.",
      );
      return;
    }
    final passwordFile = File("android/app/appkey_password.key");
    if (!passwordFile.existsSync()) {
      final password = generateCode(16);
      passwordFile.writeAsStringSync(password);
    }
    final password = passwordFile.readAsStringSync();
    final appKey = File("android/app/appkey.keystore");
    if (!appKey.existsSync()) {
      await command(
        "Create appkey.keystore",
        [
          keytool,
          "-genkey",
          "-v",
          "-keystore",
          "android/app/appkey.keystore",
          "-keyalg",
          "RSA",
          "-storepass",
          password,
          "-alias",
          alias,
          "-validity",
          "10950",
          "-dname",
          "CN=$name, O=$organization, S=$state, C=$country",
        ],
      );
    }
    final p12 = File("android/app/appkey.p12");
    if (!p12.existsSync()) {
      await command(
        "Create appkey.p12",
        [
          keytool,
          "-v",
          "-importkeystore",
          "-srckeystore",
          "android/app/appkey.keystore",
          "-srcalias",
          alias,
          "-srcstorepass",
          password,
          "-srckeypass",
          password,
          "-destkeystore",
          "android/app/appkey.p12",
          "-deststoretype",
          "PKCS12",
          "-storepass",
          password,
        ],
      );
    }
    final properties = File("android/app.properties");
    if (properties.existsSync()) {
      final contents = await properties.readAsLines();
      if (!contents.any((e) => e.startsWith("storePassword"))) {
        contents.add("storePassword=$password");
      }
      if (!contents.any((e) => e.startsWith("keyPassword"))) {
        contents.add("keyPassword=$password");
      }
      if (!contents.any((e) => e.startsWith("keyAlias"))) {
        contents.add("keyAlias=$alias");
      }
      if (!contents.any((e) => e.startsWith("storeFile"))) {
        contents.add("storeFile=appkey.keystore");
      }
      await properties.writeAsString(contents.join("\n"));
    } else {
      await properties.writeAsString(
        "storePassword=$password\nkeyPassword=$password\nkeyAlias=$alias\nstoreFile=appkey.keystore",
      );
    }
    final fingerPrintFile = File("android/app/appkey_fingerprint.txt");
    if (!fingerPrintFile.existsSync()) {
      final fingerPrint = await command(
        "Create appkey_fingerprint.txt",
        [
          keytool,
          "-list",
          "-v",
          "-keystore",
          "android/app/appkey.keystore",
          "-alias",
          alias,
          "-storepass",
          password,
          "-keypass",
          password,
        ],
      );
      await fingerPrintFile.writeAsString(fingerPrint);
    }
  }
}
