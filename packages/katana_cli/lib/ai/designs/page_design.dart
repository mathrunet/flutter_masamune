import 'package:katana_cli/katana_cli.dart';

/// Contents of screen_design.mdc.
///
/// screen_design.mdcの中身。
class PageDesignMdcCliAiCode extends CliAiCode {
  /// Contents of screen_design.mdc.
  ///
  /// screen_design.mdcの中身。
  const PageDesignMdcCliAiCode();

  @override
  String get name => "`Page設計書`の作成";

  @override
  String get globs => "documents/designs/page_design.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`Page設計`の方法と`Page設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[requirements.md](mdc:requirements.md)に記載されている`要件定義`から`Page設計書`を作成

1. `要件定義`から`Page`ごとの要素に分割し`Page設計`を作成
    - 各`Page`に対して下記を定義
        - `PageID`
            - `Page`に対する一意のIDをCamelCaseで作成
        - `PagePath`
            - URLと同じように定義（e.g. `memo/edit/:memo_id`）
            - `/`で階層を記述。
            - 空の名前の階層は作らない（`//`といった記述はない）
                - ただしトップページのみ空の階層を許可
            - 先頭および末尾に`/`は記述しない。
            - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `memo/edit/:memo_id`の場合は`memo_id`が変数）
        - `PageType`
            - [`PageType`の一覧](mdc:.cursor/rules/docs/page_types.mdc)から相応しい`PageType`を1つ選び`PageTypeID`を記載
        - `Content`
            - 各`Page`における`構成要素`と各構成要素に対する`Action`を箇条書きで細かく記載
        - `Properties`
            - 各`Page`における入力値である`Properties`を記載
    - 例：
        ```markdown
        <!-- documents/designs/page_design.md -->
        
        ## メモ一覧画面
        
        ### PageID
        
        `memo`
        
        ### PagePath

        ### PageType

        `listview`

        ### Content
        
        - 起動時に表示
        - AppBarにアプリタイトルを表示
        - 登録されているメモの一覧をリスト表示
            - 各要素にはメモのタイトル、作成者、作成日時、更新日時、タグを表示
            - 各要素をタップすると`メモ詳細Page`に遷移
        - FloatingActionButtonに「新規」ボタンを表示。タップすると`メモ新規作成画面`に遷移

        ### Properties
        
        ## メモ詳細画面
        
        ### PageID
        
        `memo_detail`
        
        ### PagePath
        
        `memo/:memo_id`

        ### PageType

        `page`
        
        ### Content
        
        - AppBarにメモのタイトルを表示
        - 上部にメモの作成者、作成日時、更新日時、タグを表示
        - その下にメモのコンテンツを表示
        - メモのコンテンツの下に添付画像があれば表示
        - AppBarのactionsに編集用のボタンを表示。タップすると`メモ編集画面`に遷移

        ### Properties

        | PropertyName | PropertyType | RequiredOrOptional | DefaultValue | Summary |
        | --- | --- | --- | --- | --- |
        | `memoId` | String | Required |  | 表示するメモのID。 |
        
        ## メモ新規作成画面
        
        ### PageID
        
        `memo_edit_new`
        
        ### PagePath
        
        `memo/edit/new`

        ### PageType

        `listform`
        
        ### Content
        
        - AppBarに「新規作成」と表示
        - 下記のフォームを表示
            - タイトル（テキスト入力）
            - 作成者（ユーザー一覧から選択）
            - タグ（タグ入力）
            - コンテンツ（マルチラインテキスト入力）
            - 添付画像（マルチメディア入力）
        - AppBarのactionsに編集確定ボタンを表示。タップするとメモが作成される

        ### Properties
        
        ## メモ編集画面
        
        ### PageID
        
        `memo_edit`
        
        ### PagePath
        
        `memo/edit/:memo_id`

        ### PageType

        `listform`
        
        ### Content
        
        - AppBarに「[メモのタイトル]の編集」と表示
        - 下記のフォームを表示し各要素に既存のデータを入力済みにする
            - タイトル（テキスト入力）
            - 作成者（ユーザー一覧から選択）
            - タグ（タグ入力）
            - コンテンツ（マルチラインテキスト入力）
            - 添付画像（マルチメディア入力）
        - AppBarのactionsに編集確定ボタンを表示。タップするとメモが更新される
        - AppBarのactionsに削除ボタンを表示。タップすると確認ダイアログ表示の後メモを削除

        ### Properties

        | PropertyName | PropertyType | RequiredOrOptional | DefaultValue | Summary |
        | --- | --- | --- | --- | --- |
        | `memoId` | String | Required |  | 編集するメモのID。 |
        ```
2. 作成した`Page設計書`を`documents/designs/page_design.md`に保存
""";
  }
}
