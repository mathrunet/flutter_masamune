part of masamune_cli;

class KeystoreCliCommand extends CliCommand {
  const KeystoreCliCommand();

  @override
  String get description => "Androidビルドを署名するためのKeystoreを生成します。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final keytool = bin["keytool"] as String?;
    final fingerPrintFile = File("android/app/fingerprint.txt");
    if (fingerPrintFile.existsSync()) {
      print("Keystore is already exists.");
      return;
    }
    final passwordFile = File("android/app/appkey_password.key");
    if (!passwordFile.existsSync()) {
      final password = generateCode(16);
      passwordFile.writeAsStringSync(password);
    }
    final password = passwordFile.readAsStringSync();
    final process = await Process.run(
      keytool!,
      [
        "-genkey",
        "-v",
        "-keystore",
        "android/app/appkey.keystore",
        "-keyalg",
        "RSA",
        "-storepass",
        password,
        "-alias",
        "mathrunet",
        "-validity",
        "10950",
        "-dname",
        "CN=mathru, O=mathru.net, S=Tokyo, C=Japan",
      ],
      workingDirectory: Directory.current.path,
    );
    print(process.stdout);
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_KEYSTORE_PASSWORD", password);
      File(file.path).writeAsStringSync(text);
    });
    final processP12 = await Process.run(
      keytool,
      [
        "-v",
        "-importkeystore",
        "-srckeystore",
        "android/app/appkey.keystore",
        "-srcalias",
        "mathrunet",
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
      workingDirectory: Directory.current.path,
    );
    print(processP12.stdout);
    final fingerPrint = await Process.run(
      keytool,
      [
        "-list",
        "-v",
        "-keystore",
        "android/app/appkey.keystore",
        "-alias",
        "mathrunet",
        "-storepass",
        password,
        "-keypass",
        password,
      ],
      workingDirectory: Directory.current.path,
    );
    print(fingerPrint.stdout);
    fingerPrintFile.writeAsStringSync(fingerPrint.stdout);
  }
}
