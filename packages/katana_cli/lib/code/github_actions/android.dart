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
      "Create buiod.yaml for Android in Github Actions. Please set up your keystore in advance with the katana app keystore. Github ActionsのAndroid用のbuiod.yamlを作成します。事前にkatana app keystoreでキーストアの設定を行ってください。";

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
name: Android Production Workflow

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
        uses: actions/upload-artifact@v2.2.0
        with:
          name: andoroid_apk_release
          path: ./build/app/outputs/apk/release
          retention-days: 1

      # Upload the generated files.
      # 生成されたファイルのアップロード。
      - name: Upload aab artifacts
        uses: actions/upload-artifact@v2.2.0
        with:
          name: andoroid_aab_release
          path: ./build/app/outputs/bundle/release
          retention-days: 1

      # Uploaded by `gradle-play-publisher`.
      # https://github.com/Triple-T/gradle-play-publisher Use this external package.
      # `gradle-play-publisher`でアップロード。
      # https://github.com/Triple-T/gradle-play-publisher この外部パッケージを利用。
      - name: Upload to GooglePlayStore
        run: ./gradlew publishReleaseBundle
        working-directory: ./android
""";
  }
}
