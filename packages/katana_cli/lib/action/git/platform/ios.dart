import 'dart:convert';
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';
import 'package:xml/xml.dart';

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
  label("Edit Info.plist.");
  final plist = File("ios/Runner/Info.plist");
  final document = XmlDocument.parse(await plist.readAsString());
  final dict = document.findAllElements("dict").firstOrNull;
  if (dict == null) {
    throw Exception(
      "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
    );
  }
  final node = dict.children.firstWhereOrNull((p0) {
    return p0 is XmlElement &&
        p0.name.toString() == "key" &&
        p0.innerText == "ITSEncryptionExportComplianceCode";
  });
  if (node == null) {
    dict.children.addAll(
      [
        XmlElement(
          XmlName("key"),
          [],
          [XmlText("ITSEncryptionExportComplianceCode")],
        ),
        XmlElement(
          XmlName("false"),
        ),
      ],
    );
  }
  await plist.writeAsString(
    document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
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
  if (!gitignores.any((e) => e.startsWith("**/ios_certificate_password.key"))) {
    gitignores.add("**/ios_certificate_password.key");
  }
  if (!gitignores.any((e) => e.startsWith("**/ios_enterprise.key"))) {
    gitignores.add("**/ios_enterprise.key");
  }
}

/// Contents of buiod.yaml for IOS in Github Actions.
///
/// Github ActionsのIOS用のbuiod.yamlの中身。
class GithubActionsIOSCliCode extends CliCode {
  /// Contents of buiod.yaml for IOS in Github Actions.
  ///
  /// Github ActionsのIOS用のbuiod.yamlの中身。
  const GithubActionsIOSCliCode();

  @override
  String get name => "build_ios";

  @override
  String get prefix => "build_ios";

  @override
  String get directory => ".github/workflows";

  @override
  String get description =>
      "Create buiod.yaml for IOS in Github Actions. Create `CertificateSigningRequest.certSigningRequest` in advance with katana app csr and p12 file with katana app p12. Github ActionsのIOS用のbuiod.yamlを作成します。事前にkatana app csrで`CertificateSigningRequest.certSigningRequest`を作成し、katana app p12でp12ファイルを作成してください。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
# Build and upload a Flutter IOS app.
# 
# Nothing is stored in Github storage.
#
# Create a `CertificateSigningRequest.certSigningRequest` with `katana app csr` in advance and download the Apple Development Certificate.
#
# Create an AuthKey in AppStoreConnect and put the Issuer ID and Team ID in katana.yaml.
#
# Also, please make sure you have created your app in AppStoreConnect.
# 
# FlutterのIOSアプリをビルドしアップロードします。
#
# Githubのストレージにはなにも保管されません。
# 
# AppStoreConnectへアプリがアップロードされます。
#
# 事前に`katana app csr`で`CertificateSigningRequest.certSigningRequest`を作成し、Apple DevelopmentのCertificateをダウンロードしてください。
#
# AppStoreConnectでAuthKeyを作成し、Issuer IDとチームIDをkatana.yamlに記載しておきます。
# 
# また、AppStoreConnectでアプリを作成しておいてください。
name: IOSProductionWorkflow

on:
  # This workflow runs when there is a push on the publish branch.
  # publish branch に push があったらこの workflow が走る。
  push:
    branches: [ publish ]

jobs:
  # ----------------------------------------------------------------- #
  # Build for IOS
  # ----------------------------------------------------------------- #
  build_ios:

    runs-on: macos-latest

    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
        uses: actions/checkout@v2

      # Install flutter.
      # Flutterのインストール。
      - name: Install flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      # Check flutter version.
      # Flutterのバージョン確認。
      - name: Run flutter version
        run: flutter --version

      # Download package.
      # パッケージのダウンロード。
      - name: Download flutter packages
        run: flutter pub get

      # Running flutter analyze.
      # Flutter analyzeの実行。
      - name: Analyzing flutter project
        run: flutter analyze

      # Running the flutter test.
      # Flutter testの実行。
      - name: Testing flutter project
        run: flutter test

      # Certificate settings.
      # Certificateの設定。
      - name: Import Apple Development Certificate
        env:
            IOS_KEYCHAIN_PASSWORD: ${{ secrets.IOS_KEYCHAIN_PASSWORD }}
            IOS_CERTIFICATES_P12: ${{ secrets.IOS_CERTIFICATES_P12 }}
            IOS_CERTIFICATE_PASSWORD: ${{ secrets.IOS_CERTIFICATE_PASSWORD }}
        run: |
            APPLE_DEVELOPMENT_CERTIFICATE=$RUNNER_TEMP/development_certificate.p12
            KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db

            # import certificate from secrets
            echo -n "$IOS_CERTIFICATES_P12" | base64 --decode --output $APPLE_DEVELOPMENT_CERTIFICATE

            # create temporary keychain
            security create-keychain -p "$IOS_KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
            security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
            security unlock-keychain -p "$IOS_KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

            # import certificate to keychain
            security import $APPLE_DEVELOPMENT_CERTIFICATE -P "$IOS_CERTIFICATE_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
            security list-keychain -d user -s $KEYCHAIN_PATH
      
      # Create AppStoreConnectAPI key.
      # AppStoreConnectAPIキーを作成。
      - name: Create App Store Connect API Private Key in ./private_keys
        env:
          IOS_API_KEY_ID: ${{ secrets.IOS_API_KEY_ID }}
          IOS_API_AUTHKEY_P8: ${{ secrets.IOS_API_AUTHKEY_P8 }}
        run: |
          mkdir ./private_keys
          echo -n "$IOS_API_AUTHKEY_P8" | base64 --decode --output ./private_keys/AuthKey_$IOS_API_KEY_ID.p8

      # Flutter build.
      # Flutterのビルド。
      - name: Run flutter build
        id: build
        run: flutter build ios --release --no-codesign --release --dart-define=FLAVOR=prod --build-number ${GITHUB_RUN_NUMBER}

      # Archive of built data.
      # ビルドされたデータのアーカイブ。
      - name: Archive by xcodebuild
        env:
          IOS_API_ISSUER_ID: ${{ secrets.IOS_API_ISSUER_ID }}
          IOS_API_KEY_ID: ${{ secrets.IOS_API_KEY_ID }}
        run: xcodebuild archive -workspace ./ios/Runner.xcworkspace -scheme Runner -configuration Release -archivePath ./build/ios/Runner.xcarchive -allowProvisioningUpdates -authenticationKeyIssuerID $IOS_API_ISSUER_ID -authenticationKeyID $IOS_API_KEY_ID -authenticationKeyPath `pwd`/private_keys/AuthKey_$IOS_API_KEY_ID.p8

      # Export of built archives.
      # ビルドされたアーカイブのエクスポート。
      - name: Export by xcodebuild
        env:
          IOS_API_ISSUER_ID: ${{ secrets.IOS_API_ISSUER_ID }}
          IOS_API_KEY_ID: ${{ secrets.IOS_API_KEY_ID }}
        run: xcodebuild -exportArchive -archivePath ./build/ios/Runner.xcarchive -exportPath ./build/ios/ipa -exportOptionsPlist ./ios/ExportOptions.plist -allowProvisioningUpdates -authenticationKeyIssuerID $IOS_API_ISSUER_ID -authenticationKeyID $IOS_API_KEY_ID -authenticationKeyPath `pwd`/private_keys/AuthKey_$IOS_API_KEY_ID.p8

      # IPA file detection.
      # IPAファイルの検出。
      - name: Detect path for ipa file
        run: |
          echo "IPA_PATH=$(find build/ios/ipa -type f -name '*.ipa')" >> $GITHUB_ENV

      # Upload IPA files to AppStoreConnect.
      # IPAファイルのAppStoreConnectへのアップロード。
      - name: Upload to App Store Connect
        env:
          IOS_API_ISSUER_ID: ${{ secrets.IOS_API_ISSUER_ID }}
          IOS_API_KEY_ID: ${{ secrets.IOS_API_KEY_ID }}
        run: xcrun altool --upload-app --type ios -f $IPA_PATH --apiKey $IOS_API_KEY_ID --apiIssuer $IOS_API_ISSUER_ID
""";
  }
}

/// Contents of ExportOptions.plist.
///
/// ExportOptions.plistの中身。
class ExportOptionsCliCode extends CliCode {
  /// Contents of ExportOptions.plist.
  ///
  /// ExportOptions.plistの中身。
  const ExportOptionsCliCode();

  @override
  String get name => "ExportOptions";

  @override
  String get prefix => "ExportOptions";

  @override
  String get directory => "ios";

  @override
  String get description =>
      "Create ExportOptions.plist for IOS builds. IOSビルド用のExportOptions.plistを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>generateAppStoreInformation</key>
    <false/>
    <key>method</key>
    <string>app-store</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
  </dict>
</plist>
""";
  }
}
