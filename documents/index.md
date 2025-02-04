# Masamuneフレームワーク

## コンセプト

<aside>
💡

CLIによるコードの自動生成とbuild_runnerによるコードの自動生成により実装の高速化と安定化を目指すフレームワーク

</aside>

## 特徴

- 独自CLIを用いてプロジェクトの作成、アプリケーションやバックエンドも含めたコードの生成、バックエンドのデプロイ、各種プラグインの設定、CICDの設定等が行える。
- 主にAndroid/IOSのモバイルアプリケーションの開発に利用可能。ただしWebやDesktop（Windows、MacOS）の開発も可能。
- アプリケーション側だけでなくバックエンド側も同一プロジェクトにて開発可能。
- CRUD（Create、Read、Update、Delete）アプリであれば、モデルの定義とUIの作成のみでアプリケーション開発が完了する。
- アダプターを切り替えることでテストの実施やモックアプリの開発が容易になる。

## 技術スタック

- デザインフレームワーク
    - [Material Design 3](https://m3.material.io/)
- アプリケーション
    - 言語フレームワーク
        - [Dart / Flutter](https://docs.flutter.dev/)
    - 使用外部パッケージ
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

# ガイドライン

## 制約事項

### 全体

- デザインはMaterial Design 3のガイドラインに沿って設計する。
    - Material Design 3に沿ったコンポーネントをFlutterのウィジェットから選択しそれを利用する。
- 開発技術は基本的に上記のMasamuneフレームワークの技術スタックを用いて決定する。
    - この技術スタックにて実現できない場合はその他のサービスの利用を検討する。

### アプリケーション(Flutter/Dart)

- katana_cliで生成できるコードの種類の場合必ずkatana_cliにてコードを生成してから実装を始める
- Dart部分の開発に関しては実装を完了する前に下記を実行し自動生成の再実施を行う。
    
    ```bash
    katana code generate 
    ```
    
- `*.g.dart`、`*.freezed.dart`、`*.m.dart`、`*.page.dart`、`*.localize.dart`、`*.theme.dart`、`lib/dataconnect/**/*`に関しては自動生成ファイルなので絶対に編集しない。編集する場合は下記のコマンドで自動生成を再実施する。
    
    ```bash
    katana code generate
    ```
    
- Gitにコミットする前に下記を実行しコードの品質を保つ
    
    ```bash
    dart format .
    flutter analyze
    ```
    

### バックエンド(Firebase)

- CloudFunctions for Firebaseでは、基本的には`@mathrunet/masamune`のパッケージに含まれている関数を利用する
    - 関数の追加は`firebase/functions/src/index.ts`にて行う。
        - katana_cliで自動追加される場合もある。
    - このパッケージに含まれていない関数を利用する場合のみkatana_cliでコードを生成してから実装を始める。
        - `firebase/functions/src/functions`内にコードが生成される。
- Gitにコミットする前に下記を実行しコードの品質を保つ（`firebase/functions`に移動してから実行）
    
    ```bash
    npm run lint
    ```
    
- Firebaseのデプロイは可能な限り個別デプロイで行う（`firebase`に移動してから実行）
    
    ```bash
    firebase deploy --only functions # CloudFunctions for Firebaseのデプロイ
    firebase deploy --only hosting # Firebase Hostingのデプロイ
    ```
    

## プロジェクトフォルダ構成

```bash
/
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
│   │   ├── model_design.md # **データモデル設計書**
│   │   ├── theme_design.md # テーマ設計書
│   │   ├── plugin_design.md # プラグイン設計書
│   │   ├── controller_design.md # コントローラー設計書
│   │   └── screen_design.md # 画面設計書
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
│   ├── adapters/ # 各種独自アダプターを作成する場合はここに格納
│   │   └── my_model_adapter.dart
│   ├── dataconnect/ # FirebaseDataConnect用自動生成フォルダ
│   │   └── ...
│   ├── controllers/ # コントローラーを作成する場合はここに格納
│   │   ├── upload.dart
│   │   └── upload.m.dart # 自動生成ファイル
│   ├── enums/ # Enumを実装する場合はここに格納
│   │   ├── age.dart
│   │   └── gender.dart
│   ├── modals/ # 独自モーダルを作成する場合はここに格納
│   │   ├── subscription.dart
│   │   └── start.dart
│   ├── models/ # モデルを実装する場合はここに格納
│   │   ├── user.dart
│   │   ├── user.g.dart # 自動生成ファイル
│   │   ├── user.freezed.dart # 自動生成ファイル
│   │   ├── user.m.dart # 自動生成ファイル
│   │   ├── product.dart
│   │   ├── product.m.dart # 自動生成ファイル
│   │   ├── product.freezed.dart # 自動生成ファイル
│   │   └── product.m.dart # 自動生成ファイル
│   ├── pages/ # ページを実装する場合はここに格納
│   │   ├── profile.dart
│   │   ├── profile.page.dart # 自動生成ファイル
│   │   ├── home.dart
│   │   ├── home.page.dart # 自動生成ファイル
│   │   ├── index.dart
│   │   └── index.page.dart # 自動生成ファイル
│   ├── redirects/ # RedirectQueryを実装する場合はここに格納
│   │   └── login_required.dart
│   ├── widgets/ # ページ以外のUIコンポーネントを実装する場合はここに格納
│   │   ├── header.dart
│   │   ├── user_tile.dart
│   │   └── footer.dart
│   ├── adapter.dart # アダプターの定義を設定するファイル
│   ├── config.dart # その他の設定ファイル
│   ├── firebase_options.dart # Firebaseの設定ファイル（必要な場合）
│   ├── localize.dart # 翻訳の設定ファイル
│   ├── localize.localize.dart # 翻訳設定の自動生成ファイル
│   ├── theme.dart # デザインテーマの設定ファイル
│   ├── theme.theme.dart # デザインテーマ設定の自動生成ファイル
│   ├── router.dart # ルーティングの設定ファイル
│   └── main.dart # Dartのエントリポイント
├── test/ # Flutter/Dart用テストコードフォルダ
│   ├── controllers/ # コントローラーのテストはここに格納
│   │   └── upload.dart
│   ├── pages/ # ページのテストはここに格納
│   │   ├── profile.dart
│   │   ├── home.dart
│   │   └── index.dart
│   └── widgets/ # ページ以外のUIコンポーネントのテストはここに格納
│       ├── header.dart
│       ├── user_tile.dart
│       └── footer.dart
├── ...
├── requirements.md # アプリケーションの要件定義書
├── katana_secrets.yaml # Masamuneフレームワークで利用する設定でセキュアなもの
├── katana.yaml # Masamuneフレームワークで利用する設定
├── pubspec.yaml # Futterの設定
├── pubspec_overrides.yaml # Futterのローカル限定の上書き設定
└── README.md # ReadMe
```

# 開発フロー

## 前提条件

前提条件として下記が提供されているものとする。（提供されていない場合関係各所に依頼）

- `Applicatioon ID`（リバースドメインで記述されたもの）
- `要件定義`（画面ごとに大まかなアクションが定義されたもの）`requirements.md`にファイルとして配置済み。
- 【任意】`アプリケーション名`
    - 提供されない場合は`要件定義`にマッチしているアプリケーション名を10文字以内で自動生成
- 【任意】`対応プラットフォーム`（Android、IOS、Web等）
    - 提供されない場合はAndroidとIOSに対応
- 【任意】`外部データベースを利用するかどうか`（もしくはデータの永続化をするかどうか）
    - 提供されない場合は`要件定義`に応じて決定
- 【任意】`アプリケーションで使用する色`（ダークモードとライトモード、PrimaryColor、SecondaryColor、TertiaryColor）
    - 提供されない場合は`要件定義`にマッチしている配色を決定
- 【任意】`対応言語`（日本語、英語、中国語等）
    - 提供されない場合は日本語のみに対応
- 【任意】`アプリケーションのアイコンやロゴ`
- 【任意】`使用するフォント`

## 事前準備

1. **プロジェクトの作成**
    - プロジェクトのルートフォルダ（`/`）で下記コマンドを実行。
        
        ```bash
        		katana create [Application ID(e.g. com.test.myapplication)] -a
        ```
        
    - `-a`オプションを付与し`katana.yaml`ですべての設定を可能にする。
2. **アセットの格納**
    - `アプリケーションのアイコンやロゴ`、その他のアセットが提供されている場合`assets/`フォルダ以下に格納。
    - `assets/`以下に新規にフォルダを作った場合は`pubspec.yaml`にフォルダを認識できるように書き換え。
    - 格納後下記のコマンドを実行しコード生成
        
        ```bash
        katana code generate
        ```
        
3. **フォントの格納**
    - フォントが提供されている場合`fonts/`フォルダ以下に格納。
    - `pubspec.yaml`をフォントが対応できるように書き換え。
    - 格納後下記のコマンドを実行しコード生成
        
        ```bash
        katana code generate
        ```
        
4. **アプリケーションタイトルの実装**
    - アプリケーション名が提供されている場合`config.dart`の下記の部分を書き換え。
        
        ```dart
        /// App Title.
        const title = "[アプリケーション名]";
        ```
        

## 設計

1. **画面設計**
    1. `requirements.md`に記載されている`要件定義`から`画面設計書`を作成
        1. `要件定義`から画面ごとの要素に分割し`画面設計`を作成
            - 各画面に対する`画面ID`と`画面パス`、`概要`を作成
            - `概要`に各画面における`画面構成要素`と各構成要素に対する`アクション`を細かく記載
            - `画面パス`はURLと同じように定義
                - e.g. `memo/edit/:memo_id`
                - `/`で階層を記述。
                - 空の名前の階層は作らない（`//`といった記述はない）
                    - ただしトップページのみ空の階層を許可
                - 先頭および末尾に`/`は記述しない。
                - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `memo/edit/:memo_id`の場合は`memo_id`が変数）
            - 例：
                - [画面設計](https://www.notion.so/18f21e342b5480edb09bd8c78952b868?pvs=21)
                    
                    
                    ## メモ一覧画面
                    
                    ### 画面ID
                    
                    `memo`
                    
                    ### 画面パス
                    
                    ### 概要
                    
                    - 起動時に表示
                    - AppBarにアプリタイトルを表示
                    - 登録されているメモの一覧をリスト表示
                        - 各要素にはメモのタイトル、作成者、作成日時、更新日時、タグを表示
                        - 各要素をタップすると`メモ詳細画面`に遷移
                    - FloatingActionButtonに「新規」ボタンを表示。タップすると`メモ新規作成画面`に遷移
                    
                    ## メモ詳細画面
                    
                    ### 画面ID
                    
                    `memo_detail`
                    
                    ### 画面パス
                    
                    `memo/:memo_id`
                    
                    ### 概要
                    
                    - AppBarにメモのタイトルを表示
                    - 上部にメモの作成者、作成日時、更新日時、タグを表示
                    - その下にメモのコンテンツを表示
                    - メモのコンテンツの下に添付画像があれば表示
                    - AppBarのactionsに編集用のボタンを表示。タップすると`メモ編集画面`に遷移
                    
                    ## メモ新規作成画面
                    
                    ### 画面ID
                    
                    `memo_edit_new`
                    
                    ### 画面パス
                    
                    `memo/edit/new`
                    
                    ### 概要
                    
                    - AppBarに「新規作成」と表示
                    - 下記のフォームを表示
                        - タイトル（テキスト入力）
                        - 作成者（ユーザー一覧から選択）
                        - タグ（タグ入力）
                        - コンテンツ（マルチラインテキスト入力）
                        - 添付画像（マルチメディア入力）
                    - AppBarのactionsに編集確定ボタンを表示。タップするとメモが作成される
                    
                    ## メモ編集画面
                    
                    ### 画面ID
                    
                    `memo_edit`
                    
                    ### 画面パス
                    
                    `memo/edit/:memo_id`
                    
                    ### 概要
                    
                    - AppBarに「[メモのタイトル]の編集」と表示
                    - 下記のフォームを表示し各要素に既存のデータを入力済みにする
                        - タイトル（テキスト入力）
                        - 作成者（ユーザー一覧から選択）
                        - タグ（タグ入力）
                        - コンテンツ（マルチラインテキスト入力）
                        - 添付画像（マルチメディア入力）
                    - AppBarのactionsに編集確定ボタンを表示。タップするとメモが更新される
                    - AppBarのactionsに削除ボタンを表示。タップすると確認ダイアログ表示の後メモを削除
                - [画面設計](https://www.notion.so/18f21e342b548042b0afea638ad171ff?pvs=21)
        2. `画面設計`をドキュメントに落とし込む
            - `documents/designs/screen_design.md`にマークダウン記法で記載
            - 例：
                - [画面設計書](https://www.notion.so/18f21e342b5480ca88e8cdd0b3949ab0?pvs=21)
                    
                    
                    ```markdown
                    <!-- documents/designs/screen_design.md -->
                    
                    ## メモ一覧画面
                    
                    ### 画面ID
                    
                    `memo`
                    
                    ### 画面パス
                    
                    ### 概要
                    
                    - 起動時に表示
                    - AppBarにアプリタイトルを表示
                    - 登録されているメモの一覧をリスト表示
                        - 各要素にはメモのタイトル、作成者、作成日時、更新日時、タグを表示
                        - 各要素をタップすると`メモ詳細画面`に遷移
                    - FloatingActionButtonに「新規」ボタンを表示。タップすると`メモ新規作成画面`に遷移
                    
                    ## メモ詳細画面
                    
                    ### 画面ID
                    
                    `memo_detail`
                    
                    ### 画面パス
                    
                    `memo/:memo_id`
                    
                    ### 概要
                    
                    - AppBarにメモのタイトルを表示
                    - 上部にメモの作成者、作成日時、更新日時、タグを表示
                    - その下にメモのコンテンツを表示
                    - メモのコンテンツの下に添付画像があれば表示
                    - AppBarのactionsに編集用のボタンを表示。タップすると`メモ編集画面`に遷移
                    
                    ## メモ新規作成画面
                    
                    ### 画面ID
                    
                    `memo_edit_new`
                    
                    ### 画面パス
                    
                    `memo/edit/new`
                    
                    ### 概要
                    
                    - AppBarに「新規作成」と表示
                    - 下記のフォームを表示
                        - タイトル（テキスト入力）
                        - 作成者（ユーザー一覧から選択）
                        - タグ（タグ入力）
                        - コンテンツ（マルチラインテキスト入力）
                        - 添付画像（マルチメディア入力）
                    - AppBarのactionsに編集確定ボタンを表示。タップするとメモが作成される
                    
                    ## メモ編集画面
                    
                    ### 画面ID
                    
                    `memo_edit`
                    
                    ### 画面パス
                    
                    `memo/edit/:memo_id`
                    
                    ### 概要
                    
                    - AppBarに「[メモのタイトル]の編集」と表示
                    - 下記のフォームを表示し各要素に既存のデータを入力済みにする
                        - タイトル（テキスト入力）
                        - 作成者（ユーザー一覧から選択）
                        - タグ（タグ入力）
                        - コンテンツ（マルチラインテキスト入力）
                        - 添付画像（マルチメディア入力）
                    - AppBarのactionsに編集確定ボタンを表示。タップするとメモが更新される
                    - AppBarのactionsに削除ボタンを表示。タップすると確認ダイアログ表示の後メモを削除
                    ```
                    
                - [画面設計書](https://www.notion.so/18f21e342b5480b39687f93a1699960a?pvs=21)
2. **データモデル設計**
    1. `documents/designs/screen_design.md`に記載されている`画面設計`から`データモデル`を設計
        - データ構成の考え方はFirestoreの設計に近いのでそちらを前提知識として持っておく
            
            [Cloud Firestore Data model  |  Firebase](https://firebase.google.com/docs/firestore/data-model)
            
        - データモデルに対する`モデル名`と`モデルパス`、`概要`を作成
            - モデル名は`〇〇Model`といった形で末尾にModelを付与しPascalCaseで定義
            - `モデルパス`はFirestoreの`コレクションパス`、`ドキュメントパス`と同じように定義
                - e.g. `user/:user_id/friends`
                - `/`で階層を記述。
                - 空の名前の階層は作らない（`//`といった記述はない）
                - 先頭および末尾に`/`は記述しない。
                - 奇数階層だとコレクションとして複数のドキュメントを取り扱う。（e.g. `user/:user_id/friends`）
                - 偶数階層だとドキュメントとして１つのドキュメントのみを取り扱う。（e.g. `apps/setting`）
                - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `user/:user_id/friends`の場合は`user_id`が変数）
                - データ構造として**とある要素が持つ要素**がある場合、その要素は親要素の下階層に入れる。さらにその時親要素のドキュメントIDが間に入る。
                    - ユーザーのデータとユーザーが持つフレンドという構成要素がある場合、`user`というコレクションと各`user`ドキュメントのID（`user_id`）を親に持つ`user/:user_id/friends`というコレクションを作成
        - 例：
            - [データモデル設計](https://www.notion.so/18f21e342b5480178543d985d50e222a?pvs=21)
                
                
                ## メモ
                
                ### モデル名
                
                `MemoModel`
                
                ### モデルパス
                
                `memo`
                
                ### 概要
                
                実際のメモの内容を保存するデータ一覧
                
                ## ユーザー
                
                ### モデル名
                
                `UserModel`
                
                ### モデルパス
                
                `user`
                
                ### 概要
                
                メモの作成者を保存するデータ一覧。アプリ内に埋め込む予定。
                
                ## タグ
                
                ### モデル名
                
                `TagModel`
                
                ### モデルパス
                
                `tag`
                
                ### 概要
                
                メモに付与されるタグの一覧を保存するデータ一覧
                
            - [データモデル設計](https://www.notion.so/18f21e342b5480ca8b21e96dc7e7ad0e?pvs=21)
    2. `データモデル`からどのような`データフィールド`が必要かを設計
        - 各データには必須かどうかおよび必須でない場合のデフォルト値（なくてもよい）を合わせて定義する。
        - 例：
            - [データモデル設計](https://www.notion.so/18f21e342b5480178543d985d50e222a?pvs=21)
                
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | タイトル | `title` | String | 必須 |  | メモのタイトル |
                | コンテンツ | `content` | String | 必須 |  | メモの内容 |
                | 添付画像 | `images` | List<ModelImageUri> | 任意 | [] | メモの添付画像（複数可） |
                | 作成者 | `createdBy` | ModelRef<UserModel> | 必須 |  | メモの作成者。UserModelに紐づけ。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが更新された日時。 |
                | タグ | `tags` | List<ModelRef<UserModel>> | 任意 | [] | メモに付与されたタグ。TagModelを複数紐づけ。 |
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | 名前 | `name` | String | 必須 |  | ユーザー名。 |
                | 自己紹介 | `introduction` | String | 任意 |  | ユーザーの自己紹介文。 |
                | アイコン | `icon` | ModelImageUri | 任意 |  | ユーザーアイコンの画像URL。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが更新された日時。 |
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | タグ名 | `name` | String | 必須 |  | タグ名。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが更新された日時。 |
            - [データモデル設計](https://www.notion.so/18f21e342b5480ca8b21e96dc7e7ad0e?pvs=21)
        - `データフィールド`の`タイプ`は下記の表から適切なものを選ぶ
            
            
            | タイプ | 概要 |
            | --- | --- |
            | `String` | 文字列。 |
            | `int` | 整数。 |
            | `double` | 小数。 |
            | `bool` | 真偽値。 |
            | `enum` | 列挙体。`katana code enum xxxx`でコードを出力した後`enum XxxEnum {}`にて定義された列挙体名が入る。選択肢が限られている場合はこちらを優先して利用。 |
            | `List<[タイプ]>` | タイプを配列として複数持ちたい場合に利用。[タイプ]にはListも含めたその他タイプが入る。 |
            | `Map<String, [タイプ]>` | タイプを連想配列として複数持ちたい場合に利用。キーには必ず`String`が入り[タイプ]にはMapも含めたその他タイプが入る。 |
            | `Set<[タイプ]>` | タイプを重複禁止の配列として複数持ちたい場合に利用。[タイプ]にはSetも含めたその他タイプが入る。 |
            | `ModelRef<[モデル名]>` | 他モデルへの参照を行いたい場合はそのモデル名を指定して定義。 |
            | `ModelCounter` | カウントアップ、カウントダウンを正確に行いたい場合の整数を定義する際に優先して利用。 |
            | `ModelTimestamp` | 日時を定義する際に優先して利用。 |
            | `ModelDate` | 日付のみを定義する際に優先して利用。 |
            | `ModelUri` | 画像や映像以外のURLやURIを保存する際に優先して利用。 |
            | `ModelImageUri` | 画像のURLやURIを保存する際に優先して利用。 |
            | `ModelVideoUri` | 映像のURLやURIを保存する際に優先して利用。 |
            | `ModelGeoValue` | 位置情報（緯度、経度）を保存する際に優先して利用。 |
            | `ModelLocale` | ロケール（`ja_JP`、`en_US`等）を保存する際に優先して利用。 |
            | `ModelLocalizedValue` | 各ロケールに対応した文字列を保存する際に利用。 |
            | `ModelSearch` | 検索対象となる文字列のリストを保存する際に利用。 |
            | `ModelToken` | Push通知のトークンなど複数トークンを保存する際に優先して利用。 |
    3. `データモデル設計`をドキュメントに落とし込む
        - `documents/designs/model_design.md`にマークダウン記法で記載
        - 例：
            - [データモデル設計書](https://www.notion.so/18f21e342b548069b075f0b207d8d214?pvs=21)
                
                
                ```markdown
                <!-- documents/designs/model_design.md -->
                
                ## メモ
                
                ### モデル名
                
                `MemoModel`
                
                ### モデルパス
                
                `memo`
                
                ### 概要
                
                実際のメモの内容を保存するデータ一覧
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | タイトル | `title` | String | 必須 |  | メモのタイトル |
                | コンテンツ | `content` | String | 必須 |  | メモの内容 |
                | 添付画像 | `images` | List<ModelImageUri> | 任意 | [] | メモの添付画像（複数可） |
                | 作成者 | `createdBy` | ModelRef<UserModel> | 必須 |  | メモの作成者。UserModelに紐づけ。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが更新された日時。 |
                | タグ | `tags` | List<ModelRef<UserModel>> | 任意 | [] | メモに付与されたタグ。TagModelを複数紐づけ。 |
                
                ## ユーザー
                
                ### モデル名
                
                `UserModel`
                
                ### モデルパス
                
                `user`
                
                ### 概要
                
                メモの作成者を保存するデータ一覧。アプリ内に埋め込む予定。
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | 名前 | `name` | String | 必須 |  | ユーザー名。 |
                | 自己紹介 | `introduction` | String | 任意 |  | ユーザーの自己紹介文。 |
                | アイコン | `icon` | ModelImageUri | 任意 |  | ユーザーアイコンの画像URL。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが更新された日時。 |
                
                ## タグ
                
                ### モデル名
                
                `TagModel`
                
                ### モデルパス
                
                `tag`
                
                ### 概要
                
                メモに付与されるタグの一覧を保存するデータ一覧
                
                ### フィールド
                
                | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
                | --- | --- | --- | --- | --- | --- |
                | タグ名 | `name` | String | 必須 |  | タグ名。 |
                | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが作成された日時。 |
                | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが更新された日時。 |
                ```
                
            - [データモデル設計書](https://www.notion.so/18f21e342b54809180ccc18951fb2708?pvs=21)
    4. `データモデル設計`をそれぞれコードに落とし込む
        1. 下記コマンドでデータモデルを作成
            - 複数データを保つ場合
                
                ```bash
                katana code collection [データモデル名]
                ```
                
            - １つのみデータを保つ場合
                
                ```bash
                katana code document [データモデル名]
                ```
                
            - 例：
                - [データモデル生成コマンド](https://www.notion.so/18f21e342b5480e5a364dc195130b347?pvs=21)
                    
                    
                    ```bash
                    katana code collection memo
                    katana code collection user
                    katana code collection tag
                    ```
                    
                - [データモデル生成コマンド](https://www.notion.so/18f21e342b5480eea8fbf843dba369b2?pvs=21)
        2. コマンド実行後、`lib/models`以下に`[データモデル名].dart`ファイルが作成される
            1. コード中の`@CollectionModelPath`（ドキュメント作成時は`@DocumentModelPath`）のAnnotationに対応する`モデルパス`を記載。
            2. そのコード中の`// TODO: Set the data fields.`以下に定義した`データフィールド`を追記。
                - 各フィールドには`タイプ`と`フィールド名`（CamelCase）を記載。
                    - フィールドが必須の場合はタイプの前に`required`を付与。
                    - 任意でかつデフォルト値が存在する場合は`@Default([デフォルト値])`のAnnotationを付与。
                    - 任意でかつデフォルト値が存在しない場合はタイプの末尾に`?`を付与しNullableにする
            - 例：
                - [データモデル実装](https://www.notion.so/18f21e342b5480e7bde3c7eaf4652e94?pvs=21)
                    
                    
                    ### メモ（MemoModel）
                    
                    ```dart
                    // lib/models/memo.dart
                    
                    /// Value for model.
                    @freezed
                    @formValue
                    @immutable
                    @CollectionModelPath("memo")
                    class MemoModel with _$MemoModel {
                      const factory MemoModel({
                         // TODO: Set the data fields.
                         required String title,
                         required String content,
                         @Default([]) List<ModelImageUri> images,
                         required ModelRef<UserModel> createdBy,
                         @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
                         @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
                         @Default([]) List<ModelRef<TagModel>> tags,
                      }) = _MemoModel;
                      
                      ~~~~~
                    }
                    ```
                    
                    ### ユーザー（UserModel）
                    
                    ```dart
                    // lib/models/user.dart
                    
                    /// Value for model.
                    @freezed
                    @formValue
                    @immutable
                    @CollectionModelPath("user")
                    class UserModel with _$UserModel {
                      const factory UserModel({
                         // TODO: Set the data fields.
                         required String name,
                         String? introduction,
                         ModelImageUri? icon,
                         @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
                         @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
                      }) = _UserModel;
                      
                      ~~~~~
                    }
                    ```
                    
                    ### タグ（TagModel）
                    
                    ```dart
                    // lib/models/tag.dart
                    
                    /// Value for model.
                    @freezed
                    @formValue
                    @immutable
                    @CollectionModelPath("tag")
                    class TagModel with _$TagModel {
                      const factory TagModel({
                         // TODO: Set the data fields.
                         required String name,
                         @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
                         @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
                      }) = _TagModel;
                      
                      ~~~~~
                    }
                    ```
                    
                - [データモデル実装](https://www.notion.so/18f21e342b548007a0b8eb2fe8ed593f?pvs=21)
        3. 下記コマンドを実行して`データモデル`関連の残りのコードを自動生成する
            
            ```bash
            katana code generate
            ```
            
3. **テーマ設計**
    1. `requirements.md`に記載されている`要件定義`から`カラーモード`を設定
        - 黒背景の場合は`ダークモード`のみ
        - 白背景の場合は`ライトモード`のみ。
        - どちらにも対応する場合は`システム設定依存`にすることも可能。
    2. `requirements.md`に記載されている`要件定義`、および決定した`カラーモード`から`カラースキーム`を設定
        - カラースキームの種類は下記に定義
            
            
            | カラー | 概要 |
            | --- | --- |
            | `background` | 背景色。`ダークモード`の場合は、`0xFF212121`。`ライトモード`の場合は、`0xFFF7F7F7`。`システム設定依存`の場合は設定しない。 |
            | `onBackground` | 背景色の上に表示する文字やアイコン色。`ダークモード`の場合は、`0xFFF7F7F7`。`ライトモード`の場合は、`0xFF212121`。`システム設定依存`の場合は設定しない。 |
            | `primary` | メインカラー。 |
            | `onPrimary` | メインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `secondary` | ２番目のメインカラー。 |
            | `onSecondary` | ２番目のメインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `tertiary` | ３番目のメインカラー。 |
            | `onTertiary` | ３番目のメインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `disabled` | 非アクティブな要素の文字やアイコン色、背景色。通常は`0xFF9E9E9E`。 |
            | `onDisabled` | 非アクティブな要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `weak` | 通常の文字よりも主張が弱い要素の文字やアイコン色、背景色。通常は`0xFF9E9E9E`。 |
            | `onWeak` | 通常の文字よりも主張が弱い要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `outline` | ボックスの外枠や区切り線で利用する色。通常は`0xFF9E9E9E`。 |
            | `error` | エラーや警告の要素の文字やアイコン色、背景色。通常は`0xFFF44336`。 |
            | `onError` | エラーや警告の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `warning` | `error`よりも重要度が薄い注意の要素の文字やアイコン色、背景色。通常は`0xFFFFC107`。 |
            | `onWarning` | `error`よりも重要度が薄い注意の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `info` | `warning`よりもさらに重要度が薄い通知の要素の文字やアイコン色、背景色。通常は`0xFF2196F3`。 |
            | `onInfo` | `warning`よりもさらに重要度が薄い通知の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `success` | 成功や完了を通知する要素の文字やアイコン色、背景色。通常は`0xFF4CAF50`。 |
            | `onSuccess` | 成功や完了を通知する要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
            | `surface` | モーダルの背景色。`ダークモード`の場合は、`0xFF474747`。`ライトモード`の場合は、`0xFFE7E7E7`。`システム設定依存`の場合は設定しない。 |
            | `onSurface` | モーダルの背景色の上に表示する文字やアイコン色。`ダークモード`の場合は、`0xFFF7F7F7`。`ライトモード`の場合は、`0xFF212121`。`システム設定依存`の場合は設定しない。 |
        - 例：
            - [テーマ設計](https://www.notion.so/18f21e342b54806f85cdec4b676b44bc?pvs=21)
                
                
                ## カラーモード
                
                `ダークモード`
                
                ## カラースキーム
                
                | カラー | カラーコード |
                | --- | --- |
                | `background` | 0xFF212121 |
                | `onBackground` | 0xFFF7F7F7 |
                | `primary` | 0xFF2196F3 |
                | `onPrimary` | 0xFFF7F7F7 |
                | `secondary` | 0xFF00BCD4 |
                | `onSecondary` | 0xFFF7F7F7 |
                | `tertiary` | 0xFF4CAF50 |
                | `onTertiary` | 0xFFF7F7F7 |
                | `disabled` | 0xFF9E9E9E |
                | `onDisabled` | 0xFFF7F7F7 |
                | `weak` | 0xFF9E9E9E |
                | `onWeak` | 0xFFF7F7F7 |
                | `outline` | 0xFF9E9E9E |
                | `error` | 0xFFF44336 |
                | `onError` | 0xFFF7F7F7 |
                | `warning` | 0xFFFFC107 |
                | `onWarning` | 0xFFF7F7F7 |
                | `info` | 0xFF2196F3 |
                | `onInfo` | 0xFFF7F7F7 |
                | `success` | 0xFF4CAF50 |
                | `onSuccess` | 0xFFF7F7F7 |
                | `surface` | 0xFF474747 |
                | `onSurface` | 0xFFF7F7F7 |
            - [テーマ設計](https://www.notion.so/18f21e342b548030bb1df3757a9a736d?pvs=21)
    3. 決定した`カラーモード`および`カラースキーム`をドキュメントに落とし込む
        - `documents/designs/theme_design.md`にマークダウン記法で記載
        - 例：
            - [テーマ設計書](https://www.notion.so/18f21e342b5480f3a438c27cb94b2010?pvs=21)
                
                
                ```markdown
                <!-- documents/designs/theme_design.md -->
                
                ## カラーモード
                
                `ダークモード`
                
                ## カラースキーム
                
                | カラー | カラーコード |
                | --- | --- |
                | `background` | 0xFF212121 |
                | `onBackground` | 0xFFF7F7F7 |
                | `primary` | 0xFF2196F3 |
                | `onPrimary` | 0xFFF7F7F7 |
                | `secondary` | 0xFF00BCD4 |
                | `onSecondary` | 0xFFF7F7F7 |
                | `tertiary` | 0xFF4CAF50 |
                | `onTertiary` | 0xFFF7F7F7 |
                | `disabled` | 0xFF9E9E9E |
                | `onDisabled` | 0xFFF7F7F7 |
                | `weak` | 0xFF9E9E9E |
                | `onWeak` | 0xFFF7F7F7 |
                | `outline` | 0xFF9E9E9E |
                | `error` | 0xFFF44336 |
                | `onError` | 0xFFF7F7F7 |
                | `warning` | 0xFFFFC107 |
                | `onWarning` | 0xFFF7F7F7 |
                | `info` | 0xFF2196F3 |
                | `onInfo` | 0xFFF7F7F7 |
                | `success` | 0xFF4CAF50 |
                | `onSuccess` | 0xFFF7F7F7 |
                | `surface` | 0xFF474747 |
                | `onSurface` | 0xFFF7F7F7 |
                ```
                
            - [テーマ設計書](https://www.notion.so/18f21e342b54809b8f35deb3d67d8df2?pvs=21)
    4. 決定した`カラーモード`および`カラースキーム`をコードに落とし込む
        1. `lib/theme.dart`の`AppThemeData`を変更
            - `カラーモード`は`background`や`onBackground`、`surface`、`onSurface`に加えて`themeMode`や`brightness`、`statusBarBrightnessOnAndroid`、`statusBarBrightnessOnIOS`を設定する。カラーモードが`システム設定依存`の場合はそれらすべてを設定しないようにする。
            - 例：
                - [テーマ実装](https://www.notion.so/18f21e342b5480d6982dca8a43daa5f6?pvs=21)
                    
                    
                    ```dart
                    // lib/theme.dart
                    
                    @appTheme
                    final theme = AppThemeData(
                      background: Color(0xFF212121), // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      onBackground: Color(0xFFF7F7F7), // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      surface: Color(0xFF474747), // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      onSurface: Color(0xFFF7F7F7), // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      themeMode: ThemeMode.dark, // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      brightness: Brightness.dark, // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      statusBarBrightnessOnAndroid: Brightness.dark, // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      statusBarBrightnessOnIOS: Brightness.dark, // カラーモードをダークモードで設定。カラーモードがシステム設定依存の場合は記載しない
                      primary: Color(0xFF2196F3),
                      onPrimary: Color(0xFFF7F7F7),
                      secondary: Color(0xFF00BCD4),
                      onSecondary: Color(0xFFF7F7F7),
                      tertiary: Color(0xFF4CAF50),
                      onTertiary: Color(0xFFF7F7F7),
                      disabled: Color(0xFF9E9E9E),
                      onDisabled: Color(0xFFF7F7F7),
                      weak: Color(0xFF9E9E9E),
                      onWeak: Color(0xFFF7F7F7),
                      outline: Color(0xFF9E9E9E),
                      error: Color(0xFFF44336),
                      onError: Color(0xFFF7F7F7),
                      warning: Color(0xFFFFC107),
                      onWarning: Color(0xFFF7F7F7),
                      info: Color(0xFF2196F3),
                      onInfo: Color(0xFFF7F7F7),
                      success: Color(0xFF4CAF50),
                      onSuccess: Color(0xFFF7F7F7),
                    );
                    ```
                    
                - [テーマ実装](https://www.notion.so/18f21e342b54808b826fec5ad7c1006d?pvs=21)
4. **プラグイン設計**
    1. `documents/designs/screen_design.md`に記載されている`画面設計`においてインストールが必要なプラグインを設計
        - 該当する機能が下記に存在するかどうかをチェックし存在する場合は抽出し`プラグイン設計`としてまとめる
            
            
            | 機能 | 機能ID | 概要 | パッケージドキュメントURL |
            | --- | --- | --- | --- |
            | ファイルピッカー | `picker` | 端末内に保存されている画像や映像。カメラで撮影する画像や映像をアプリ内で取得・利用する機能 | https://pub.dev/documentation/masamune_picker/latest/ |
            | アニメーション | `animate` | アニメーションやエフェクトを利用する機能 | https://pub.dev/documentation/masamune_animate/latest/ |
            | チュートリアル | `introduction` | アプリ起動時にアプリの説明を行う機能 | https://pub.dev/documentation/masamune_introduction/latest/ |
            | カメラ | `camera` | ファイルピッカー以外でのカメラの利用する機能。写真撮影および映像撮影含む。 | https://pub.dev/documentation/masamune_camera/latest/ |
            | カレンダー | `calendar` | 月別や週別のカレンダーのUIを表示する機能 | https://pub.dev/documentation/masamune_calendar/latest/ |
            | ChatGPT | `openai` | GPTを利用した生成系AIの機能 | https://pub.dev/documentation/masamune_ai_openai/latest/ |
            | Text-To-Speech | `text_to_speech` | テキストを音声にして発話させる機能。 | https://pub.dev/documentation/masamune_text_to_speech/latest/ |
            | Speech-To-Text | `speech_to_text` | 音声認識してテキストに変換する機能。 | https://pub.dev/documentation/masamune_speech_to_text/latest/ |
            | ローカルPUSH通知 | `local_notification` | 端末内に閉じたPUSH通知機能。通知を行う日時と内容を設定して端末内で設定後、設定した日時に通知を行う。 | https://pub.dev/documentation/masamune_notification_local/latest/ |
            | 位置情報 | `location` | 端末の位置情報を取得する機能 | https://pub.dev/documentation/masamune_location/latest/ |
            | マップ表示 | `location→google_map` | 地図やマップを表示する機能 | https://pub.dev/documentation/masamune_location_google/latest/ |
            | アプリ広告 | `ads` | アプリ内に広告（Admob）を表示する機能 | https://pub.dev/documentation/masamune_ads_google/latest/ |
            | アプリ内課金 | `purchase` | GooglePlayやAppStore内で提供される課金機能。消費型、非消費型、サプスクリプションの課金アイテムを利用可能。 | https://pub.dev/documentation/masamune_purchase/latest/ |
            | Stripe決済 | `stripe` | 金額をシステム側で決定する決済やユーザー間での決済を利用する場合の機能。 | https://pub.dev/documentation/masamune_purchase_stripe/latest/ |
            | 音声通話 | `agora` | １対１および多人数での音声通話機能 | https://pub.dev/documentation/masamune_agora/latest/ |
            | ビデオ通話 | `agora` | １対１および多人数でのビデオ通話機能 | https://pub.dev/documentation/masamune_agora/latest/ |
            | 音声ストリーミング | `agora` | １対多でのリアルタイム音声ストリーミング機能 | https://pub.dev/documentation/masamune_agora/latest/ |
            | ビデオストリーミング | `agora` | １対多でのリアルタイムビデオストリーミング機能 | https://pub.dev/documentation/masamune_agora/latest/ |
            | メール送信 | `sendgrid` | メールを送信する機能 | https://pub.dev/documentation/masamune_mail/latest/ |
        - `機能ID`および`概要`を合わせて記載
        - 例：
            - [プラグイン設計](https://www.notion.so/18f21e342b5480f599e9c6db05b58971?pvs=21)
                
                
                ## ファイルピッカー
                
                ### 機能ID
                
                `picker`
                
                ### 概要
                
                端末内に保存されている画像や映像。カメラで撮影する画像や映像をアプリ内で取得・利用する機能
                
            - [プラグイン設計](https://www.notion.so/18f21e342b5480f094acfd6d4c75cabe?pvs=21)
    2. まとめた`プラグイン設計`をドキュメントに落とし込む
        - `documents/designs/plugin_design.md`にマークダウン記法で記載
        - 例：
            - [プラグイン設計書](https://www.notion.so/18f21e342b54808db27dfde64d842970?pvs=21)
                
                
                ```markdown
                <!-- documents/designs/plugin_design.md -->
                
                ## ファイルピッカー
                
                ### 機能ID
                
                `picker`
                
                ### 概要
                
                端末内に保存されている画像や映像。カメラで撮影する画像や映像をアプリ内で取得・利用する機能
                ```
                
            - [プラグイン設計書](https://www.notion.so/18f21e342b5480158497eee94c9c9e9c?pvs=21)
    3. `プラグイン設計`を元に`katana.yaml`を変更（利用しない場合は変更しない）
        - ファイルピッカー（`picker`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
              
              # Describe the settings for using the file picker.
              # Specify the permission message to use the library in IOS in [permission].
              # Please include `en`, `ja`, etc. and write the message in that language there.
              # If you want to use the camera, set [camera]->[enable] to true and specify the permission message to use the camera in [permission].
              # ファイルピッカーを利用するための設定を記述します。
              # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
              # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
              # カメラを利用する場合は[camera]->[enable]をtrueにして、[permission]にカメラを利用するための権限許可メッセージを指定して下さい。
              picker:
                enable: true # ファイルピッカーを利用する場合false -> trueに変更
                permission:
                  en: Use the library for profile images. # 利用用途を言語ごとに記載。
                  ja: プロフィール画像のためにライブラリを利用します。# 利用用途を言語ごとに記載。
                camera:
                  enable: false # カメラを利用する場合はfalse -> trueに変更
                  permission:
                    en: Use the camera for profile images. # 利用用途を言語ごとに記載。
                    ja: プロフィール画像のためにカメラを利用します。# 利用用途を言語ごとに記載。
            ```
            
        - アニメーション（`animate`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describes settings for implementing animation.
              # アニメーションを実装するための設定を記述します。
              animate:
                enable: true # アニメーションを利用する場合false -> trueに変更
            ```
            
        - チュートリアル（`introduction`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using the introductory part of the application.
              # アプリの導入部分を利用するための設定を記述します。
              introduction:
                enable: true # チュートリアルを利用する場合false -> trueに変更
            ```
            
        - カメラ（`camera`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using the camera.
              # カメラを利用するための設定を記述します。
              camera:
                enable: true # カメラを利用する場合false -> trueに変更
                
                # Specifies whether audio is enabled on the camera.
                # カメラで音声を有効にするかを指定します。
                audio:
                  enable: true
            
                # Specify permission permission messages to use the camera and microphone in IOS.
                # IOSでカメラやマイクを利用するための権限許可メッセージを指定します。
                permission:
                  camera:
                    en: Use the camera for video chats. # 利用用途を言語ごとに記載。
                    ja: ビデオチャットのためにカメラを利用します。 # 利用用途を言語ごとに記載。
                  microphone:
                    en: Use the microphone for video chats. # 利用用途を言語ごとに記載。
                    ja: ビデオチャットのためにマイクを利用します。 # 利用用途を言語ごとに記載。
            ```
            
        - カレンダー（`calendar`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using the calendar.
              # カレンダーを利用するための設定を記述します。
              calendar:
                enable: true # カレンダーを利用する場合false -> trueに変更
            ```
            
        - ChatGPT（`openai`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using OpenAI's GPT, etc.
              # OpenAIのGPT等を利用するための設定を記述します。
              openai:
                enable: true # ChatGPTを利用する場合false -> trueに変更
            ```
            
        - Text-To-Speech（`text_to_speech`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using speech synthesis.
              # 音声合成による発話を利用するための設定を記述します。
              text_to_speech:
                enable: true # Text-To-Speechを利用する場合false -> trueに変更
            ```
            
        - Speech-To-Text（`speech_to_text`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Describe the settings for using voice recognition.
              # Specify the permission message to use the library in IOS in [permission].
              # Please include `en`, `ja`, etc. and write the message in that language there.
              # 音声認識を利用するための設定を記述します。
              # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
              # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
              speech_to_text:
                enable: true # Speech-To-Textを利用する場合false -> trueに変更
                permission:
                  en: Used to perform voice recognition. # 利用用途を言語ごとに記載。
                  ja: 音声認識のためにマイクを利用します。# 利用用途を言語ごとに記載。
            ```
            
        - ローカルPUSH通知（`local_notification`）
            
            ```yaml
            # katana.yaml
            
            # Describe the application information.
            # アプリケーション情報を記載します。
            app:
              ~~~~~
            
              # Implement local PUSH.
              # ローカルPUSHを実装します。
              local_notification:
                enable: true # ローカルPUSH通知を利用する場合false -> trueに変更
            ```
            
        - 位置情報（`location`）
            
            ```yaml
            # katana.yaml
            
            # Describe the settings for using location information.
            #
            # Set [enable_background] to true if you want to acquire location information even when the application enters the background.
            # If you wish to use GoogleMap, set [google_map]->[enable] to true. Also, obtain a GoogleMap API key from the following link in advance and enter it in [google_map]->[api_key].
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # If you want to use Geocoding to obtain location information from addresses, set [geocoding]->[enable] to true. Also, please obtain an API key for Geocoding from the link below and enter it in the [geocoding]->[api_key] field.
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # Specify the permission message to use the library in IOS in [permission].
            # Please include `en`, `ja`, etc. and write the message in that language there.
            # 
            # 位置情報を利用するための設定を記述します。
            # 
            # アプリがバックグラウンドに入った場合でも位置情報を取得する場合は[enable_background]をtrueにしてください。
            # GoogleMapを利用する場合は[google_map]->[enable]をtrueにしてください。また事前に下記のリンクからGoogleMapのAPIキーを取得しておき[google_map]->[api_key]に記載してください。
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # Geocodingで住所から位置情報を取得する場合は[geocoding]->[enable]をtrueにしてください。また事前に下記のリンクからGeocoding専用のAPIキーを取得しておき[geocoding]->[api_key]に記載してください。
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
            # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
            location:
              enable: true # 位置情報を利用する場合false -> trueに変更
              enable_background: false
              google_map:
                enable: false
                api_key:
                  android:
                  ios:
                  web:
              geocoding:
                enable: false
                api_key: 
              permission:
                en: Location information is used to display the map. # 利用用途を言語ごとに記載。
                ja: マップを表示するために位置情報を利用します。 # 利用用途を言語ごとに記載。
            ```
            
        - マップ表示（`location→google_map`）
            
            ```yaml
            # katana.yaml
            
            # Describe the settings for using location information.
            #
            # Set [enable_background] to true if you want to acquire location information even when the application enters the background.
            # If you wish to use GoogleMap, set [google_map]->[enable] to true. Also, obtain a GoogleMap API key from the following link in advance and enter it in [google_map]->[api_key].
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # If you want to use Geocoding to obtain location information from addresses, set [geocoding]->[enable] to true. Also, please obtain an API key for Geocoding from the link below and enter it in the [geocoding]->[api_key] field.
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # Specify the permission message to use the library in IOS in [permission].
            # Please include `en`, `ja`, etc. and write the message in that language there.
            # 
            # 位置情報を利用するための設定を記述します。
            # 
            # アプリがバックグラウンドに入った場合でも位置情報を取得する場合は[enable_background]をtrueにしてください。
            # GoogleMapを利用する場合は[google_map]->[enable]をtrueにしてください。また事前に下記のリンクからGoogleMapのAPIキーを取得しておき[google_map]->[api_key]に記載してください。
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # Geocodingで住所から位置情報を取得する場合は[geocoding]->[enable]をtrueにしてください。また事前に下記のリンクからGeocoding専用のAPIキーを取得しておき[geocoding]->[api_key]に記載してください。
            # https://console.cloud.google.com/google/maps-apis/credentials
            #
            # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
            # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
            location:
              enable: true # 位置情報を利用する場合false -> trueに変更
              enable_background: false
              google_map:
                enable: true # マップを利用する場合false -> trueに変更
                api_key:
                  android:
                  ios:
                  web:
              geocoding:
                enable: false
                api_key: 
              permission:
                en: Location information is used to display the map. # 利用用途を言語ごとに記載。
                ja: マップを表示するために位置情報を利用します。 # 利用用途を言語ごとに記載。
            ```
            
        - アプリ広告（`ads`）
            
            ```yaml
            # katana.yaml
            
            # Configure the settings for advertising.
            # Set the respective Ad App Id in [android_app_id] and [ios_app_id].
            # If you want to use it on the web, please obtain app_ads.txt and place it under the web folder.
            # https://admanager.google.com/home/
            # Specify the permission message to use the library in IOS in [permission].
            # Please include `en`, `ja`, etc. and write the message in that language there.
            # 広告を出す場合の設定を行います。
            # [android_app_id]と[ios_app_id]にそれぞれのAd App Idを設定してください。
            # Webで利用する場合はapp_ads.txtを取得し、webフォルダ以下に配置してください。
            # https://admanager.google.com/home/
            # [permission]にIOSでライブラリを利用するための権限許可メッセージを指定します。
            # `en`や`ja`などを記載しそこにその言語でのメッセージを記述してください。
            ads:
              enable: true # アプリ広告を利用する場合false -> trueに変更
              android_app_id: 
              ios_app_id: 
              permission:
                  en: If you [Allow], App will display ads optimized for you. # 広告の最適化許可メッセージを言語ごとに記載。
                  ja: 同意した場合、表示される広告があなたに最適化されます. # 広告の最適化許可メッセージを言語ごとに記載。
            ```
            
        - アプリ内課金（`purchase`）
            
            ```yaml
            # katana.yaml
            
            # Configure settings for store billing.
            # ストア課金を行う場合の設定を行います。
            purchase:
              # Setting this to `true` will install the billing package for testing.
              # ここを`true`にするとテスト用の課金パッケージがインストールされます。
              enable: true # アプリ内課金を利用する場合false -> trueに変更
            
              # Configure settings for Google Play billing.
              # Follow the steps below to configure the settings.
              # 1. Create a service account with permissions to GooglePlayConsole based on the URL below.
              #    https://mathru.notion.site/Android-1d4a60948a1446d7a82c010d96417a3d?pvs=4
              #    ※ You need to create an OAuth consent screen. Please create it from the following URL.
              #    https://console.cloud.google.com/apis/credentials/consent
              # 2. Set `enable` to `true`.
              # 3. Set the topic ID for the notification to `pubsub_topic`.
              # 4. Run `katana apply` to deploy the app and server.
              # GooglePlayの課金を行う場合の設定を行います。
              # 下記の手順で設定を行います。
              # 1. 下記URLを元にGooglePlayConsoleに権限があるサービスアカウントを作成します。
              #    https://mathru.notion.site/Android-1d4a60948a1446d7a82c010d96417a3d?pvs=4
              #    ※OAuthの同意画面を作成する必要があります。下記のURLから作成してください。
              #    https://console.cloud.google.com/apis/credentials/consent
              # 2. `enable`を`true`にします。
              # 3. 通知用のトピックIDを`pubsub_topic`に設定します。
              # 4. `katana apply`を実行しアプリとサーバーのデプロイを行います。
              google_play:
                enable: false
                pubsub_topic: purchasing
              
              # Configure settings for AppStore billing.
              # Follow the steps below to configure the settings.
              # 1. Register your tax information and bank account to activate [Subscription]->[Paid Apps] in the AppStore.
              # 2. Get it from [AppStore]->[App Info]->[Shared Secret for App] and put it in `shared_secret`.
              # AppStoreの課金を行う場合の設定を行います。
              # 下記の手順で設定を行います。
              # 1. AppStoreの[契約]->[有料App]をアクティブにするように税務情報や銀行口座を登録します。
              # 2. AppStoreの[アプリ]->[App情報]->[App用共有シークレット]から取得して`shared_secret`に記載します。
              app_store:
                enable: false
                shared_secret: 
            ```
            
        - Stripe決済（`stripe`）
            
            ```yaml
            # katana.yaml
            
            # Configure billing settings for Stripe.
            # Stripeの課金設定を行います。
            stripe:
              # Set to `true` if you use Stripe.
              # Stripeを利用する場合は`true`にしてください。
              enable: true # Stripe決済を利用する場合false -> trueに変更
            
              # Set to `true` if you use Stripe Connect.
              # Stripeコネクトを利用する場合は`true`にしてください。
              enable_connect: false
            
              # Secret key for Stripe's API.
              # You can obtain keys for the test and production environments at the following URLs
              # StripeのAPI用シークレットキー。
              # 下記のURLからテスト環境用と本番環境用のキーを取得できます。
              # Production environment
              # https://dashboard.stripe.com/apikeys
              # Development enveironment
              # https://dashboard.stripe.com/test/apikeys
              secret_key: 
            
              # URL scheme for returning from Stripe's WebView.
              # It must be set to the same settings as the application side.
              # StripeのWebViewから戻る際のURLスキーム。
              # アプリ側と同じ設定にする必要があります。
              url_scheme:
            
              # Specify the email provider for use with Stripe's 3D Secure authentication.
              # Specify `sendgrid` if you use SendGrid or `gmail` if you use Gmail.
              # Also, please set up various e-mail settings.
              # Stripeの3Dセキュア認証で利用するためのメールプロバイダーを指定します。
              # SendGridを利用する場合は`sendgrid`、Gmailを利用する場合は`gmail`を指定してください。
              # また、各種メールの設定を行ってください。
              email_provider: sendgrid
            
              # Set up a redirect page for 3D Secure.
              # Under each language code, [success] and [failure] should include the URL for success and failure.
              # Adding a language code allows you to include the URL for that language.
              # 3Dセキュア用のリダイレクトページを設定します。
              # 各言語コードの下に[success]と[failure]には成功時、失敗時のURLを記載してください。
              # 言語コードを追加するとその言語のURLを記載することができます。
              three_d_secure_redirect_page:
                en:
                  success:
                  failure:
                ja:
                  success:
                  failure:
            ```
            
        - 音声通話（`agora`）
        - ビデオ通話（`agora`）
        - 音声ストリーミング（`agora`）
        - ビデオストリーミング（`agora`）
            
            ```yaml
            # katana.yaml
            
            # Configure Agora.io streaming settings.
            # Agora.ioのストリーミング設定を行います。
            agora:
              # Set to `true` if you use Agora.io.
              # Agora.ioを利用する場合は`true`にしてください。
              enable: true # 音声・ビデオ通話、音声・ビデオストリーミングを利用する場合false -> trueに変更
            
              # AppID for Agora.
              # Log in to the following URL and create a project.
              # After the project is created, the AppID can be copied.
              # Agora用のAppID。
              # 下記URLにログインし、プロジェクトを作成します。
              # プロジェクト作成後、AppIDをコピーすることができます。
              # https://console.agora.io/projects
              app_id: 
            
              # AppCertificate for Agora.
              # You can obtain the certificate after entering the project you created and activating it in Security -> App certificate.
              # Agora用のAppCertificate。
              # 作成したプロジェクトに入り、Security -> App certificateにて有効化した後取得できます。
              # https://console.agora.io/projects
              app_certificate: 
            
              # Set to `true` to enable Agora cloud recording.
              # Agoraのクラウドレコーディングを有効にする場合は`true`にしてください。
              enable_cloud_recording: false
            
              # Set to `true` to enable Agora full screen sharing.
              # Agoraのフルスクリーン共有を有効にする場合は`true`にしてください。
              enable_fullscreen_sharing: false
            
              # Specify permission permission messages to use the camera and microphone in IOS.
              # IOSでカメラやマイクを利用するための権限許可メッセージを指定します。
              permission:
                camera:
                  en: Use the camera for video chats. # 利用用途を言語ごとに記載。
                  ja: ビデオチャットのためにカメラを利用します。 # 利用用途を言語ごとに記載。
                microphone:
                  en: Use the microphone for video chats. # 利用用途を言語ごとに記載。
                  ja: ビデオチャットのためにマイクを利用します。 # 利用用途を言語ごとに記載。
            ```
            
        - メール送信（`sendgrid`）
            
            ```yaml
            # katana.yaml
            
            # Configure Sendgrid sending settings.
            # Sendgridの送信設定を行います。
            sendgrid:
              # Set to `true` if you want to use mail sending by Sendgrid.
              # Sendgridによるメール送信を利用する場合は`true`にしてください。
              enable: true # メール送信を利用する場合false -> trueに変更
            
              # API key for SendGrid. It can be issued from the following URL.
              # SendGridのAPIキー。下記URLから発行可能です。
              # https://app.sendgrid.com/settings/api_keys
              api_key:
            ```
            
    4. `katana.yaml`を変更を下記コマンドで適用
        
        ```bash
        katana apply
        ```
        
5. **コントローラー設計**
    - `documents/designs/screen_design.md`に記載されている`画面設計`において下記の条件に当てはまる処理が必要な場合`コントローラー`を作成
        - 複数の画面に跨る処理が必要
        - 複数のデータモデルやプラグインを連携させた処理が必要
    - 必要ない場合は無理に作成しない
    - 作成方法
        1. 必要になるコントローラーをまとめて`コントローラー設計書`を作成
            - 例：
                - [コントローラー設計](https://www.notion.so/18f21e342b5480c3a2ece8cafea3118b?pvs=21)
                    
                    
                    ## 購入コントローラー
                    
                    ### コントローラーID
                    
                    `purchase`
                    
                    ### 概要
                    
                    - カートへの商品の追加
                    - カートから商品の削除
                    - 現在のカートの内容の取得
                    - 支払い方法の選択
                    - 現在選択されている支払い方法の取得
                    - 住所の取得
                    - 現在のカートの内容、選択されている支払い方法、住所を元に支払い手続きを行いトランザクションに書き込む。
        2. まとめた`コントローラー設計書`をドキュメントに落とし込む
            - `documents/designs/controller_design.md`にマークダウン記法で記載
            - 例：
                - [コントローラー設計書](https://www.notion.so/18f21e342b5480049c84d48fc187ec34?pvs=21)
                    
                    
                    ```markdown
                    <!-- documents/designs/controller_design.md -->
                    
                    ## 購入コントローラー
                    
                    ### コントローラーID
                    
                    `purchase`
                    
                    ### 概要
                    
                    - カートへの商品の追加
                    - カートから商品の削除
                    - 現在のカートの内容の取得
                    - 支払い方法の選択
                    - 現在選択されている支払い方法の取得
                    - 住所の取得
                    - 現在のカートの内容、選択されている支払い方法、住所を元に支払い手続きを行いトランザクションに書き込む。
                    ```
                    
        3. まとめた`コントローラー設計書`を元に各々のコントローラーを実装
            1. `コントローラーID`を用い下記コマンドでコントローラーを作成
                
                ```bash
                katana code controller [コントローラーID]
                ```
                
            2. コントローラーに対するパラメーターが必要な場合それを定義
                - `// TODO: Define fields and processes.`の下に`final String userId;`のように変数を定義
                - `// TODO: Define some arguments.`の下に`this.userId`や`required this.userId`、`this.userId = “DefaultValue”`といった形でパラメーターを設定
                
                ```dart
                // lib/controllers/purchase.dart
                
                /// Controller.
                @Controller(autoDisposeWhenUnreferenced: true)
                class PurchaseController extends ChangeNotifier {
                  PurchaseController(
                    // TODO: Define some arguments.
                    this.debugUserId,    
                  );
                
                  // TODO: Define fields and processes.
                  final String? debugUserId;
                  
                
                  /// Query for PurchaseController.
                  ///
                  /// ```dart
                  /// appRef.controller(PurchaseController.query(parameters));     // Get from application scope.
                  /// ref.app.controller(PurchaseController.query(parameters));    // Watch at application scope.
                  /// ref.page.controller(PurchaseController.query(parameters));   // Watch at page scope.
                  /// ```
                  static const query = _$PurchaseControllerQuery();
                  
                  ~~~~~~~
                }
                ```
                
            3. `概要`に記載されている内容に応じてメソッドを定義し処理を実装
                - `appRef`を用いて他のコントローラーやデータモデル、各種プラグインへアクセスしデータを取得
                    - コントローラーの取得
                        
                        ```dart
                        final otherController = appRef.controller(OtherController.query());
                        ```
                        
                    - データモデル（コレクション）の取得
                        
                        ```dart
                        final collection = appRef.model(OtherModel.collection());
                        ```
                        
                    - データモデル（ドキュメント）の取得
                        
                        ```dart
                        final document = appRef.model(OtherModel.document(documentId));
                        ```
                        
                    - プラグインの取得
                        
                        ```dart
                        final filePicker = appRef.controller(Picker.query());
                        ```
                        

## 実装

画面設計（`documents/designs/screen_design.md`）やデータモデル設計（`documents/designs/model_design.md`）、テーマ設計（`documents/designs/theme_design.md`）、プラグイン設計（`documents/designs/plugin_design.md`）、コントローラー設計（`documents/designs/controller_design.md`）を元に下記手順に従いながら各画面（Page）を実装。画面の種類によって作成方法が異なる。

### 通常画面

1. 画面（Page）の`画面ID`を用いて下記コマンドを入力
    
    ```bash
    katana code page [画面ID]
    ```
    
2. 画面（Page）に対する`画面パス`を`@PagePath`Annotationに記載
3. 画面（Page）に対するパラメーターがある場合それを定義
    - `// TODO: Set parameters for the page in the form [final String xxx].`の下に`final String memoId;`のように変数を定義
    - `// TODO: Set parameters for the page.`の下に`required this.memoId`や`this.memoId = “DefaultValue”`といった形でパラメーターを設定
    - `画面パス`に変数（`:memo_id`等の`:`が先頭に付与されている階層名）がある場合は変数名をCamelCaseに変換して必ず定義
        - 値が必須になるため`required`もしくはデフォルト値を付与。（付与の方法はDartの記法に従う）
    
    ```dart
    // e.g. lib/pages/memo_detail.dart
    
    /// Page widget for MemoDetail.
    @immutable
    // TODO: Set the path for the page.
    @PagePath("memo/:memo_id")
    class MemoDetailPage extends PageScopedWidget {
      const MemoDetailPage({
        super.key,
        // TODO: Set parameters for the page.
        required this.memoId,    
      });
    
      // TODO: Set parameters for the page in the form [final String xxx].
      final String memoId;
      
      ~~~~~~~
    }
    ```
    
4. 下記の内容に従い`build`メソッド内に処理やUIを記述
    
    [Masamuneフレームワーク内のUI実装](https://www.notion.so/Masamune-UI-19021e342b548090a953f54d2e532bf0?pvs=21) 
    
5. 下記コマンドを実行し残りのコードを自動生成
    
    ```bash
    katana code generate
    ```
    

### フォーム画面（データの新規追加・編集どちらも行う場合）

1. 画面（Page）の`画面ID`を用いて下記コマンドを入力
    
    ```bash
    katana code tmp form [画面ID]
    ```
    
2. 画面（Page）に対する`画面パス`を新規追加時と編集時のWidgetクラスにある`@PagePath`Annotationに記載
    
    ```dart
    // e.g. lib/pages/memo_edit.dart
    
    /// Page for forms to add data.
    @immutable
    @PagePath("memo/edit/new")
    class MemoEditAddPage extends FormAddPageScopedWidget {
      const MemoEditAddPage({
        super.key,
      });
    
      /// Used to transition to the MemoEditAddPage screen.
      ///
      /// ```dart
      /// router.push(MemoEditAddPage.query(parameters));    // Push page to MemoEditAddPage.
      /// router.replace(MemoEditAddPage.query(parameters)); // Replace page to MemoEditAddPage.
      /// ```
      @pageRouteQuery
      static const query = _$MemoEditAddPageQuery();
    
      @override
      FormScopedWidget build(BuildContext context, PageRef ref) =>
          const MemoEditForm();
    }
    
    /// Page for forms to edit data.
    @immutable
    @PagePath("memo/edit/:edit_id")
    class MemoEditEditPage extends FormEditPageScopedWidget {
      const MemoEditEditPage({
        super.key,
        @PageParam("edit_id") required super.editId,
      });
    
      /// Used to transition to the MemoEditEditPage screen.
      ///
      /// ```dart
      /// router.push(MemoEditEditPage.query(parameters));    // Push page to MemoEditEditPage.
      /// router.replace(MemoEditEditPage.query(parameters)); // Replace page to MemoEditEditPage.
      /// ```
      @pageRouteQuery
      static const query = _$MemoEditEditPageQuery();
    
      @override
      FormScopedWidget build(BuildContext context, PageRef ref) =>
          const MemoEditForm();
    }
    ```
    
3. 下記の内容に従い`FormScopedWidget`を継承したクラスの`build`メソッド内に処理やUIを記述
    
    [Masamuneフレームワーク内のUI実装](https://www.notion.so/Masamune-UI-19021e342b548090a953f54d2e532bf0?pvs=21) 
    
4. 下記コマンドを実行し残りのコードを自動生成
    
    ```bash
    katana code generate
    ```
    
5. 画面（Page）の`概要`に従って`build`メソッド内にWidgetを記述しUIを作成
    - 下記の画面の種類ごとに各々の手順を実施
        - フォーム画面（新規作成・編集両方必要な場合）
            1. 画面（Page）の`画面ID`を用いて下記コマンドを入力
                
                ```bash
                katana code tmp form [画面ID]
                ```
                
    - 通常画面
    - ナビゲーションバー付き画面
        
        ```bash
        katana code tmp navigation [画面ID]
        ```
        
        - ナビゲーションバーの場合は中身の画面を別途作成
    - タブバー付き画面
        
        ```bash
        katana code tmp tab [画面ID]
        ```
        
    - 例：
        - [画面作成コマンド](https://www.notion.so/18f21e342b54800aa0ecebdf010165fe?pvs=21)
            
            
            ```bash
            katana code page memo
            katana code page memo_detail
            katana code tmp form memo_edit
            ```
            
        - [画面作成コマンド](https://www.notion.so/18f21e342b5480798169c54ae6b9b1cb?pvs=21)
6. 

# 設計・実装例

[設計例](Masamune%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0%E3%83%AF%E3%83%BC%E3%82%AF%2018b21e342b5480cd894af9f30271d323/%E8%A8%AD%E8%A8%88%E4%BE%8B%2018f21e342b54802785a5d5241b815404.csv)

# コードリファレンス

[masamune - Dart API docs](https://pub.dev/documentation/masamune/latest/)

[npm: @mathrunet/masamune](https://www.npmjs.com/package/@mathrunet/masamune)
