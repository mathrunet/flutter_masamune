part of masamune_cli;

class KeystoreCliCommand extends CliCommand {
  const KeystoreCliCommand();

  @override
  String get description => "Androidビルドを署名するためのKeystoreを生成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin", {});
    final keytool = bin.get("keytool", "keytool");
    final keystore = yaml.getAsMap("keystore");
    final alias = keystore.get("alias", "");
    final fingerPrintFile = File("android/app/fingerprint.txt");
    if (alias.isEmpty) {
      print("Alias is empty.");
      return;
    }
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
    final process = await Process.start(
      keytool,
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
        alias,
        "-validity",
        "10950",
        "-dname",
        "CN=mathru, O=mathru.net, S=Tokyo, C=Japan",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await process.print();
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_KEYSTORE_PASSWORD", password);
      text = text.replaceAll("TODO_REPLACE_KEYSTORE_ALIAS", alias);
      File(file.path).writeAsStringSync(text);
    });
    final processP12 = await Process.start(
      keytool,
      [
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
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processP12.print();
    final fingerPrint = await Process.start(
      keytool,
      [
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
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    final stdout = await fingerPrint.print();
    fingerPrintFile.writeAsStringSync(stdout);
  }
}
