part of masamune_cli;

class CodemagicIOSCliCommand extends CliCommand {
  const CodemagicIOSCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したcodemagicの情報をIOS用の元にビルドスクリプトを作成します。先に`csr`のコマンドを実行しておき、https://www.notion.so/mathru/AppStoreConnect-ID-f516ff1a767146f69acd6780fbcf20fe を元にIDの登録やProvisioning Profileを作成しておく必要があります。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final openssl = bin["openssl"] as String?;
    final build = yaml["codemagic"] as YamlMap;
    final ios = build["ios"] as YamlMap;
    final issuerId = ios["publishing_issuer_id"] as String?;
    if (issuerId.isEmpty) {
      print("Codemagic IOS information is missing.");
      return;
    }
    final apiKeyFileEntry = search(RegExp("AuthKey_([a-zA-Z0-9]+).p8"));
    if (apiKeyFileEntry == null || !apiKeyFileEntry.existsSync()) {
      print("Api key: ${apiKeyFileEntry?.path} is not found.");
      return;
    }
    final apiKeyFile = File(apiKeyFileEntry.path);
    final apiKey = base64Encode(apiKeyFile.readAsBytesSync());
    final match =
        RegExp("AuthKey_([a-zA-Z0-9]+).p8").firstMatch(apiKeyFileEntry.path);
    final apiKeyId = match?.group(1);
    if (apiKeyId.isEmpty) {
      print("Api key: $apiKeyId is not found. Do not rename the file.");
      return;
    }
    final passwordFile = File("ios/ios_certificate_password.key");
    if (!passwordFile.existsSync()) {
      final password = generateCode(16);
      passwordFile.writeAsStringSync(password);
    }
    final password = passwordFile.readAsStringSync();
    if (password.isEmpty) {
      print("Password is missing.");
      return;
    }
    final generateProcess = await Process.start(
      openssl!,
      [
        "x509",
        "-in",
        "ios/ios_distribution.cer",
        "-inform",
        "DER",
        "-out",
        "ios/ios_distribution.pem",
        "-outform",
        "PEM"
      ],
      runInShell: true,
    );
    await generateProcess.print();
    final exportProcess = await Process.start(
      openssl,
      [
        "pkcs12",
        "-export",
        "-in",
        "ios/ios_distribution.pem",
        "-out",
        "ios/ios_distribution.p12",
        "-inkey",
        "ios/ios_enterprise.key",
        "-password",
        "pass:$password",
      ],
      runInShell: true,
    );
    await exportProcess.print();
    final p12 = search(RegExp(r"ios_distribution.p12$"));
    final mobileProvision = search(RegExp(r"[a-zA-Z0-9_-]+.mobileprovision$"));
    if (p12 == null || mobileProvision == null) {
      print("ios_distribution.p12 or mobileprovision file could not be found.");
      return;
    }
    final p12String = base64Encode(File(p12.path).readAsBytesSync());
    final mobileProvisionString =
        base64Encode(File(mobileProvision.path).readAsBytesSync());
    if (p12String.isEmpty ||
        mobileProvisionString.isEmpty ||
        password.isEmpty) {
      print("ios_distribution.p12 or mobileprovision file could not be found.");
      return;
    }
    var codemagic = File("codemagic.yaml").readAsStringSync();
    codemagic = codemagic.replaceAll(
      RegExp(r"(# )?CM_CERTIFICATE: [a-zA-Z0-9_=+/-]+"),
      "CM_CERTIFICATE: $p12String",
    );
    codemagic = codemagic.replaceAll(
      RegExp("(# )?CM_PROVISIONING_PROFILE: [a-zA-Z0-9_+=/-]+"),
      "CM_PROVISIONING_PROFILE: $mobileProvisionString",
    );
    codemagic = codemagic.replaceAll(
      RegExp("(# )?CM_CERTIFICATE_PASSWORD: [a-zA-Z0-9_+=/-]+"),
      "CM_CERTIFICATE_PASSWORD: $password",
    );
    codemagic = codemagic.replaceAll(
      "# TODO_REPLACE_CODEMAGIC_IOS_SCRIPT",
      r"""
- find . -name "Podfile" -execdir pod install \;
      - keychain initialize
      - flutter packages pub upgrade
      - |      
        # set up provisioning profiles
        PROFILES_HOME="$HOME/Library/MobileDevice/Provisioning Profiles"
        mkdir -p "$PROFILES_HOME"
        PROFILE_PATH="$(mktemp "$PROFILES_HOME"/$(uuidgen).mobileprovision)"
        echo ${CM_PROVISIONING_PROFILE} | base64 --decode > "$PROFILE_PATH"
        echo "Saved provisioning profile $PROFILE_PATH"
      - |
        # set up signing certificate
        echo $CM_CERTIFICATE | base64 --decode > /tmp/certificate.p12
        keychain add-certificates --certificate /tmp/certificate.p12 --certificate-password $CM_CERTIFICATE_PASSWORD
      - cd . && flutter build ios --release --build-number=$BUILD_NUMBER --dart-define=FLAVOR=prod
        --no-codesign
      - xcode-project use-profiles
      - cd . && xcode-project build-ipa --workspace "ios/Runner.xcworkspace" --scheme
        "Production"
          """,
    );
    codemagic = codemagic.replaceAll(
      "# TODO_REPLACE_CODEMAGIC_IOS_ARTIFACTS",
      """
- build/ios/ipa/*.ipa
      - /tmp/xcodebuild_logs/*.log
          """,
    );
    codemagic = codemagic.replaceAll(
      "# TODO_REPLACE_CODEMAGIC_IOS_PUBLISHING",
      """
app_store_connect:
        api_key: $apiKey
        key_id: $apiKeyId
        issuer_id: $issuerId
          """,
    );
    File("codemagic.yaml").writeAsStringSync(codemagic);
  }
}
