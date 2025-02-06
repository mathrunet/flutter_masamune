import 'package:katana_cli/katana_cli.dart';

/// Contents of screen_design.mdc.
///
/// screen_design.mdcの中身。
class ScreenDesignMdcCliAiCode extends CliAiCode {
  /// Contents of screen_design.mdc.
  ///
  /// screen_design.mdcの中身。
  const ScreenDesignMdcCliAiCode();

  @override
  String get name => "画面設計書の作成";

  @override
  String get globs => "*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "Masamuneフレームワークによる画面設計書の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[requirements.md](mdc:requirements.md)に記載されている`要件定義`から`画面設計書`を作成

1. `要件定義`から画面ごとの要素に分割し`画面設計`を作成
    - 各画面に対して下記を定義
        - `画面ID`
            - 画面に対する一意のIDをCamelCaseで作成
        - `画面パス`
            - URLと同じように定義（e.g. `memo/edit/:memo_id`）
            - `/`で階層を記述。
            - 空の名前の階層は作らない（`//`といった記述はない）
                - ただしトップページのみ空の階層を許可
            - 先頭および末尾に`/`は記述しない。
            - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `memo/edit/:memo_id`の場合は`memo_id`が変数）
        - `画面タイプ`
            - 下記の画面タイプからいずれか１つを選び`画面タイプID`を記載
              | 画面タイプ | 画面タイプID | 概要 |
              | --- | --- |
              | リストビュー | `listview` | 上から下に要素が並んでおりスクロール可能なビュー。 |
              | グリッドビュー | `gridview` | 上から下に格子状に要素が並んでおりスクロール可能なビュー。 |
              | 固定ビュー | `fixedview` | スクロール不可で各要素が固定されているビュー。 |
              | リストフォームビュー | `listform` | 入力・選択フォームが上から下に並んでおりスクロール可能なビュー。 |
              | 固定フォームビュー | `fixedform` | スクロール不可で入力・選択フォームが固定されているビュー。 |
              | ナビゲーションビュー | `navigation` | 下部に横並びでナビゲーションが配置され、メインスペースに別画面（Page）が表示されているビュー。 |
              | タブビュー | `tab` | 上部に横並びでタブが配置され、タブを切り替えることで画面がスライドするビュー。 |
              | その他 | `page` | その他通常の画面（Page）ビュー。 |
        - `概要`
            - 各画面における`画面構成要素`と各構成要素に対する`アクション`を箇条書きで細かく記載
    - 例：
        ```markdown
        <!-- documents/designs/screen_design.md -->
        
        ## メモ一覧画面
        
        ### 画面ID
        
        `memo`
        
        ### 画面パス
        
        ### 画面タイプ

        `page`

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

        ### 画面タイプ

        `page`
        
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

        ### 画面タイプ

        `listform`
        
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

        ### 画面タイプ

        `listform`
        
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
2. 作成した`画面設計書`を`documents/designs/screen_design.md`に保存
""";
  }
}
