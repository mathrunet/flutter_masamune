import 'package:katana_cli/katana_cli.dart';

/// Contents of masamune.mdc.
///
/// masamune.mdcの中身。
class MasamuneDocsMdcCliAiCode extends CliAiCode {
  /// Contents of masamune.mdc.
  ///
  /// masamune.mdcの中身。
  const MasamuneDocsMdcCliAiCode();

  @override
  String get name => "Masamuneフレームワーク";

  @override
  String get description => "Masamuneフレームワークの利用方法";

  @override
  String get globs =>
      "lib/**/*.dart, test/**/*.dart, katana.yaml, documents/designs/**/*.md, firebase/functions/src/**/*.ts, firebase/functions/test/**/*.ts";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
[katana.yaml](mdc:katana.yaml)および[pubspec.yaml](mdc:pubspec.yaml)が存在していたら`Masamuneフレームワーク`を用いた開発を必ず行う。
`Masamuneフレームワーク`では下記に示すルールを絶対遵守。ルールに記載していない内容に関してはFlutterの標準的な開発を行う。

## 技術スタック

`Masamuneフレームワーク`では下記の技術スタックを利用してアプリケーションを開発。

- デザインフレームワーク
    - [Material Design 3](https://m3.material.io/)
- アプリケーション
    - 言語フレームワーク
        - [Dart / Flutter](https://docs.flutter.dev/)
    - メインフレームワークパッケージ
        - [Masamune](https://pub.dev/documentation/masamune/latest/)
    - その他使用パッケージ
        - [freezed](https://pub.dev/packages/freezed)
        - [json_serializable](https://pub.dev/packages/json_serializable)
        - [build_runner](https://pub.dev/packages/build_runner)
- バックエンド
    - データベース
        - [Firestore (NoSQL)](https://firebase.google.com/docs/firestore)
        - [Firebase Data Connect（PostgreSQL）](https://firebase.google.com/docs/data-connect)
    - 認証
        - [Firebase Authentication](https://firebase.google.com/docs/auth)
    - ファイルストレージ
        - [Cloud Storage for Firebase](https://firebase.google.com/docs/storage)
    - ホスティングサービス
        - [Firebase Hosting](https://firebase.google.com/docs/hosting)
    - API
        - [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
        - [TypeScript / NodeJS](https://www.typescriptlang.org/docs/)
    - スケジューラー
        - [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
        - [TypeScript / NodeJS](https://www.typescriptlang.org/docs/)
    - PUSH通知
        - [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
    - アプリ解析
        - [Firebase Analytics](https://firebase.google.com/docs/analytics)


## 構成要素

`Masamuneフレームワーク`では下記の構成要素を利用してアプリケーションを開発。

- `App`
    - アプリケーションそのものを指す。
- `Model`
    - データモデル。複数の`DataField`の集合体。Firestoreでは`Document`に値する。複数の`Model`の集合体を`Collection`と呼ぶ。
- `Page`
    - 画面。複数の`Widget`から構成される。
- `Widget`
    - 画面の最小単位。FlutterのWidgetと同義。
- `Modal`
    - モーダル。画面の上に表示されるダイアログやモーダルウィンドウのことを指す。
- `Controller`
    - コントローラー。異なる`Page`間でデータを保持したり、アプリ内の操作を管理する。
- `State`
    - アプリケーションの中で保持されている状態。`Page`や`Widget`、`Modal`、`Controller`や`RedirectQuery`内で利用される。状態は`Controller`や`Model`、`Plugin`が管理するもののみではなく、`ValueNotifier`を通して変数等を利用することも可能。
- `Theme`
    - テーマ。アプリケーションのデザインを定義。
- `Plugin`
    - プラグイン。アプリケーション内で利用するための様々な機能をパッケージとして提供。
- `MetaData`
    - メタデータ。`App`に関する情報を管理。
- `Enum`
    - 列挙型。有限の値の集合を定義。
- `Adapter`
    - アダプター。異なるデータベースやAPIとの接続を管理。
- `RedirectQuery`
    - リダイレクト管理。`Page`を表示する前に条件分岐を行い別の`Page`にリダイレクトが可能。
- `Localization`
    - 多言語対応。アプリケーション内で利用するテキストを各国の言語に対応させる。
- `Router`
    - ルーティング。`Page`間の遷移を管理。


## ドキュメント

`Masamuneフレームワーク`では下記のドキュメントを生成しながら開発を行う。

- **要件定義書**
    - アプリケーションの要件を定義。
- **Model設計書**
    - `Model`の設計を定義。
- **Theme設計書**
    - `Theme`の設計を定義。
- **Plugin設計書**
    - `Plugin`の設計を定義。
- **Controller設計書**
    - `Controller`の設計を定義。
- **Page設計書**
    - `Page`の設計を定義。
- **MetaData設計書**
    - `MetaData`の設計を定義。


## プロジェクトフォルダ・ファイル構成

`Masamuneフレームワーク`では下記のフォルダ・ファイル構成でプロジェクトを作成。

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

## 命名規則

`Masamuneフレームワーク`では下記の命名規則を利用して開発を行う。

- 変数名
    - CamelCaseで記載。
    - 例：`userId`
- クラス名
    - PascalCaseで記載。
    - 例：`UserModel`
- メソッド名
    - CamelCaseで記載。
    - 例：`getUser`
- 定数名
    - 先頭にに`k`を付与しCamelCaseで記載。
    - 例：`kUserId`
- `Model`のクラス名
    - 末尾に`Model`を付与しPascalCaseで記載。
    - 例：`UserModel`
- `Model`のファイル名
    - `Model`のクラス名（末尾に`Model`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_.dart`
- `Model`のデータフィールド名
    - CamelCaseで記載。
    - 例：`userId`
- `Page`のクラス名
    - 末尾に`Page`を付与しPascalCaseで記載。
    - 例：`UserPage`
- `Page`のファイル名
    - `Page`のクラス名（末尾に`Page`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Widget`のクラス名
    - 末尾に`Widget`を付与しPascalCaseで記載。
    - 例：`UserTileWidget`
- `Widget`のファイル名
    - `Widget`のクラス名（末尾に`Widget`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_tile.dart`
- `Modal`のクラス名
    - 末尾に`Modal`を付与しPascalCaseで記載。
    - 例：`UserModal`
- `Modal`のファイル名
    - `Modal`のクラス名（末尾に`Modal`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Controller`のクラス名
    - 末尾に`Controller`を付与しPascalCaseで記載。
    - 例：`UserController`
- `Controller`のファイル名
    - `Controller`のクラス名（末尾に`Controller`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Enum`のクラス名
    - 末尾に`Enum`を付与しPascalCaseで記載。
    - 例：`UserStatusEnum`
- `Enum`のファイル名
    - `Enum`のクラス名（末尾に`Enum`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_status.dart`
- `Adapter`のクラス名
    - 末尾に`Adapter`を付与しPascalCaseで記載。
    - 例：`UserAdapter`
- `Adapter`のファイル名
    - `Adapter`のクラス名（末尾に`Adapter`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `RedirectQuery`のクラス名
    - 末尾に`RedirectQuery`を付与しPascalCaseで記載。
    - 例：`LoginRequiredRedirectQuery`
- `RedirectQuery`のファイル名
    - `RedirectQuery`のクラス名（末尾に`RedirectQuery`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`login_required.dart`


## Masamuneフレームワークの実装・利用方法

### `Model`の実装方法

- [`Model`の実装方法](mdc:.cursor/rules/docs/model_usage.mdc)

### `Modal`の実装方法

- [`Modal`の実装方法](mdc:.cursor/rules/docs/modal_usage.mdc)

### `State`の利用方法

- [`State`の利用方法](mdc:.cursor/rules/docs/state_management_usage.mdc)

### `Router`の利用方法

- [`Router`の利用方法](mdc:.cursor/rules/docs/router_usage.mdc)

### `Theme`の利用方法

- [`Theme`の利用方法](mdc:.cursor/rules/docs/theme_usage.mdc)


## リファレンス

### 実行可能なkatanaコマンド

- [katanaコマンド](mdc:.cursor/rules/docs/katana_cli.mdc)

### `ModelFieldValue`の利用方法

- [`ModelFieldValue`の利用方法](mdc:.cursor/rules/docs/model_field_value_usage.mdc)

### `UniversalUI`の利用方法

- [`UniversalUI`の利用方法](mdc:.cursor/rules/docs/universal_ui_usage.mdc)

### `KatanaUI`の利用方法

- [`KatanaUI`の利用方法](mdc:.cursor/rules/docs/katana_ui_usage.mdc)
""";
  }
}
