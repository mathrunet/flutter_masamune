part of katana_cli;

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
name: IOS Production Workflow

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
