# `Widget`のUI実装

`documents/designs/widget_design.md`に記載されている`Widget設計書`と`lib/widgets`に作成されているDartファイルを参照して`Widget`のUIを実装
`documents/designs/widget_design.md`が存在しない場合は絶対に実施しない

## `stateless`

1. 対象のDartファイル（`lib/widgets`以下に[WidgetName(SnakeCase&末尾のWidgetを取り除く)].dart）を開く
2. `Widget設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the view.`以下を書き換え、適切なUIを構築して返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 必要であれば`onTap`などのアクションを引数にして定義。可能な限りタップ操作は外に切り出すようにする。
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは[`Theme`の利用方法](documents/rules/docs/theme_usage.md)を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return Container(
          child: Text('Hello, World!'),
        );
        ```

## `stateful`

1. 対象のDartファイル（`lib/widgets`以下に[WidgetName(SnakeCase&末尾のWidgetを取り除く)].dart）を開く
2. `Widget設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the view.`以下を書き換え、適切なUIを構築して返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 必要であれば`onTap`などのアクションを引数にして定義。可能な限りタップ操作は外に切り出すようにする。
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`Theme`の利用方法(`documents/rules/docs/theme_usage.md`)を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return Container(
          child: Text('Hello, World!'),
        );
        ```

## `model_extension`

1. `TargetModel`に対応する`lib/models/[TargetModelのModelName(SnakeCase&末尾のModelを取り除く)].extensions.dart`以下のファイルを開く。
2. `Widget設計書`の`Content`に応じて該当する`toXXX`メソッド内を書き換え、適切なUIを構築して返す。
    - 適宜`import`を追加する
    - 必要であれば`onTap`などのアクションを引数にして定義。可能な限りタップ操作は外に切り出すようにする。
    - `Model`の`Document`の変数をそのまま利用してもよい
        - `value`で`Model`の変数をそのまま利用可能
        - `uid`で`Model`の`DocumentID`を利用可能
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`Theme`の利用方法(`documents/rules/docs/theme_usage.md`)を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return Container(
          child: Text(this.value?.title ?? ''),
        );
        ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
