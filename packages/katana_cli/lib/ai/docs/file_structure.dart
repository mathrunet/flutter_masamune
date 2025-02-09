// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of file_structure.mdc.
///
/// file_structure.mdcの中身。
class FileStructureDocsMdcCliAiCode extends CliAiCode {
  /// Contents of file_structure.mdc.
  ///
  /// file_structure.mdcの中身。
  const FileStructureDocsMdcCliAiCode();

  @override
  String get name => "ファイル・フォルダ構成";

  @override
  String get description => "アプリケーション開発で利用するファイル・フォルダ構成";

  @override
  String get globs =>
      "lib/**/*.dart, test/**/*.dart, katana.yaml, documents/designs/**/*.md, firebase/functions/src/**/*.ts, firebase/functions/test/**/*.ts";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## フォルダ・ファイル構成

アプリケーション開発で利用するフォルダ・ファイル構成を下記に記載。

```
/
├── .cursor/ # カーソルの設定ファイル
│   └── rules/ # カーソルルールの設定ファイル
│       ├── docs/ # Masamuneフレームワーク向けのドキュメントフォルダ
│       │   ├── masamune.mdc # Masamuneフレームワーク向けのドキュメント
│       │   └── ...
│       ├── designs/ # 設計書用のフォルダ
│       │   ├── model_design.mdc # Model設計書作成用のルール
│       │   ├── theme_design.mdc # Theme設計書作成用のルール
│       │   ├── metadata_design.mdc # MetaData設計書作成用のルール
│       │   ├── plugin_design.mdc # Plugin設計書作成用のルール
│       │   ├── controller_design.mdc # Controller設計書作成用のルール
│       │   ├── page_design.mdc # Page設計書作成用のルール
│       │   └── ...
│       └── impls/ # 実装用のフォルダ
│           ├── model_impl.mdc # Model実装用のルール
│           ├── theme_impl.mdc # Theme実装用のルール
│           ├── metadata_impl.mdc # MetaData実装用のルール
│           ├── plugin_impl.mdc # Plugin実装用のルール
│           ├── controller_impl.mdc # Controller実装用のルール
│           ├── page_impl.mdc # Page実装用のルール
│           └── ...
├── .github/ # Github向けの設定ファイル
│   └── workflows/ # GithubActions用のワークフロー
│       ├── build_android_[ApplicationID].yaml
│       ├── build_ios_[ApplicationID].yaml
│       └── build_web_[ApplicationID].yaml
├── android/ # Android向けの設定ファイル
│   ├── app/
│   │   ├── ...
│   │   ├── appkey_fingerprint.txt # keystoreのフィンガープリント
│   │   ├── appkey_keyhash.txt # keystoreのキーハッシュ
│   │   ├── appkey_password.key # keystoreのパスワード
│   │   ├── appkey.keystore # keystore
│   │   ├── appkey.p12 # keystoreをp12に変換したファイル
│   │   └── google-services.json # Firebaseの設定ファイル（必要な場合）
│   ├── ...
│   ├── config.properties # build.gradle用の設定
│   ├── key.properties # keystore用の設定
│   └── xxxxxx.json # GooglePlayデプロイ用のサービスアカウントキー
├── ios/ # IOS向けの設定ファイル
│   ├── ...
│   ├── Runner/
│   │   ├── ...
│   │   ├── GoogleService-Info.plist # Firebaseの設定ファイル（必要な場合）
│   │   └── Info.plist # IOS用プロジェクトの設定ファイル
│   ├── ...
│   ├── AuthKey_xxxx.p8 # AppStoreデプロイ用の認証キー
│   ├── CertificateSigningRequest.certSigningRequest # CertificateSigningRequest用のファイル
│   ├── development.cer # 開発用Certificateファイル
│   ├── development.p12 # 開発用Certificateをp12に変換したファイル
│   ├── development.pem # 開発用Certificateをpemに変換したファイル
│   ├── ExportOptions.plist # デプロイ用の設定ファイル
│   ├── ios_certificate_password.key # 開発用Certificateを変換する際のパスワード
│   └── ios_enterprise.key # CertificateSigningRequestを出力した際のキー
├── web/ # Web向けの設定ファイル
│   ├── ...
│   └── index.html # WebのトップページのHTML
├── assets/ # 画像や映像、テキスト、音楽などのアセットファイルの格納フォルダ
│   └── images/ # 画像の格納フォルダ
│   │   └── ...
│   └── videos/ # 映像の格納フォルダ
│   │   └── ...
│   └── texts/ # テキストの格納フォルダ
│   │   └── ...
│   └── sounds/ # 音楽の格納フォルダ
│       └── ...
├── fonts/ # フォントファイルの格納フォルダ
│   └── ...
├── documents/ # 開発に関わるドキュメント類の格納フォルダ
│   ├── store/ # ストア用の画像
│   │   └── ...
│   ├── designs/ # AIが出力する設計書を格納するフォルダ
│   │   ├── model_design.md # **Model設計書**
│   │   ├── theme_design.md # **Theme設計書**
│   │   ├── metadata_design.md # **MetaData設計書**
│   │   ├── plugin_design.md # **Plugin設計書**
│   │   ├── controller_design.md # **Controller設計書**
│   │   ├── page_design.md # **Page設計書**
│   │   └── ...
│   └── ...
├── firebase/ # Firebase（バックエンド）用の設定フォルダ
│   ├── ...
│   ├── functions/ # CloudFunctions for Firebaseの設定フォルダ
│   │   ├── src/ # FunctionsのTypeScript実装ファイル
│   │   │   ├── functions/ # 独自のバックエンド関数実装フォルダ
│   │   │   │   └── ...
│   │   │   └── index.ts # CloudFunctions for Firebaseで利用する全関数設定ファイル
│   │   ├── test/ # Functionsのテストファイル
│   │   │   └── ...
│   │   ├── ...
│   │   └── .env # Functions用環境変数ファイル
│   ├── hosting/ # Firebase Hostingの設定フォルダ
│   │   ├── ja/ # 利用規約やプライバシーポリシーページ（日本語）
│   │   │   └── ...
│   │   ├── en/ # 利用規約やプライバシーポリシーページ（英語）
│   │   │   └── ...
│   │   ├── zh/ # 利用規約やプライバシーポリシーページ（簡体字）
│   │   │   └── ...
│   │   └── index.html # Firebase用Indexファイル
│   ├── ...
│   ├── .firebaserc # FirebaseプロジェクトIDが保管されているファイル
│   ├── firestore.indexes.json # FirestoreのIndex設定ファイル
│   ├── firestore.rules # Firestoreのルール設定ファイル
│   ├── storage.rules # CloudStorage for Firebaseのルール設定ファイル
│   └── firebase.json # Firebaseプロジェクト設定
├── lib/ # Flutter/Dart用実装フォルダ
│   ├── adapters/ # 各種独自`Adapter`を作成する場合はここに格納
│   │   └── my_model_adapter.dart
│   ├── dataconnect/ # FirebaseDataConnect用自動生成フォルダ
│   │   └── ...
│   ├── controllers/ # `Controller`を作成する場合はここに格納
│   │   ├── upload.dart
│   │   └── upload.m.dart # 自動生成ファイル
│   ├── functions/ # `Functions`を作成する場合のDartコードはここに格納
│   │   └── func.dart
│   ├── enums/ # `Enum`を実装する場合はここに格納
│   │   ├── age.dart
│   │   └── gender.dart
│   ├── modals/ # 独自`Modal`を作成する場合はここに格納
│   │   ├── subscription.dart
│   │   └── start.dart
│   ├── models/ # `Model`を実装する場合はここに格納
│   │   ├── user.dart
│   │   ├── user.g.dart # 自動生成ファイル
│   │   ├── user.freezed.dart # 自動生成ファイル
│   │   ├── user.m.dart # 自動生成ファイル
│   │   ├── product.dart
│   │   ├── product.m.dart # 自動生成ファイル
│   │   ├── product.freezed.dart # 自動生成ファイル
│   │   └── product.m.dart # 自動生成ファイル
│   ├── pages/ # `Page`を実装する場合はここに格納
│   │   ├── profile.dart
│   │   ├── profile.page.dart # 自動生成ファイル
│   │   ├── home.dart
│   │   ├── home.page.dart # 自動生成ファイル
│   │   ├── index.dart
│   │   └── index.page.dart # 自動生成ファイル
│   ├── redirects/ # `RedirectQuery`を実装する場合はここに格納
│   │   └── login_required.dart
│   ├── widgets/ # `Page`以外の`Widget`を実装する場合はここに格納
│   │   ├── header.dart
│   │   ├── user_tile.dart
│   │   └── footer.dart
│   ├── adapter.dart # `Adapter`の定義を設定するファイル
│   ├── config.dart # その他の設定ファイル
│   ├── firebase_options.dart # Firebaseの設定ファイル（必要な場合）
│   ├── localize.dart # `Localization`の設定ファイル
│   ├── localize.localize.dart # `Localization`設定の自動生成ファイル
│   ├── theme.dart # `Theme`の設定ファイル
│   ├── theme.theme.dart # `Theme`設定の自動生成ファイル
│   ├── router.dart # `Router`の設定ファイル
│   └── main.dart # Dartのエントリポイント
├── test/ # Flutter/Dart用テストコードフォルダ
│   ├── controllers/ # `Controller`のテストはここに格納
│   │   └── upload.dart
│   ├── pages/ # `Page`のテストはここに格納
│   │   ├── profile.dart
│   │   ├── home.dart
│   │   └── index.dart
│   └── widgets/ # `Page`以外の`Widget`のテストはここに格納
│       ├── header.dart
│       ├── user_tile.dart
│       └── footer.dart
├── ...
├── requirements.md # **要件定義書**
├── katana_secrets.yaml # `Masamuneフレームワーク`で利用するセキュアな設定
├── katana.yaml # `Masamuneフレームワーク`で利用する設定
├── pubspec.yaml # Flutterの設定
├── pubspec_overrides.yaml # Flutterのローカル限定の上書き設定
└── README.md # プロジェクトのReadMe
```
""";
  }
}
