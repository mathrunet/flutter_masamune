// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/action/git/status_check.dart";
import "package:katana_cli/katana_cli.dart";

/// Gibhut Actions build for IOS.
///
/// IOS用のGibhut Actionsのビルド。
Future<void> buildIOS(
  ExecContext context, {
  required String gh,
  required String appName,
  required int defaultIncrementNumber,
}) async {
  final github = context.yaml.getAsMap("github");
  final action = github.getAsMap("action");
  final ios = action.getAsMap("ios");
  final issuerId = ios.get("issuer_id", "");
  final teamId = ios.get("team_id", "");
  final secretGithub = context.secrets.getAsMap("github");
  final claudeCode = context.yaml.getAsMap("claude_code");
  final build = claudeCode.get("build", "");
  final slack = secretGithub.getAsMap("slack");
  final slackIncomingWebhookUrl = slack.get("incoming_webhook_url", "");
  if (issuerId.isEmpty) {
    error(
      "The item [github]->[action]->[ios]->[issuer_id] is missing. Copy the Issuer ID listed on the page at https://appstoreconnect.apple.com/access/api.",
    );
    return;
  }
  if (teamId.isEmpty) {
    error(
      "The item [github]->[action]->[ios]->[team_id] is missing. Copy and include your team ID from https://developer.apple.com/account.",
    );
    return;
  }
  final p12File = await find(
    Directory("ios"),
    RegExp(r".p12$"),
  );
  if (p12File == null) {
    error(
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
    error(
      "Cannot find password file for Certificate. Please create a p12 file with `katana app p12`. Certificate用のパスワードファイルが見つかりません。`katana app p12`でp12ファイルを作成してください。",
    );
    return;
  }
  final p8File = await find(
    Directory("ios"),
    RegExp(r"AuthKey_([a-zA-Z0-9]+).p8$"),
  );
  if (p8File == null) {
    error(
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
    error(
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
      "Store `${mobileProvisionFile.path.last()}` in `secrets.IOS_PROVISIONING_PROFILE_${appName.toUpperCase()}`.",
      [
        gh,
        "secret",
        "set",
        "IOS_PROVISIONING_PROFILE_${appName.toUpperCase()}",
        "--body",
        mobileProvision,
      ],
    );
  }
  await command(
    "Store `${p12File.path.last()}` in `secrets.IOS_CERTIFICATES_P12_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "IOS_CERTIFICATES_P12_${appName.toUpperCase()}",
      "--body",
      p12,
    ],
  );
  await command(
    "Store `ios_certificate_password.key` in `secrets.IOS_CERTIFICATE_PASSWORD_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "IOS_CERTIFICATE_PASSWORD_${appName.toUpperCase()}",
      "--body",
      password,
    ],
  );
  await command(
    "Store API key id in `secrets.IOS_API_KEY_ID_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "IOS_API_KEY_ID_${appName.toUpperCase()}",
      "--body",
      p8Key,
    ],
  );
  await command(
    "Store `${p8File.path}` in `secrets.IOS_API_AUTHKEY_P8_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "IOS_API_AUTHKEY_P8_${appName.toUpperCase()}",
      "--body",
      p8,
    ],
  );
  await command(
    "Store Issuer ID in `secrets.IOS_API_ISSUER_ID_${appName.toUpperCase()}`.",
    [
      gh,
      "secret",
      "set",
      "IOS_API_ISSUER_ID_${appName.toUpperCase()}",
      "--body",
      issuerId,
    ],
  );
  final gitDir = await findGitDirectory(Directory.current);
  final workingPath = Directory.current.difference(gitDir);
  await const GitStatusCheckActionCliCode().generateFile(
    "${workingPath.isEmpty ? "." : workingPath}/.github/workflows/actions/status_check/action.yaml",
  );
  final iosCode = GithubActionsIOSCliCode(
    workingDirectory: gitDir,
    defaultIncrementNumber: defaultIncrementNumber,
    buildOnClaudeCode: build.contains("ios"),
  );
  await iosCode.generateFile(
    "build_ios_${appName.toLowerCase()}.yaml",
    filter: (value) {
      return iosCode._additionalSlackFilter(
        value.replaceAll(
          "#### REPLACE_APP_NAME ####",
          appName.toUpperCase(),
        ),
        slackIncomingWebhookUrl,
      );
    },
  );
  label("Edit Info.plist.");
  final plist = File("ios/Runner/Info.plist");
  final document = XmlDocument.parse(await plist.readAsString());
  final dict = document.findAllElements("dict").firstOrNull;
  if (dict == null) {
    throw Exception(
      "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
    );
  }
  final nodeITSEncryptionExportComplianceCode =
      dict.children.firstWhereOrNull((p0) {
    return p0 is XmlElement &&
        p0.name.toString() == "key" &&
        p0.innerText == "ITSEncryptionExportComplianceCode";
  });
  if (nodeITSEncryptionExportComplianceCode == null) {
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
  final nodeITSAppUsesNonExemptEncryption =
      dict.children.firstWhereOrNull((p0) {
    return p0 is XmlElement &&
        p0.name.toString() == "key" &&
        p0.innerText == "ITSAppUsesNonExemptEncryption";
  });
  if (nodeITSAppUsesNonExemptEncryption == null) {
    dict.children.addAll(
      [
        XmlElement(
          XmlName("key"),
          [],
          [XmlText("ITSAppUsesNonExemptEncryption")],
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
    error("Cannot find `ios/.gitignore`. Project is broken.");
    return;
  }
  final gitignores = await gitignore.readAsLines();
  if (context.yaml.getAsMap("git").get("ignore_secure_file", true)) {
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
  } else {
    gitignores.removeWhere((e) => e.startsWith("**/*.p12"));
    gitignores.removeWhere((e) => e.startsWith("**/*.p8"));
    gitignores.removeWhere((e) => e.startsWith("**/*.mobileprovision"));
    gitignores.removeWhere((e) => e.startsWith("**/*.pem"));
    gitignores.removeWhere((e) => e.startsWith("**/*.cer"));
    gitignores.removeWhere((e) => e.startsWith("**/*.certSigningRequest"));
    gitignores
        .removeWhere((e) => e.startsWith("**/ios_certificate_password.key"));
    gitignores.removeWhere((e) => e.startsWith("**/ios_enterprise.key"));
  }
  await gitignore.writeAsString(gitignores.join("\n"));
}

/// Contents of buiod.yaml for IOS in Github Actions.
///
/// Github ActionsのIOS用のbuiod.yamlの中身。
class GithubActionsIOSCliCode extends CliCode {
  /// Contents of buiod.yaml for IOS in Github Actions.
  ///
  /// Github ActionsのIOS用のbuiod.yamlの中身。
  const GithubActionsIOSCliCode({
    this.workingDirectory,
    this.defaultIncrementNumber = 0,
    this.slackWebhookURL,
    this.buildOnClaudeCode = false,
  });

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  /// Increment number.
  ///
  /// インクリメント番号。
  final int defaultIncrementNumber;

  /// Include the URL of the Incoming webhook if Slack notifications are used.
  ///
  /// Slack通知を利用する場合Incoming webhookのURLを記載。
  final String? slackWebhookURL;

  /// Whether to build on claude code.
  ///
  /// claude codeでビルドを行うかどうか。
  final bool buildOnClaudeCode;

  @override
  String get name => "build_ios";

  @override
  String get prefix => "build_ios";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/workflows";
  }

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
    final workingPath = workingDirectory?.difference(Directory.current);
    return """
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
${buildOnClaudeCode ? """
  # This workflow runs when there is a pull_request on the main, master, develop branch.
  # main, master, develop branch に pull_request があったらこの workflow が走る。
  pull_request:
    branches:
      - main
      - master
      - develop
    types:
      - opened
      - reopened
      - synchronize
""" : ""} 
  # This workflow runs when there is a push on the publish branch.
  # publish branch に push があったらこの workflow が走る。
  push:
    branches:
      - publish

jobs:
  # ----------------------------------------------------------------- #
  # Status check
  # ----------------------------------------------------------------- #
  status_check:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    defaults:
      run:
        working-directory: ${workingPath.isEmpty ? "." : workingPath}
    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
        timeout-minutes: 10
        uses: actions/checkout@v4

      # Flutter status check.
      # Flutterのステータスチェックを行います。
      - name: Flutter status check
        timeout-minutes: 30
        uses: ./.github/actions/status_check

  # ----------------------------------------------------------------- #
  # Build for IOS
  # ----------------------------------------------------------------- #
  build_ios:
    runs-on: macos-latest
    needs: status_check
    timeout-minutes: 90
    defaults:
      run:
        working-directory: ${workingPath.isEmpty ? "." : workingPath}
    steps:
      # Check-out.
      # チェックアウト。
      - name: Checks-out my repository
        timeout-minutes: 10
        uses: actions/checkout@v4

      # Install flutter.
      # Flutterのインストール。
      - name: Install flutter
        timeout-minutes: 10
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      # Check flutter version.
      # Flutterのバージョン確認。
      - name: Run flutter version
        run: flutter --version
        timeout-minutes: 3

      # Download package.
      # パッケージのダウンロード。
      - name: Download flutter packages
        run: flutter pub get
        timeout-minutes: 3

      # Creation of the Assets folder.
      # Assetsフォルダの作成。
      - name: Create assets folder
        run: mkdir -p assets
        timeout-minutes: 3

      # Certificate settings.
      # Certificateの設定。
      - name: Import Apple Development Certificate
        env:
            IOS_KEYCHAIN_PASSWORD: \${{ secrets.IOS_KEYCHAIN_PASSWORD_#### REPLACE_APP_NAME #### }}
            IOS_CERTIFICATES_P12: \${{ secrets.IOS_CERTIFICATES_P12_#### REPLACE_APP_NAME #### }}
            IOS_CERTIFICATE_PASSWORD: \${{ secrets.IOS_CERTIFICATE_PASSWORD_#### REPLACE_APP_NAME #### }}
        run: |
            APPLE_DEVELOPMENT_CERTIFICATE=\$RUNNER_TEMP/development_certificate.p12
            KEYCHAIN_PATH=\$RUNNER_TEMP/app-signing.keychain-db

            # import certificate from secrets
            echo -n "\$IOS_CERTIFICATES_P12" | base64 --decode --output \$APPLE_DEVELOPMENT_CERTIFICATE

            # create temporary keychain
            security create-keychain -p "\$IOS_KEYCHAIN_PASSWORD" \$KEYCHAIN_PATH
            security set-keychain-settings -lut 21600 \$KEYCHAIN_PATH
            security unlock-keychain -p "\$IOS_KEYCHAIN_PASSWORD" \$KEYCHAIN_PATH

            # import certificate to keychain
            security import \$APPLE_DEVELOPMENT_CERTIFICATE -P "\$IOS_CERTIFICATE_PASSWORD" -A -t cert -f pkcs12 -k \$KEYCHAIN_PATH
            security list-keychain -d user -s \$KEYCHAIN_PATH
        timeout-minutes: 3
      
      # Create AppStoreConnectAPI key.
      # AppStoreConnectAPIキーを作成。
      - name: Create App Store Connect API Private Key in `pwd`/private_keys
        env:
          IOS_API_KEY_ID: \${{ secrets.IOS_API_KEY_ID_#### REPLACE_APP_NAME #### }}
          IOS_API_AUTHKEY_P8: \${{ secrets.IOS_API_AUTHKEY_P8_#### REPLACE_APP_NAME #### }}
        run: |
          mkdir `pwd`/private_keys
          echo -n "\$IOS_API_AUTHKEY_P8" | base64 --decode --output `pwd`/private_keys/AuthKey_\$IOS_API_KEY_ID.p8
        timeout-minutes: 3

      # Flutter build.
      # Flutterのビルド。
      - name: Run flutter build
        id: build
        run: flutter build ios --release --no-codesign --release --dart-define=FLAVOR=prod --build-number \$((\$GITHUB_RUN_NUMBER+$defaultIncrementNumber))
        timeout-minutes: 60

      # Archive of built data.
      # ビルドされたデータのアーカイブ。
      - name: Archive by xcodebuild
        env:
          IOS_API_ISSUER_ID: \${{ secrets.IOS_API_ISSUER_ID_#### REPLACE_APP_NAME #### }}
          IOS_API_KEY_ID: \${{ secrets.IOS_API_KEY_ID_#### REPLACE_APP_NAME #### }}
        run: xcodebuild archive -workspace ./ios/Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS -archivePath ./build/ios/Runner.xcarchive -allowProvisioningUpdates -authenticationKeyIssuerID \$IOS_API_ISSUER_ID -authenticationKeyID \$IOS_API_KEY_ID -authenticationKeyPath `pwd`/private_keys/AuthKey_\$IOS_API_KEY_ID.p8
        timeout-minutes: 60

      # Export of built archives.
      # ビルドされたアーカイブのエクスポート。
      - name: Export by xcodebuild
        env:
          IOS_API_ISSUER_ID: \${{ secrets.IOS_API_ISSUER_ID_#### REPLACE_APP_NAME #### }}
          IOS_API_KEY_ID: \${{ secrets.IOS_API_KEY_ID_#### REPLACE_APP_NAME #### }}
        run: xcodebuild -exportArchive -archivePath ./build/ios/Runner.xcarchive -exportPath ./build/ios/ipa -exportOptionsPlist ./ios/ExportOptions.plist -allowProvisioningUpdates -authenticationKeyIssuerID \$IOS_API_ISSUER_ID -authenticationKeyID \$IOS_API_KEY_ID -authenticationKeyPath `pwd`/private_keys/AuthKey_\$IOS_API_KEY_ID.p8
        timeout-minutes: 60

      # IPA file detection.
      # IPAファイルの検出。
      - name: Detect path for ipa file
        run: |
          echo "IPA_PATH=\$(find build/ios/ipa -type f -name '*.ipa')" >> \$GITHUB_ENV
        timeout-minutes: 3

      # Upload IPA files to AppStoreConnect.
      # IPAファイルのAppStoreConnectへのアップロード。
      - name: Upload to App Store Connect
        env:
          IOS_API_ISSUER_ID: \${{ secrets.IOS_API_ISSUER_ID_#### REPLACE_APP_NAME #### }}
          IOS_API_KEY_ID: \${{ secrets.IOS_API_KEY_ID_#### REPLACE_APP_NAME #### }}
        run: xcrun altool --upload-app --type ios -f \$IPA_PATH --apiKey \$IOS_API_KEY_ID --apiIssuer \$IOS_API_ISSUER_ID
        timeout-minutes: 30

      # Delete cache.
      # キャッシュの削除。
      - name: Clean up keychain and provisioning profile
        run: security delete-keychain \$RUNNER_TEMP/app-signing.keychain-db
        timeout-minutes: 3
""";
  }

  String _additionalSlackFilter(
      String source, String? slackIncomingWebhookURL) {
    if (slackIncomingWebhookURL.isEmpty) {
      return source;
    }
    return source += """

      # Slack notification (on success)
      # Slack通知（成功時）
      - name: Slack Notification on Success
        uses: rtCamp/action-slack-notify@v2
        if: \${{success()}}
        env:
          SLACK_USERNAME: Github Actions
          SLACK_TITLE: Deploy / Success
          SLACK_COLOR: good
          SLACK_MESSAGE: Deployment completed.
          SLACK_ICON_EMOJI: ':github:'
          SLACK_WEBHOOK: $slackIncomingWebhookURL

      # Slack notification (on failure)
      # Slack通知（失敗時）
      - name: Slack Notification on Failure
        uses: rtCamp/action-slack-notify@v2
        if: \${{failure()}}
        env:
          SLACK_USERNAME: Github Actions
          SLACK_TITLE: Deploy / Failure
          SLACK_COLOR: danger
          SLACK_MESSAGE: Deployment failed.😢
          SLACK_ICON_EMOJI: ':github:'
          SLACK_WEBHOOK: $slackIncomingWebhookURL
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
