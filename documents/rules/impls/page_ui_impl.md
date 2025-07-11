# `Page`のUI実装

`documents/designs/page_design.md`に記載されている`Page設計書`からDartコードを生成
`documents/designs/page_design.md`が存在しない場合は絶対に実施しない

`Page設計書`に記載されている各`Page`の`PageType`に応じてそれぞれ下記を実行

## `listview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the app bar.`や`// TODO: Implement the list view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            // TODO: Implement the app bar.
            title: const Text("ToDoリスト"),
          ),
          body: UniversalListView(
            children: [
              // TODO: Implement the list view.
              ...memoCollection.map(
                (memo) {
                  return memo.toTile(context, onTap: () {
                    router.push(MemoDetailPage.query(memoId: memo.id));
                  });
                }
              ),
            ],
          ),
        );
        ```

## `gridview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the app bar.`や`// TODO: Implement the grid view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            // TODO: Implement the app bar.
            title: const Text("ToDoリスト"),
          ),
          body: UniversalGridView(
            children: [
              // TODO: Implement the grid view.
              ...memoCollection.map(
                (memo) {
                  return memo.toTile(context, onTap: () {
                    router.push(MemoDetailPage.query(memoId: memo.id));
                  });
                }
              ),
            ],
          ),
        );
        ```

## `fixedview`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the app bar.`や`// TODO: Implement the fixed view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            // TODO: Implement the app bar.
            title: const Text("ToDoリスト"),
          ),
          body: UniversalColumn(
            children: [
              // TODO: Implement the fixed view.
              ...memoCollection.map(
                (memo) {
                  return memo.toTile(context, onTap: () {
                    router.push(MemoDetailPage.query(memoId: memo.id));
                  });
                }
              ),
            ],
          ),
        );
        ```

## `fixedform`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the app bar.`や`// TODO: Implement the fixed view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            // TODO: Implement the app bar.
            title: const Text("ToDoリスト"),
          ),
          body: UniversalColumn(
            children: [
              // TODO: Implement the fixed view.
              FormLabel("タイトル"),
              FormTextField(
                form: formController,
                onSaved: (value) => formController.value.copyWith(title: value),
                hintText: "タイトルを入力してください",
              ),
              FormLabel("内容"),
              FormTextField(
                form: formController,
                onSaved: (value) => formController.value.copyWith(content: value),
                hintText: "内容を入力してください",
              ),
              FormButton(
                onPressed: () => formController.save(),
                child: const Text("保存"),
              ),
            ],
          ),
        );
        ```

## `listform`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the app bar.`や`// TODO: Implement the list view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            // TODO: Implement the app bar.
            title: const Text("ToDoリスト"),
          ),
          body: UniversalListView(
            children: [
              // TODO: Implement the list view.
              FormLabel("タイトル"),
              FormTextField(
                form: formController,
                onSaved: (value) => formController.value.copyWith(title: value),
                hintText: "タイトルを入力してください",
              ),
              FormLabel("内容"),
              FormTextField(
                form: formController,
                onSaved: (value) => formController.value.copyWith(content: value),
                hintText: "内容を入力してください",
              ),
              FormButton(
                onPressed: () => formController.save(),
                child: const Text("保存"),
              ),
            ],
          ),
        );
        ```

## `navigation`

実施しない

## `tab`

実施しない

## `page`

1. 対象のDartファイル（`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dart）を開く
2. `Page設計書`の`Content`に応じて`build`メソッド内の`// TODO: Implement the view.`以下を書き換え、適切なUIを構築し返す。
    - 適宜`import`を追加する
    - クラスに定義されている変数や`build`メソッド内で定義されている変数を利用する
    - 下記の`Widget`を優先的に利用する
        - `KatanaUI`の`Widget`(`documents/rules/docs/katana_ui_usage.md`)
        - `Flutter`の`Widget`(`documents/rules/docs/flutter_widgets.md`)
        - `Form`の`Widget`やインタラクティブな操作を行うフィールドの`Widget`(`documents/rules/docs/form_usage.md`)
        - `Widget`の実装において実装された`Widget`(`lib/widgets`)
    - `Router`を用いて別画面への遷移を行う。詳しくは`documents/rules/docs/router_usage.md`を参照
    - `Theme`を利用する場合は`lib/theme.dart`にある`theme`を参照。詳しくは`documents/rules/docs/theme_usage.md`を参照
    - 確認ダイアログやアラートなど`Modal`を利用する場合は`documents/rules/docs/modal_usage.md`を参照
    - 例：
        ```dart
        // TODO: Implement the view.
        return UniversalScaffold(
          appBar: UniversalAppBar(
            title: const Text("ToDoリスト"),
          ),
          body: Center(
            child: Text("Hello World"),
          )
        );
        ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
