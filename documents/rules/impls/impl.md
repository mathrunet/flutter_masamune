# すべての`設計書`の実装

`documents/designs/**/*.md`に記載されている各種`設計書`から実装を行う。
下記の順番通りにステップごとに実施

1. `MetaDataの実装`
    - `documents/rules/impls/metadata_impl.md`を参照し、`documents/designs/metadata_design.md`に記載されている`MetaData設計書`から`MetaData`を実装
2. `Pluginの実装`
    - `documents/rules/impls/plugin_impl.md`を参照し、`documents/designs/plugin_design.md`に記載されている`Plugin設計書`から`Plugin`を実装
3. `Themeの実装`
    - `documents/rules/impls/theme_impl.md`を参照し、`documents/designs/theme_design.md`に記載されている`Theme設計書`から`Theme`を実装
4. `Modelの実装`
    - `documents/rules/impls/model_impl.md`を参照し、`documents/designs/model_design.md`に記載されている`Model設計書`から`Model`を実装
5. `Controllerの実装`
    - `documents/rules/impls/controller_impl.md`を参照し、`documents/designs/controller_design.md`に記載されている`Controller設計書`から`Controller`を実装
    - 下記の細かいステップを実施
        1. `Controller`の作成
            - `documents/rules/impls/controller_creation.md`を参照して、`Controller`を作成
        2. `Controller`の各種メソッドの作成
            - 1で作成した`Controller`に対して、`documents/rules/impls/controller_method_creation.md`を参照して、`Controller`の各種メソッドを作成
        3. `Controller`の実装
            - 1で作成した`Controller`と2で作成した各種メソッドに対して、`documents/rules/impls/controller_method_impl.md`を参照して、`Controller`の各種メソッドの中身を実装
6. `Widgetの実装`
    - `documents/rules/impls/widget_impl.md`を参照し、`documents/designs/widget_design.md`に記載されている`Widget設計書`から`Widget`を実装
    - 下記の細かいステップを実施
        1. `Widget`の作成
            - `documents/rules/impls/widget_creation.md`を参照して、`Widget`を作成
        2. `Widget`のロジックの実装
            - 1で作成した`Widget`に対して、`documents/rules/impls/widget_logic_impl.md`を参照して、`Widget`のロジックを実装
        3. `Widget`のUIの実装
            - 1で作成した`Widget`に対して、2で作成した`Widget`のロジックを用いながら`documents/rules/impls/widget_ui_impl.md`を参照して、`Widget`のUIを実装
7. `Pageの実装`
    - `documents/rules/impls/page_impl.md`を参照し、`documents/designs/page_design.md`に記載されている`Page設計書`から`Page`を実装
    - 下記の細かいステップを実施
        1. `Page`の作成
            - `documents/rules/impls/page_creation.md`を参照して、`Page`を作成
        2. `Page`のロジックの実装
            - 1で作成した`Page`に対して、`documents/rules/impls/page_logic_impl.md`を参照して、`Page`のロジックを実装
        3. `Page`のUIの実装
            - 1で作成した`Page`に対して、2で作成した`Page`のロジックを用いながら`documents/rules/impls/page_ui_impl.md`を参照して、`Page`のUIを実装
8. `Routerの実装`
    - `documents/rules/impls/router_impl.md`を参照し、`Router`の設定を実装
9. `モックデータの実装`
    - `documents/rules/impls/mock_data_impl.md`を参照し各種`モックデータ`を実装

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
