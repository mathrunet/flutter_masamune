part of masamune_cli;

class CodemagicAndroidCliCommand extends CliCommand {
  const CodemagicAndroidCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したcodemagicの情報をAndroid用の元にビルドスクリプトを作成します。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final build = yaml["codemagic"] as YamlMap;
    final android = build["android"] as YamlMap;
    final track = android["publishing_track"] as String?;
    const alias = "mathrunet";
    final keyStoreString =
        base64Encode(File("android/app/appkey.keystore").readAsBytesSync());
    final password = File("android/app/appkey_password.key").readAsStringSync();
    if (keyStoreString.isEmpty || password.isEmpty || alias.isEmpty) {
      print(
        "Codemagic Android information is missing. Please run [masamune keystore]",
      );
      return;
    }
    var codemagic = File("codemagic.yaml").readAsStringSync();
    codemagic = codemagic.replaceAll(
      RegExp(r"(# )?CM_KEYSTORE: [a-zA-Z0-9_=+/-]+"),
      "CM_KEYSTORE: $keyStoreString",
    );
    codemagic = codemagic.replaceAll(
      RegExp(r"(# )?CM_KEYSTORE_PASSWORD: [a-zA-Z0-9_=+/-]+"),
      "CM_KEYSTORE_PASSWORD: $password",
    );
    codemagic = codemagic.replaceAll(
      RegExp(r"(# )?CM_KEY_ALIAS_USERNAME: [a-zA-Z0-9_=+/-]+"),
      "CM_KEY_ALIAS_USERNAME: $alias",
    );
    codemagic = codemagic.replaceAll(
      RegExp(r"(# )?CM_KEY_ALIAS_PASSWORD: [a-zA-Z0-9_=+/-]+"),
      "CM_KEY_ALIAS_PASSWORD: $password",
    );
    codemagic = codemagic.replaceAll(
      "# TODO_REPLACE_CODEMAGIC_ANDROID_SCRIPT",
      r"""
- |
        # set up key.properties
        echo $CM_KEYSTORE | base64 --decode > /tmp/keystore.keystore
        cat >> "$FCI_BUILD_DIR/android/key.properties" <<EOF
        storePassword=$CM_KEYSTORE_PASSWORD
        keyPassword=$CM_KEY_ALIAS_PASSWORD
        keyAlias=$CM_KEY_ALIAS_USERNAME
        storeFile=/tmp/keystore.keystore
        EOF
      - |
        # set up local properties
        echo "flutter.sdk=$HOME/programs/flutter" > "$FCI_BUILD_DIR/android/local.properties"
      - flutter packages pub get
      - flutter build appbundle --release  --build-number=$BUILD_NUMBER --dart-define=FLAVOR=prod
      - |
        # generate signed universal apk with user specified keys
        android-app-bundle build-universal-apk \
          --bundle "build/**/outputs/**/*.aab" \
          --ks /tmp/keystore.keystore \
          --ks-pass $CM_KEYSTORE_PASSWORD \
          --ks-key-alias $CM_KEY_ALIAS_USERNAME \
          --key-pass $CM_KEY_ALIAS_PASSWORD
              """,
    );
    codemagic = codemagic.replaceAll(
      "# TODO_REPLACE_CODEMAGIC_ANDROID_ARTIFACTS",
      """
- build/**/outputs/**/*.apk
      - build/**/outputs/**/*.aab
      - build/**/outputs/**/mapping.txt
          """,
    );
    final credentials = search(RegExp("pc-api-[a-zA-Z0-9-]+.json"));
    if (credentials != null && credentials.existsSync() && track.isNotEmpty) {
      final credentialsFile = File(credentials.path);
      if (credentialsFile.existsSync()) {
        final credentialsString = jsonEncode(
          jsonDecode(
            credentialsFile
                .readAsStringSync()
                .replaceAll("\r\n", "\n")
                .replaceAll("\r", "\n")
                .replaceAll("\n", ""),
          ),
        );
        codemagic = codemagic.replaceAll(
          "# TODO_REPLACE_CODEMAGIC_ANDROID_PUBLISHING",
          """
google_play:
        credentials: '$credentialsString'
        track: $track
          """,
        );
      }
    }
    File("codemagic.yaml").writeAsStringSync(codemagic);
  }
}
