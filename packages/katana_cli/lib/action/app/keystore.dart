// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Generate a keystore for Android and use it only for release builds.
///
/// Android用のkeystoreを生成しリリースビルド時のみ利用するようにします。
class AppKeystoreCliAction extends CliCommand with CliActionMixin {
  /// Generate a keystore for Android and use it only for release builds.
  ///
  /// Android用のkeystoreを生成しリリースビルド時のみ利用するようにします。
  const AppKeystoreCliAction();

  @override
  String get description =>
      "Generate a keystore for Android and use it only at release build time. Save the password for keystore generation in `android/app/appkey_password.key`. Store the keystore in `android/app/appkey.keystore` and `android/app/appkey.p12`. Save the keystore information in `android/key.properties` so that it can be read by build.gradle. Save fingerprint information in `android/app/appkey_fingerprint.txt`. Android用のkeystoreを生成しリリースビルド時のみ利用するようにします。`android/app/appkey_password.key`にkeystoreの生成時のパスワードを保存します。`android/app/appkey.keystore`と`android/app/appkey.p12`にキーストアが保存されます。`android/key.properties`にキーストアの情報を保存し、build.gradleで読み込めるようにします。`android/app/appkey_fingerprint.txt`にフィンガープリント情報を保存します。When `ANDROID_KEYSTORE_B64` and `ANDROID_KEYSTORE_PASSWORD` are set, no keystore files are created and Gradle decodes the keystore from the environment variables at build time (`ANDROID_KEYSTORE_ALIAS` optionally overrides the alias). `ANDROID_KEYSTORE_B64`と`ANDROID_KEYSTORE_PASSWORD`が設定されている場合はキーストアのファイルを作らず、ビルド時にGradleが環境変数からキーストアを復元します（`ANDROID_KEYSTORE_ALIAS`でエイリアスを上書きできます）。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("keystore");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final com = context.args.get(2, "");
    if (com == "init") {
      label("Add initial information in `katana.yaml`.");
      final yaml = context.rawYaml ?? context.yaml;
      if (!yaml.containsKey("app")) {
        yaml["app"] = {};
      }
      final app = yaml.getAsMap("app");
      if (!app.containsKey("keystore")) {
        app["keystore"] = {};
      }
      final keystore = app.getAsMap("keystore");
      keystore["alias"] = "";
      keystore["name"] = "";
      keystore["organization"] = "";
      keystore["state"] = "Tokyo";
      keystore["country"] = "Japan";
      await context.save();
      return;
    }
    final bin = context.yaml.getAsMap("bin");
    final keytool = bin.get("keytool", "keytool");
    final openssl = bin.get("openssl", "openssl");
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final keystore = app.getAsMap("keystore");
    if (keystore.isEmpty) {
      error("The item [app]->[keystore] is missing. Please add an item.");
      return;
    }
    final alias = keystore.get("alias", "");
    if (AndroidSigningEnvironment.isConfigured()) {
      // 環境変数のキーストアを使う場合はファイルを生成せずGradleの設定のみ行う。
      if (alias.isEmpty &&
          AndroidSigningEnvironment.value(
                AndroidSigningEnvironment.aliasVariable,
              ) ==
              null) {
        error(
          "The keystore alias is missing. Set `${AndroidSigningEnvironment.aliasVariable}` or describe [app]->[keystore]->[alias].",
        );
        return;
      }
      label(
        "Use the keystore from `${AndroidSigningEnvironment.keystoreVariable}` and `${AndroidSigningEnvironment.passwordVariable}`. Skip creating keystore files.",
      );
      await applyGradle(alias);
      await _applyGitignore(context);
      return;
    }
    if (alias.isEmpty) {
      error(
        "The item [app]->[keystore]->[alias] is missing. Please describe the alias of the keystore.",
      );
      return;
    }
    final name = keystore.get("name", "");
    if (name.isEmpty) {
      error(
        "The item [app]->[keystore]->[name] is missing. Describe the common name of the keytool.",
      );
      return;
    }
    final organization = keystore.get("organization", "");
    if (organization.isEmpty) {
      error(
        "The item [app]->[keystore]->[organization] is missing. Describe the organization of the keytool.",
      );
      return;
    }
    final state = keystore.get("state", "");
    if (state.isEmpty) {
      error(
        "The item [app]->[keystore]->[state] is missing. Describe the state of the keytool.",
      );
      return;
    }
    final country = keystore.get("country", "");
    if (country.isEmpty) {
      error(
        "The item [app]->[keystore]->[country] is missing. Describe the country of the keytool.",
      );
      return;
    }
    label("Create a password.");
    final passwordFile = File("android/app/appkey_password.key");
    if (!passwordFile.existsSync()) {
      final password = generateCode(16);
      passwordFile.writeAsStringSync(password);
    }
    final password = passwordFile.readAsStringSync();
    label("Create a keystore.");
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
    label("Convert the keystore to a p12 file.");
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
    label("Store keystore information in `key.properties`.");
    final properties = File("android/key.properties");
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
    await applyGradle(alias);
    label("Save the fingerprint information.");
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
    label("Save the keyhash information.");
    final keyHashFile = File("android/app/appkey_keyhash.txt");
    if (!keyHashFile.existsSync()) {
      label("Create appkey_keyhash.txt");
      var keyHash = "";
      final keytoolResult = await Process.start(keytool, [
        "-exportcert",
        "-v",
        "-keystore",
        "android/app/appkey.keystore",
        "-alias",
        alias,
        "-storepass",
        password,
      ]);
      final openSslSha1Restul = await Process.start(openssl, [
        "sha1",
        "-binary",
      ]);
      unawaited(
        keytoolResult.stdout.pipe(openSslSha1Restul.stdin),
      );
      final openSslBase64Result = await Process.start(openssl, ["base64"]);
      unawaited(
        openSslSha1Restul.stdout.pipe(openSslBase64Result.stdin),
      );
      unawaited(
        openSslBase64Result.stdout.forEach((e) {
          final text = const Utf8Decoder(allowMalformed: true).convert(e);
          keyHash += text;
          stdout.add(e);
        }),
      );
      await openSslBase64Result.exitCode;
      await keyHashFile.writeAsString(keyHash);
    }
    await _applyGitignore(context);
  }

  /// Applies the signing settings to `android/app/build.gradle(.kts)`.
  ///
  /// Only the signing related parts are changed and other content is kept.
  /// [alias] is used as the last fallback for the key alias.
  ///
  /// `android/app/build.gradle(.kts)`に署名設定を反映します。
  ///
  /// 署名に関係する箇所だけを変更し、それ以外の記述は保持します。
  /// [alias]はキーエイリアスの最後のフォールバックとして使われます。
  static Future<void> applyGradle(String alias) async {
    label("Add processing to the Gradle file.");
    final gradle = AppGradle();
    await gradle.load();
    if (gradle.isKotlin &&
        !gradle.imports.any((e) => e.import == "java.util.Properties")) {
      gradle.imports.add(
        GradleImport(
          import: "java.util.Properties",
        ),
      );
    }
    if (gradle.isKotlin &&
        !gradle.imports.any((e) => e.import == "java.util.Base64")) {
      gradle.imports.add(
        GradleImport(
          import: "java.util.Base64",
        ),
      );
    }
    if (!gradle.loadProperties.any((e) => e.name == "keyProperties")) {
      gradle.loadProperties.add(
        GradleLoadProperties(
          path: "key.properties",
          name: "keyProperties",
          file: "keyPropertiesFile",
          isKotlin: gradle.isKotlin,
        ),
      );
    }
    // 署名の参照だけを差し替え、proguardFileなど既存のビルドタイプ設定は残す。
    final buildTypes = gradle.android?.buildTypes;
    if (buildTypes != null) {
      final releaseSigningConfig = gradle.isKotlin
          ? "signingConfigs.getByName(\"release\")"
          : "signingConfigs.release";
      final debugSigningConfig = gradle.isKotlin
          ? "signingConfigs.getByName(\"debug\")"
          : "signingConfigs.debug";
      if (buildTypes.release == null) {
        buildTypes.release =
            GradleAndroidBuildType(signingConfig: releaseSigningConfig);
      } else {
        buildTypes.release!.signingConfig = releaseSigningConfig;
      }
      if (buildTypes.debug == null) {
        buildTypes.debug =
            GradleAndroidBuildType(signingConfig: debugSigningConfig);
      } else {
        buildTypes.debug!.signingConfig = debugSigningConfig;
      }
    }
    // 値は`AndroidSigningEnvironment`が生成するブロックで環境変数 → key.propertiesの順に解決する。
    // debugは解決できない場合に既定のデバッグ署名を使う。
    gradle.android?.signingConfigs = GradleAndroidSigningConfigs(
      release: GradleAndroidSigningConfig(
        keyAlias: AndroidSigningEnvironment.keyAliasExpression,
        keyPassword: AndroidSigningEnvironment.keyPasswordExpression,
        storeFile: AndroidSigningEnvironment.storeFileExpression,
        storePassword: AndroidSigningEnvironment.storePasswordExpression,
        isKotlin: gradle.isKotlin,
      ),
      debug: GradleAndroidSigningConfig(
        keyAlias: "${AndroidSigningEnvironment.keyAliasExpression} ?: keyAlias",
        keyPassword:
            "${AndroidSigningEnvironment.keyPasswordExpression} ?: keyPassword",
        storeFile:
            "${AndroidSigningEnvironment.storeFileExpression} ?: storeFile",
        storePassword:
            "${AndroidSigningEnvironment.storePasswordExpression} ?: storePassword",
        isKotlin: gradle.isKotlin,
      ),
      isKotlin: gradle.isKotlin,
    );
    await gradle.save();
    final gradleFile = File(
      gradle.isKotlin
          ? "android/app/build.gradle.kts"
          : "android/app/build.gradle",
    );
    final source = await gradleFile.readAsString();
    await gradleFile.writeAsString(
      AndroidSigningEnvironment.synchronize(
        source,
        isKotlin: gradle.isKotlin,
        alias: alias,
      ),
    );
  }

  Future<void> _applyGitignore(ExecContext context) async {
    label("Rewrite `.gitignore`.");
    final gitignore = File("android/.gitignore");
    if (!gitignore.existsSync()) {
      error("Cannot find `android/.gitignore`. Project is broken.");
      return;
    }
    final gitignores = await gitignore.readAsLines();
    if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
      if (!gitignores.any((e) => e.startsWith("key.properties"))) {
        gitignores.add("key.properties");
      }
      if (!gitignores.any((e) => e.startsWith("**/*.keystore"))) {
        gitignores.add("**/*.keystore");
      }
      if (!gitignores.any((e) => e.startsWith("**/*.jks"))) {
        gitignores.add("**/*.jks");
      }
      if (!gitignores.any((e) => e.startsWith("**/*.p12"))) {
        gitignores.add("**/*.p12");
      }
      if (!gitignores.any((e) => e.startsWith("*.json"))) {
        gitignores.add("*.json");
      }
      if (!gitignores.any((e) => e.startsWith("**/appkey_fingerprint.txt"))) {
        gitignores.add("**/appkey_fingerprint.txt");
      }
      if (!gitignores.any((e) => e.startsWith("**/appkey_password.key"))) {
        gitignores.add("**/appkey_password.key");
      }
    } else {
      gitignores.removeWhere((e) => e.startsWith("**/*.p12"));
      gitignores.removeWhere((e) => e.startsWith("*.json"));
      gitignores.removeWhere((e) => e.startsWith("**/appkey_fingerprint.txt"));
      gitignores.removeWhere((e) => e.startsWith("**/appkey_password.key"));
      gitignores.removeWhere((e) => e.startsWith("key.properties"));
      gitignores.removeWhere((e) => e.startsWith("**/*.keystore"));
      gitignores.removeWhere((e) => e.startsWith("**/*.jks"));
    }
    await gitignore.writeAsString(gitignores.join("\n"));
  }
}
