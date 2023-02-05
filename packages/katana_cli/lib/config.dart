/// Describe the settings.
///
/// 設定を記述します。
class Config {
  Config._();

  /// Contents of katana.yaml.
  ///
  /// katana.yamlの中身。
  static const String katanaYamlCode = r"""
# Describe the application information.
# アプリケーション情報を記載します。
app:

  # The application icon is automatically set based on the image file specified in [path].
  # Image files should be created as 1024 x 1024 png files.
  # [path]に指定された画像ファイルを元にアプリのアイコンを自動設定します。
  # 画像ファイルは1024×1024のpngファイルで作成してください。
  icon:
    enable: false
    path: assets/icon.png

  # Retrieve data from a spreadsheet retrieved by a specific Google Form.
  # Please include the URL of the spreadsheet in [url] and the email address you collected in [email].
  # 特定のGoogleフォームで取得したスプレッドシートからデータを取得します。
  # [url]にスプレッドシートのURL、[email]に収集したメールアドレスを記載してください。
  spread_sheet:
    enable: false
    url:
    email:

  # Create a `CertificateSigningRequest.certSigningRequest` for iOS.
  # Please include your support email address in [email].
  # iOS用の`CertificateSigningRequest.certSigningRequest`を作成します。
  # [email]にサポート用のEmailアドレスを記載してください。
  csr: 
    enable: false
    email:
  
  # Convert the cer file created by Certificate in AppleDeveloperProgram from `CertificateSigningRequest.certSigningRequest` to a p12 file.
  # `CertificateSigningRequest.certSigningRequest`からAppleDeveloperProgramのCertificateにて作成されたcerファイルをp12ファイルに変換します。
  p12:
    enable: false

  # Create a keystore for Android.
  # Enter the alias of the keystore in [alias], the common name in [name], the organization name in [organization], the state or province in [state], and the country in [country].
  # Android用のkeystoreを作成します。
  # [alias]にkeystoreのエイリアス、[name]に共通名、[organization]に組織名、[state]に州や都道府県、[country]に国名を入力してください。
  keystore: 
    enable: false
    alias: 
    name: 
    organization: 
    state: Tokyo
    country: Japan
  
  # Describe the settings for using the file picker.
  # Describe the platform for using the picker in [platform]. Specify `any` or `mobile`. Import the picker package for that platform.
  # Specify the permission message to use the library in IOS in [permission].
  # Please include `en`, `ja`, etc. and write the message in that language there.
  # ファイルピッカーを利用するための設定を記述します。
  # [platform]にピッカーを利用するためのプラットフォームを記述します。`any`もしくは`mobile`を指定してください。そのプラットフォーム用のピッカーパッケージをインポートします。
  # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
  # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
  picker:
    enable: false
    platform: any
    permission:
      en: Use the library for profile images.

# This section contains information related to Firebase.
# Firebase関連の情報を記載します。
firebase:
  # Set the Firebase project ID.
  # FirebaseのプロジェクトIDを設定します。
  project_id:

  # Enable Firebase Firestore.
  # Firebase Firestoreを有効にします。
  firestore:
    enable: false

  # Enable Firebase Authentication.
  # Firebase Authenticationを有効にします。
  authentication:
    enable: false

  # Enable Firebase Functions.
  # Firebase Functionsを有効にします。
  functions:
    enable: false
  
  # Enable Firebase Analytics and Firebase Crashlytics.
  # Firebase AnalyticsとFirebase Crashlyticsを有効にします。
  logger:
    enable: false

  # Configure Firebase Hosting settings.
  # Set [use_flutter] to `true` so that all routes point to index.html, and set it to `true` when using Flutter Web.
  # Firebase Hostingの設定を行います。
  # [use_flutter]を`true`にするとすべてのルートがindex.htmlを向くようになります。Flutter Webを利用する際に`true`にしてください。
  hosting:
    enable: false
    use_flutter: false
  
  # Enable Firebase Messaging.
  # Specify ChannelNotificationId for Android in [channel_id].
  # Firebase Messagingを有効にします。
  # [channel_id]にAndroid用のChannelNotificationIdを指定してください。
  messaging:
    enable: false
    channel_id: 

# This section contains information related to Git.
# Git関連の情報を記載します。
git:
  # Add secure files to .gitignore.
  # If `false`, password files, etc. will be uploaded to Git.
  # Please limit your use to private repositories only.
  # セキュアなファイルを.gitignoreに追加します。
  # `false`にした場合、パスワードファイルなどがGitにアップロードされることになります。
  # プライベートレポジトリのみでの利用に限定してください。
  ignore_secure_file: true

  # Ensure that the dart code is modified and verified before committing.
  # lefthand installation is required.
  # コミット前にdartコードの修正や確認を行うようにします。
  # lefthandのインストールが必要です。
  pre_commit:
    enable: false

# Github-related information will be described.
# Github関連の情報を記載します。
github:
  # Enable Github Actions to perform CI/CD builds on each platform.
  # Enter the platform you wish to specify in [platform], separated by spaces.
  # Available platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`.
  # Github Actionsを有効にして各プラットフォームでCI/CDビルドを行うようにします。
  # [platform]で指定したいプラットフォームをスペース区切り入力します。
  # 使用できるプラットフォームは`android`、`ios`、`web`、`windows`、`macos`、`linux`です。
  action:
    enable: false
    platform: android ios web
    ios:
      # Copy the Issuer ID listed on the page at https://appstoreconnect.apple.com/access/api.
      # https://appstoreconnect.apple.com/access/api のページに記載されているIssuer IDをコピーしてください。
      issuer_id: 
      # Please copy and include your team ID from https://developer.apple.com/account.
      # https://developer.apple.com/account のチームIDをコピーして記載してください。
      team_id: 
""";
}
