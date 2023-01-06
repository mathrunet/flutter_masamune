part of katana_cli;

/// Contents of buiod.yaml for Android in Github Actions.
///
/// Github ActionsのAndroid用のbuiod.yamlの中身。
class GithubActionsAndroidCliCode extends CliCode {
  /// Contents of buiod.yaml for Android in Github Actions.
  ///
  /// Github ActionsのAndroid用のbuiod.yamlの中身。
  const GithubActionsAndroidCliCode();

  @override
  String get name => "build_android";

  @override
  String get prefix => "build_android";

  @override
  String get directory => ".github/workflows";

  @override
  String get description =>
      "Create buiod.yaml for Android in Github Actions. Please set up your keystore in the katana app keystore beforehand. Also, create the app in Google Play Console, upload the aab file for the first time, and complete the app settings except for the store listing information settings. Github ActionsのAndroid用のbuiod.yamlを作成します。事前にkatana app keystoreでキーストアの設定を行ってください。また、GooglePlayConsoleでアプリを作成し、aabファイルの初回アップロード、アプリの設定でストア掲載情報設定以外を済ませておいてください。";

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
# Build and upload your Flutter Android app.
# 
# apk and aab files will be stored in Github storage. (Storage period is 1 day)
#
# The app is uploaded to GooglePlayConsole in an internal test draft.
#
# Please create a keystore for your app in advance with `katana app keystore`.
#
# Also, please create your app in Google PlayConsole, upload the aab file for the first time, and complete the app settings except for the store listing information settings.
# 
# FlutterのAndroidアプリをビルドしアップロードします。
#
# apkファイルとaabファイルがGithubのストレージに保管されます。（保管期限1日）
# 
# GooglePlayConsoleへアプリが内部テストのドラフトでアップロードされます。
#
# 事前に`katana app keystore`でアプリ用のキーストアを作成しておいてください。
# 
# また、GooglePlayConsoleでアプリを作成し、aabファイルの初回アップロード、アプリの設定でストア掲載情報設定以外を済ませておいてください。
name: AndroidProductionWorkflow

on:
  # This workflow runs when there is a push on the publish branch.
  # publish branch に push があったらこの workflow が走る。
  push:
    branches: [ publish ]

jobs:
  # ----------------------------------------------------------------- #
  # Build for Android
  # ----------------------------------------------------------------- #
  build_android:

    runs-on: ubuntu-latest

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

      # Generate appkey.keystore from Secrets.
      # Secretsからappkey.keystoreを生成。
      - name: Create appkey.keystore
        run: echo -n ${{ secrets.ANDROID_KEYSTORE }} | base64 -d > android/app/appkey.keystore

      # Generate service_account_key.json from Secrets.
      # Secretsからservice_account_key.jsonを生成。
      - name: Create service_account_key.json
        run: echo -n ${{ secrets.ANDROID_SERVICE_ACCOUNT_KEY_JSON }} | base64 -d > android/service_account_key.json

      # Generate key.properties from Secrets.
      # Secretsからkey.propertiesを生成。
      - name: Create key.properties
        run: echo ${{ secrets.ANDROID_KEY_PROPERTIES }} | base64 -d > android/key.properties

      # Generate Apk.
      # Apkを生成。
      - name: Building Android apk
        run: flutter build apk --build-number ${GITHUB_RUN_NUMBER} --release --dart-define=FLAVOR=prod

      # Generate app bundle.
      # App Bundleを生成。
      - name: Building Android AppBundle
        run: flutter build appbundle --build-number ${GITHUB_RUN_NUMBER} --release --dart-define=FLAVOR=prod
      
      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload apk artifacts
        uses: actions/upload-artifact@v2
        with:
          name: andoroid_apk_release
          path: ./build/app/outputs/apk/release
          retention-days: 1

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload aab artifacts
        uses: actions/upload-artifact@v2
        with:
          name: andoroid_aab_release
          path: ./build/app/outputs/bundle/release
          retention-days: 1

      # Upload to Google Play Store.
      # Google Play Storeにアップロード。
      - name: Deploy to Google Play Store
        id: deploy
        uses: r0adkll/upload-google-play@v1
        with:
          track: internal
          status: draft
          serviceAccountJson: android/service_account_key.json
          packageName: #### REPLACE_ANDROID_PACKAGE_NAME ####
          releaseFiles: ./build/app/outputs/bundle/release/*.aab
""";
  }
}
