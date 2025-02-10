// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of widget_creation.mdc.
///
/// widget_creation.mdcの中身。
class WidgetCreationMdcCliAiCode extends CliAiCode {
  /// Contents of widget_creation.mdc.
  ///
  /// widget_creation.mdcの中身。
  const WidgetCreationMdcCliAiCode();

  @override
  String get name => "`Widget`の作成";

  @override
  String get globs => "lib/widgets/**/*.dart, lib/models/**/*.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Widget設計書`を用いた`Widget`の作成方法";

  @override
  String body(String baseName, String className) {
    return r"""
[widget_design.md](mdc:documents/designs/widget_design.md)に記載されている`Widget設計書`からDartコードを生成
[widget_design.md](mdc:documents/designs/widget_design.md)が存在しない場合は絶対に実施しない

`Widget設計書`に記載されている各`Widget`の`WidgetType`に応じてそれぞれ下記を実行

## `stateless`

1. 下記のコマンドを実行して`StatelessWidget`を継承したクラスファイルを作成

    ```shell
    katana code stateless [WidgetName(SnakeCase&末尾のWidgetを取り除く)]
    ```

2. コマンド実行後、`lib/widgets`以下に[WidgetName(SnakeCase&末尾のWidgetを取り除く)].dartファイルが作成される
3. 作成された`StatelessWidget`を継承したクラス内の`// TODO: Set parameters for the widget in the form (e.g. [final String xxx]).`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the widget.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
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

## `stateful`

1. 下記のコマンドを実行して`ScopedWidget`を継承したクラスファイルを作成

    ```shell
    katana code widget [WidgetName(SnakeCase&末尾のWidgetを取り除く)]
    ```

2. コマンド実行後、`lib/widgets`以下に[WidgetName(SnakeCase&末尾のWidgetを取り除く)].dartファイルが作成される
3. 作成された`ScopedWidget`を継承したクラス内の`// TODO: Set parameters for the widget in the form (e.g. [final String xxx]).`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the widget.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
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

## `model_extension`

1. `TargetModel`に対応する`lib/models/[TargetModelのModelName(SnakeCase&末尾のModelを取り除く)].dart`以下のファイルを開く。

2. ファイルの`extension [TargetModelのModelName(PascalCase&末尾のModelを取り除く)]ModelDocumentExtension on [TargetModelのModelName(PascalCase&末尾のModelを取り除く)]ModelDocument`内にある`// TODO: Define the extension method.`以下に`Widget toXXX()`のメソッドを定義
    - メソッド名は必ず先頭に`to`を付与し`Model`をどのような`Widget`に変換するかを明示する必要がある
    - 例：
        ```dart
        // lib/models/memo.dart

        extension MemoModelDocumentExtension on MemoModelDocument {
          Widget toTile() {
            throw UnimplementedError();
          }
        }
        ```
""";
  }
}
