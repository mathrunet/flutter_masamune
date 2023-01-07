import 'dart:convert';
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

/// Gibhut Actions build for IOS.
///
/// IOS用のGibhut Actionsのビルド。
Future<void> buildIOS(
  ExecContext context, {
  required String gh,
}) async {
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
    settings.buildSettings.removeWhere((e) => e.key == "DEVELOPMENT_TEAM");
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
  await const ExportOptionsCliCode().generateFile("ExportOptions.plist");
  final p8 = base64.encode(await p8File.readAsBytes());
  final p8Key =
      RegExp(r"AuthKey_([a-zA-Z0-9]+).p8$").firstMatch(p8File.path)!.group(1)!;
  final p12 = base64.encode(await p12File.readAsBytes());
  final password = await passwordFile.readAsString();
  if (mobileProvisionFile != null) {
    final mobileProvision =
        base64.encode(await mobileProvisionFile.readAsBytes());
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
  }
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
  if (!gitignores.any((e) => e.startsWith("**/ios_certificate_password.key"))) {
    gitignores.add("**/ios_certificate_password.key");
  }
  if (!gitignores.any((e) => e.startsWith("**/ios_enterprise.key"))) {
    gitignores.add("**/ios_enterprise.key");
  }
}
