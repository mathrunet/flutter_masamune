# `Router`の実装

`documents/designs/page_design.md`に記載されている`Page設計書`から`lib/router.dart`を編集
`documents/designs/page_design.md`が存在しない場合は絶対に実施しない

1. `Page設計書`で定義されている内容を元に`lib/router.dart`を書き換える
    - `lib/router.dart`の`AppRouter`を変更
      - `Page`の中でトップページとなる`Page`を選出
        - 基本的には`PagePath`が`/`の`Page``を設定
      - `AppRouter`の`initialQuery`にトップページの`Page`に対する`[PageID(PascalCase&末尾にPageが付与されている)].query()`を設定

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
