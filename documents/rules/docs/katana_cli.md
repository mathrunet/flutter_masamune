# `katana`コマンドの一覧とその利用方法

コードを生成やプラグインのインポートで必ず利用する`katana`コマンドの一覧とその利用方法を下記に記載する。

## `katana`コマンドの一覧

- `katana compose [application_id]`
    - Create a new Flutter project. 新しいFlutterプロジェクトを作成します。
- `katana apply`
    - Reflect the settings in katana.yaml in the application project. katana.yamlの設定をアプリケーションプロジェクトに反映させます。
- `katana deploy`
    - Deployment process. デプロイ処理を行います。
- `katana doctor`
    - Check the installation status of the commands required for the `katana` command. Installation is also performed, but may fail due to permissions. In that case, please execute the installation with administrator privileges. `katana`コマンドに必要なコマンドのインストール状況を調べます。インストールも行いますがパーミッションの関係で失敗する場合があります。その場合は管理者権限で実行してください。
- `katana store screenshot`
    - Create screenshot images, etc. for the store. ストア用のスクリーンショット画像等の作成を行います。
- `katana store build`
    - Build the Android appbundle for the first upload to the store. Androidのappbundleをビルドしてストアへの初回アップロードを行います。
- `katana pub add [package_name]`
    - Add packages. パッケージの追加を行います。
- `katana pub get`
    - Get the packages. パッケージの取得を行います。
- `katana pub upgrade`
    - Upgrade the package. パッケージのアップグレードを行います。
- `katana git commit`
    - Commit and push to Git. Gitのコミットを行いPUSHします。
- `katana git pull_request`
    - Create a pull request. プルリクエストを作成します。
- `katana git remove`
    - Remove files from Git. Gitからファイルを削除します。
- `katana code boot`
    - Create a base class for the boot page in `lib/boot.dart`. ブートページのベースクラスを`lib/boot.dart`に作成します。
- `katana code collection [model_name]`
    - Create a base class for the collection model in `lib/models/(filepath).dart`. コレクションモデルのベースクラスを`lib/models/(filepath).dart`に作成します。
- `katana code document [model_name]`
    - Create a base class for the document model in `lib/models/(filepath).dart`. ドキュメントモデルのベースクラスを`lib/models/(filepath).dart`に作成します。
- `katana code value [model_name]`
    - Create a base class for Immutable value in `lib/models/(filepath).dart`. Immutableな値のベースクラスを`lib/models/(filepath).dart`に作成します。
- `katana code controller [controller_name]`
    - Create a base class for the controller in `lib/controllers/(filepath).dart`. コントローラーのベースクラスを`lib/controllers/(filepath).dart`に作成します。
- `katana code page [page_name]`
    - Create a base class for the page in `lib/pages/(filepath).dart`. ページのベースクラスを`lib/pages/(filepath).dart`に作成します。
- `katana code enum [enum_name]`
    - Create an Enum base in `lib/enums/(filepath).dart`. Enumのベースを`lib/enums/(filepath).dart`に作成します。
- `katana code exception [exception_name]`
    - Create a base class for the exception in `lib/exceptions/(filepath).dart`. 例外のベースクラスを`lib/exceptions/(filepath).dart`に作成します。
- `katana code modal [modal_name]`
    - Create a base class for the modal in `lib/modals/(filepath).dart`. モーダルのベースクラスを`lib/modals/(filepath).dart`に作成します。
- `katana code redirect_query [redirect_query_name]`
    - Create a base class for the RedirectQuery in `lib/redirects/(filepath).dart`. RedirectQueryのベースクラスを`lib/redirects/(filepath).dart`に作成します。
- `katana code stateless [widget_name]`
    - Create a StatelessWidget in `lib/widgets/(filepath).dart`. StatelessWidgetを`lib/widgets/(filepath).dart`に作成します。
- `katana code stateful [widget_name]`
    - Create a StatefulWidget in `lib/widgets/(filepath).dart`. StatefulWidgetを`lib/widgets/(filepath).dart`に作成します。
- `katana code widget [widget_name]`
    - Create a ScopedWidget in `lib/widgets/(filepath).dart`. ScopedWidgetを`lib/widgets/(filepath).dart`に作成します。
- `katana code server call [function_name]`
    - Create server code for FunctionCall in `firebase/functions/src/functions/(filepath).ts`. FunctionCall用のサーバーコードを`firebase/functions/src/functions/(filepath).ts`に作成します。
- `katana code server firestore [function_name]`
    - Create a server code for Firestore triggers in `firebase/functions/src/functions/(filepath).ts`. Firestoreトリガー用のサーバーコードを`firebase/functions/src/functions/(filepath).ts`に作成します。
- `katana code server request [function_name]`
    - Create server code for HTTP requests in `firebase/functions/src/functions/(filepath).ts`. HTTPリクエスト用のサーバーコードを`firebase/functions/src/functions/(filepath).ts`に作成します。
- `katana code server schedule [function_name]`
    - Create a server code for the scheduler in `firebase/functions/src/functions/(filepath).ts`. スケジューラー用のサーバーコードを`firebase/functions/src/functions/(filepath).ts`に作成します。
- `katana code tmp fixedview [page_name]`
    - Create a template for the fixed view page in `lib/pages/(filepath).dart`. 固定ビューページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp listview [page_name]`
    - Create a template for the list view page in `lib/pages/(filepath).dart`. リストビューページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp gridview [page_name]`
    - Create a template for the grid view page in `lib/pages/(filepath).dart`. グリッドビューページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp fixedform [page_name]`
    - Create a template for the fixed form page in `lib/pages/(filepath).dart`. 固定フォームページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp listform [page_name]`
    - Create a template for the list form page in `lib/pages/(filepath).dart`. リストフォームページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp form [page_name]`
    - Create a template for the navigation page in `lib/pages/(filepath).dart`. ナビゲーションページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code view page [page_name]`
    - Create a base class for the page in `lib/pages/(filepath).dart`. ページのベースクラスを`lib/pages/(filepath).dart`に作成します。
- `katana code tmp tab [page_name]`
    - Create a template for the tab page in `lib/pages/(filepath).dart`. タブページのテンプレートを`lib/pages/(filepath).dart`に作成します。
- `katana code generate`
    - Start Dart's build_runner to automatically generate code. Dartのbuild_runnerを起動してコードを自動生成します。
- `katana code format`
    - Dart file formatting. Dartファイルのフォーマッティングを行います。
- `katana code zip`
    - Output the Dart code in a hardened Zip file. DartのコードをZipに固めて出力します。
- `null`
    - Create a Dart/Flutter test template. Dart/Flutterのテストテンプレートを作成します。
    controller:
        - Create a controller test template in `lib/controllers/(filepath).dart`. コントローラーのテストテンプレートを`lib/controllers/(filepath).dart`に作成します。
    widget:
        - Create a widget test template in `lib/widgets/(filepath).dart`. ウィジェットのテストテンプレートを`lib/widgets/(filepath).dart`に作成します。
    page:
        - Create a page test template in `lib/pages/(filepath).dart`. ページのテストテンプレートを`lib/pages/(filepath).dart`に作成します。

