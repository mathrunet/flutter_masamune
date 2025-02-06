import 'package:katana_cli/katana_cli.dart';

/// Contents of widget_impl.mdc.
///
/// widget_impl.mdcの中身。
class WidgetImplMdcCliAiCode extends CliAiCode {
  /// Contents of widget_impl.mdc.
  ///
  /// widget_impl.mdcの中身。
  const WidgetImplMdcCliAiCode();

  @override
  String get name => "Widgetの実装";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "MasamuneフレームワークによるWidgetの実装";

  @override
  String body(String baseName, String className) {
    return r"""
[widget_design.md](mdc:documents/designs/widget_design.md)に記載されている`Widget設計書`からDartコードを生成
※参考として[screen_design.md](mdc:documents/designs/screen_design.md)に記載されている`画面設計書`や[model_design.md](mdc:documents/designs/model_design.md)に記載されている`モデル設計書`、[controller_design.md](mdc:documents/designs/controller_design.md)に記載されている`コントローラー設計書`、[theme_design.md](mdc:documents/designs/theme_design.md)に記載されている`テーマ設計書`、[title_design.md](mdc:documents/designs/title_design.md)に記載されている`アプリタイトル設計書`も参照。

`Widget設計書`に記載されている各`Widget`の`Widgetタイプ`に応じてそれぞれ下記を実行

## `stateless`

1. 下記のコマンドを実行して`StatelessWidget`を継承したクラスファイルを作成

    ```shell
    katana code stateless [Widget名(SnakeCase&末尾のWidgetを取り除く)]
    ```

2. コマンド実行後、`lib/widgets`以下に[Widget名(SnakeCase&末尾のWidgetを取り除く)].dartファイルが作成される
3. 作成された`StatelessWidget`を継承したクラス内の`// TODO: Set parameters for the widget in the form (e.g. [final String xxx]).`以下に`プロパティ`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the widget.`以下に定義
    - プロパティの状態に応じて下記を実施
        - 必須な場合は先頭に`required`をつける
        - デフォルト値がある場合は末尾に`= デフォルト値`をつける
    - 例：
        ```dart
        // lib/widgets/title_app_bar.dart

        // ignore: unused_import, unnecessary_import
        import 'package:flutter/material.dart';
        // ignore: unused_import, unnecessary_import
        import 'package:masamune/masamune.dart';
        import 'package:masamune_universal_ui/masamune_universal_ui.dart';

        // ignore: unused_import, unnecessary_import
        import '/main.dart';


        /// StatelessWidget.
        @immutable
        class TitleAppBarWidget extends StatelessWidget {
          const TitleAppBarWidget({
            super.key,
            // TODO: Set parameters for the widget.
            required this.title,
          });

          // TODO: Set parameters for the widget in the form (e.g. [final String xxx]).
          final String title;

          @override
          Widget build(BuildContext context) {
            // Describes the structure of the widget.
            // TODO: Implement the view.
            return Empty();
          }
        }
        ```
5. `概要`に応じて`build`メソッド内の`// TODO: Implement the view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - 必要であればプロパティの変数を利用する

## `stateful`

1. 下記のコマンドを実行して`ScopedWidget`を継承したクラスファイルを作成

    ```shell
    katana code widget [Widget名(SnakeCase&末尾のWidgetを取り除く)]
    ```

2. コマンド実行後、`lib/widgets`以下に[Widget名(SnakeCase&末尾のWidgetを取り除く)].dartファイルが作成される
3. 作成された`ScopedWidget`を継承したクラス内の`// TODO: Set parameters for the widget in the form (e.g. [final String xxx]).`以下に`プロパティ`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the widget.`以下に定義
    - プロパティの状態に応じて下記を実施
        - 必須な場合は先頭に`required`をつける
        - デフォルト値がある場合は末尾に`= デフォルト値`をつける
    - 例：
        ```dart
        // lib/widgets/title_app_bar.dart

        // ignore: unused_import, unnecessary_import
        import 'package:flutter/material.dart';
        // ignore: unused_import, unnecessary_import
        import 'package:masamune/masamune.dart';
        import 'package:masamune_universal_ui/masamune_universal_ui.dart';

        // ignore: unused_import, unnecessary_import
        import '/main.dart';


        /// ScopedWidget.
        @immutable
        class TitleAppBarWidget extends ScopedWidget {
          const TitleAppBarWidget({
            super.key,
            // TODO: Set parameters for the widget.
            required this.title,            
          });

          // TODO: Set parameters for the widget in the form (e.g. [final String xxx]).
          final String title;          

          @override
          Widget build(BuildContext context, WidgetRef ref) {
            // Describes the process of loading
            // and defining variables required for the widget.
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the widget.
            // TODO: Implement the view.
            return Empty();
          }
        }
        ```
5. `概要`に応じて`build`メソッド内の`// TODO: Implement the variable loading process.`以下に`ref`を用いてプロジェクト内の各種`モデル`や`Controller`を取得する。
    - `モデル`（コレクション）の取得
      ```dart
      final memoCollection = ref.app.model(MemoModel.collection())..load(); // load()でデータを取得開始
      ```
        - `モデル`（コレクション）をフィルタリング
          ```dart
          // 7日前から現在までのメモを取得
          final memoCollection = ref.app.model(
            MemoModel.collection().createdAt.greaterThanOrEqualTo(
              ModelTimestamp(DateTime.now().subtract(const Duration(days: 7))),
            ).createdAt.orderByDesc(),
          )..load();
          // 特定のユーザーのメモを取得
          final memoCollection = ref.app.model(
            MemoModel.collection().createdBy.equalTo(
              otherUser
            ),
          )..load();
          ```
    - `モデル`（ドキュメント）の取得
      ```dart
      final memoDocument = ref.app.model(MemoModel.document(memoId))..load();
      ```
    - `Controller`の取得（アプリケーションにまたがって状態を維持）
      ```dart
      final controller = ref.app.controller(MemoController.query());
      ```
    - `Controller`の取得（画面のみで状態を維持）
      ```dart
      final controller = ref.page.controller(MemoController.query());
      ```
6. `概要`に応じて`build`メソッド内の`// TODO: Implement the view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - 必要であればプロパティの変数を利用する
    - 3で取得した`モデル`や`Controller`を利用してもよい

## `model_extension`

1. `対象モデル`に対応する`lib/models/[対象モデル名(SnakeCase&末尾のModelを取り除く)].dart`以下のファイルを開く。

2. ファイルの`extension [対象モデル名(PascalCase&末尾のModelを取り除く)]ModelDocumentExtension on [対象モデル名(PascalCase&末尾のModelを取り除く)]ModelDocument`内にある`// TODO: Define the extension method.`以下に`Widget toXXX()`のメソッドを定義
    - メソッド名は必ず先頭に`to`を付与しモデルをどのようなWidgetに変換するかを明示する必要がある

3. `概要`に応じて作成したメソッド内に適切な構築しUIを返す。
    - 適宜`import`を追加する
    - モデル内の変数は`value?.xxx`という形で利用可能
        - nullableを直接利用できない場合は代替の値を設定。（Widgetの場合は`const Empty()`を設定）
    - モデルごとのIDは`value.uid`という形で利用可能
""";
  }
}
