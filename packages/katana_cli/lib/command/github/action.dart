part of katana_cli.github;

/// Output yaml for Github Actions.
///
/// Github Actions用のyamlを出力します。
class GithubActionCliCommand extends CliCommand {
  /// Output yaml for Github Actions.
  ///
  /// Github Actions用のyamlを出力します。
  const GithubActionCliCommand();

  @override
  String get description =>
      "Output yaml for Github Actions. Pass the platform you want to support as a parameter, like `katana github action android ios web`. Available platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`. Github Actions用のyamlを出力します。`katana github action android ios web`のように対応したいプラットフォームをパラメーターとして渡してください。使用できるプラットフォームは`android`、`ios`、`web`、`windows`、`macos`、`linux`です。";

  @override
  Future<void> exec(ExecContext context) async {
    final platforms = context.args.sublist(2);
    if (platforms.isEmpty) {
      print(
        "Platform is not specified. Please pass the platform you want to support as a parameter, like `katana github action android ios web`. Supported platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`.",
      );
      return;
    }
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    for (final platform in platforms) {
      label("Create build.yaml for $platform");
      switch (platform) {
        // Android.
        case "android":
          final keystoreFile = File("android/app/appkey.keystore");
          if (!keystoreFile.existsSync()) {
            print(
              "Cannot find `android/app/appkey.keystore`. Run `katana app keystore` to create the keystore file. `android/app/appkey.keystore`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
            );
            return;
          }
          final keyPropertiesFile = File("android/key.properties");
          if (!keyPropertiesFile.existsSync()) {
            print(
              "Cannot find `android/key.properties`. Run `katana app keystore` to create the keystore file. `android/key.properties`が見つかりません。`katana app keystore`を実行しキーストアのファイルを作成してください。",
            );
            return;
          }
          final serviceAccountFile = await find(
            Directory("android"),
            RegExp("([a-z]+)-([a-z]+)-([0-9]+)-([0-9]+)-([a-z0-9]+).json"),
          );
          if (serviceAccountFile == null) {
            print(
              "Json for service account not found, please refer to https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b to set it up. サービスアカウント用のJsonが見つかりません。https://mathru.notion.site/Google-Play-Developer-df655aff2dfb49988b82feb7aae3c61b を参考に設定してください。",
            );
            return;
          }
          final keystore = base64.encode(await keystoreFile.readAsBytes());
          final keyProperties =
              base64.encode(await keyPropertiesFile.readAsBytes());
          final serviceAccount =
              base64.encode(await serviceAccountFile.readAsBytes());
          await command(
            "Store `appkey.keystore` in `secrets.ANDROID_KEYSTORE`.",
            [
              gh,
              "secret",
              "set",
              "ANDROID_KEYSTORE",
              "--body",
              keystore,
            ],
          );
          await command(
            "Store `key.properties` in `secrets.ANDROID_KEY_PROPERTIES`.",
            [
              gh,
              "secret",
              "set",
              "ANDROID_KEY_PROPERTIES",
              "--body",
              keyProperties,
            ],
          );
          await command(
            "Store `key.properties` in `secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON`.",
            [
              gh,
              "secret",
              "set",
              "ANDROID_SERVICE_ACCOUNT_KEY_JSON",
              "--body",
              serviceAccount,
            ],
          );
          await const GithubActionsAndroidCliCode()
              .generateFile("build_android.yaml");
          break;
        // IOS.
        case "ios":
          final github = context.yaml.getAsMap("github");
          final action = github.getAsMap("action");
          final ios = action.getAsMap("ios");
          final issuerId = ios.get("issuer_id", "");
          final teamId = ios.get("team_id", "");
          if (issuerId.isEmpty) {
            print(
              "The item [github]->[action]->[ios]->[issuer_id] is missing. Copy the Issuer ID listed on the page at https://appstoreconnect.apple.com/access/api.",
            );
            return;
          }
          if (teamId.isEmpty) {
            print(
              "The item [github]->[action]->[ios]->[team_id] is missing. Copy and include your team ID from https://developer.apple.com/account.",
            );
            return;
          }
          final p12File = await find(
            Directory("ios"),
            RegExp(r".p12$"),
          );
          if (p12File == null) {
            print(
              "Cannot find the `distribution/development.p12` file, download the cer file from AppleDeveloperProgram and create a p12 file with `katana app p12`. `distribution/development.p12`ファイルが見つかりません。cerファイルをAppleDeveloperProgramからダウンロードし、`katana app p12`でp12ファイルを作成してください。",
            );
            return;
          }
          final mobileProvisionFile = await find(
            Directory("ios"),
            RegExp("([^/.]+).mobileprovision"),
          );
          if (mobileProvisionFile == null) {
            print(
              "mobileprovision file not found, please create and download from AppleDeveloperProgram. mobileprovisionファイルが見つかりません。AppleDeveloperProgramから作成しダウンロードしてください。",
            );
            return;
          }
          final passwordFile = File("ios/ios_certificate_password.key");
          if (!passwordFile.existsSync()) {
            print(
              "Cannot find password file for Certificate. Please create a p12 file with `katana app p12`. Certificate用のパスワードファイルが見つかりません。`katana app p12`でp12ファイルを作成してください。",
            );
            return;
          }
          final p8File = await find(
            Directory("ios"),
            RegExp(r"AuthKey_([a-zA-Z0-9]+).p8$"),
          );
          if (p8File == null) {
            print(
              "Cannot find the `AuthKey` file, please download the file from AppStoreConnect and place it under the IOS folder. `AuthKey`ファイルが見つかりません。AppStoreConnectからファイルをダウンロードしiosフォルダ以下に配置してください。",
            );
            return;
          }
          label("Edit project.pbxproj");
          final xcode = XCode();
          await xcode.load();
          for (final settings in xcode.pbxBuildConfiguration) {
            settings.buildSettings
                .removeWhere((e) => e.key == "DEVELOPMENT_TEAM");
          }
          await xcode.save();
          label("Edit Release.xcconfig");
          final xcconfigFile = File("ios/Flutter/Release.xcconfig");
          if (!xcconfigFile.existsSync()) {
            print(
              "Cannot find `ios/Flutter/Release.xcconfig`. Project is broken.",
            );
            return;
          }
          final xcconfig = await xcconfigFile.readAsLines();
          if (!xcconfig.any((e) => e.startsWith("DEVELOPMENT_TEAM="))) {
            xcconfig.add("DEVELOPMENT_TEAM=$teamId");
          }
          await xcconfigFile.writeAsString(xcconfig.join("\n"));
          label("Create ExportOptions.plist");
          await const ExportOptionsCliCode()
              .generateFile("ExportOptions.plist");
          final p8 = base64.encode(await p8File.readAsBytes());
          final p8Key = RegExp(r"AuthKey_([a-zA-Z0-9]+).p8$")
              .firstMatch(p8File.path)!
              .group(1)!;
          final p12 = base64.encode(await p12File.readAsBytes());
          final mobileProvision =
              base64.encode(await mobileProvisionFile.readAsBytes());
          final password = await passwordFile.readAsString();
          await command(
            "Store `${mobileProvisionFile.path.last()}` in `secrets.IOS_PROVISIONING_PROFILE`.",
            [
              gh,
              "secret",
              "set",
              "IOS_PROVISIONING_PROFILE",
              "--body",
              mobileProvision,
            ],
          );
          await command(
            "Store `${p12File.path.last()}` in `secrets.IOS_CERTIFICATES_P12`.",
            [
              gh,
              "secret",
              "set",
              "IOS_CERTIFICATES_P12",
              "--body",
              p12,
            ],
          );
          await command(
            "Store `ios_certificate_password.key` in `secrets.IOS_CERTIFICATE_PASSWORD`.",
            [
              gh,
              "secret",
              "set",
              "IOS_CERTIFICATE_PASSWORD",
              "--body",
              password,
            ],
          );
          await command(
            "Store API key id in `secrets.IOS_API_KEY_ID`.",
            [
              gh,
              "secret",
              "set",
              "IOS_API_KEY_ID",
              "--body",
              p8Key,
            ],
          );
          await command(
            "Store `${p8File.path}` in `secrets.IOS_API_AUTHKEY_P8`.",
            [
              gh,
              "secret",
              "set",
              "IOS_API_AUTHKEY_P8",
              "--body",
              p8,
            ],
          );
          await command(
            "Store Issuer ID in `secrets.IOS_API_ISSUER_ID`.",
            [
              gh,
              "secret",
              "set",
              "IOS_API_ISSUER_ID",
              "--body",
              issuerId,
            ],
          );
          await const GithubActionsIOSCliCode().generateFile("build_ios.yaml");
          break;
      }
    }
  }
}
