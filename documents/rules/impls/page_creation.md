# `Page`の作成

`documents/designs/page_design.md`に記載されている`Page設計書`からDartコードを生成
`documents/designs/page_design.md`が存在しない場合は絶対に実施しない

`Page設計書`に記載されている各`Page`の`PageType`に応じてそれぞれ下記を実行

## `listview`

1. 下記のコマンドを実行して`listview`のViewを作成。

    ```shell
    katana code view listview [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. 作成された`PageScopedWidget`を継承したクラス内の`// TODO: Set parameters for the page in the form [final String xxx].`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the page.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
    - 例：
        ```dart
        // lib/pages/memo.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo.page.dart";

        /// Page widget for Memo.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("memo")
        class MemoPage extends PageScopedWidget {
          const MemoPage({
            super.key,
            // TODO: Set parameters for the page.
            required this.memoId,
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          final String memoId;

          /// Used to transition to the MemoPage screen.
          ///
          /// ```dart
          /// router.push(MemoPage.query(parameters));    // Push page to MemoPage.
          /// router.replace(MemoPage.query(parameters)); // Replace page to MemoPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoPageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalListView(
                children: [
                  // TODO: Implement the list view.
                  
                ]
              ),
            );
          }
        }
        ```
5. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `gridview`

1. 下記のコマンドを実行して`gridview`のViewを作成。

    ```shell
    katana code view gridview [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. 作成された`PageScopedWidget`を継承したクラス内の`// TODO: Set parameters for the page in the form [final String xxx].`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the page.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
    - 例：
        ```dart
        // lib/pages/memo.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo.page.dart";

        /// Page widget for Memo.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("memo")
        class MemoPage extends PageScopedWidget {
          const MemoPage({
            super.key,
            // TODO: Set parameters for the page.
            required this.memoId,
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          final String memoId;

          /// Used to transition to the MemoPage screen.
          ///
          /// ```dart
          /// router.push(MemoPage.query(parameters));    // Push page to MemoPage.
          /// router.replace(MemoPage.query(parameters)); // Replace page to MemoPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoPageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalGridView(
                children: [
                  // TODO: Implement the grid view.
                  
                ]
              ),
            );
          }
        }
        ```
5. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `fixedview`

1. 下記のコマンドを実行して`fixedview`のViewを作成。

    ```shell
    katana code view fixedview [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. 作成された`PageScopedWidget`を継承したクラス内の`// TODO: Set parameters for the page in the form [final String xxx].`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the page.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
    - 例：
        ```dart
        // lib/pages/memo.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo.page.dart";

        /// Page widget for Memo.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("memo")
        class MemoPage extends PageScopedWidget {
          const MemoPage({
            super.key,
            // TODO: Set parameters for the page.
            required this.memoId,
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          final String memoId;

          /// Used to transition to the MemoPage screen.
          /// 
          /// ```dart
          /// router.push(MemoPage.query(parameters));    // Push page to MemoPage.
          /// router.replace(MemoPage.query(parameters)); // Replace page to MemoPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoPageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalColumn(
                children: [
                  // TODO: Implement the fixed view.
                  
                ],
              ),
            );
          }
        }
        ```
5. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `fixedform_add`

1. 下記のコマンドを実行して`fixedform_add`のViewを作成。

    ```shell
    katana code view fixedform_add [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
    - 例：
        ```dart
        // lib/pages/memo_add.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo_add.page.dart";

        /// Page for forms to add data.
        @immutable
        @PagePath("memo/add")
        class MemoAddPage extends FormAddPageScopedWidget {
          const MemoAddPage({
            super.key,
          });

          /// Used to transition to the MemoAddPage screen.
          ///
          /// ```dart
          /// router.push(MemoAddPage.query(parameters));    // Push page to MemoAddPage.
          /// router.replace(MemoAddPage.query(parameters)); // Replace page to MemoAddPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoAddPageQuery();

          @override
          FormScopedWidget build(BuildContext context, PageRef ref) =>
              const _MemoAddForm();
        }

        /// Widgets for form views.
        @immutable
        class _MemoAddForm extends FormScopedWidget {
          const _MemoAddForm({super.key});

          @override
          Widget build(BuildContext context, FormRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // 
            // You can use [ref.isAdding] or [ref.isEditing] to determine if the form is currently adding new data or editing data.
            //
            // If editing is in progress, it is possible to get the ID of the item being edited with [ref.editId].
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalColumn(
                children: [
                  // TODO: Implement the fixed view.
                  
                ],
              ),
            );
          }
        }
        ```
3. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `fixedform_edit`

1. 下記のコマンドを実行して`fixedform_edit`のViewを作成。

    ```shell
    katana code view fixedform_edit [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
    - 例：
        ```dart
        // lib/pages/memo_edit.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo_edit.page.dart";

        /// Page for forms to edit data.
        @immutable
        @PagePath("memo/:edit_id/edit")
        class MemoEditPage extends FormEditPageScopedWidget {
          const MemoEditPage({
            @PageParam("edit_id") required super.editId,
            super.key,
          });

          /// Used to transition to the MemoEditPage screen.
          ///
          /// ```dart
          /// router.push(MemoEditPage.query(parameters));    // Push page to MemoEditPage.
          /// router.replace(MemoEditPage.query(parameters)); // Replace page to MemoEditPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoEditPageQuery();

          @override
          FormScopedWidget build(BuildContext context, PageRef ref) =>
              const _MemoEditForm();
        }

        /// Widgets for form views.
        @immutable
        class _MemoEditForm extends FormScopedWidget {
          const _MemoEditForm({super.key});

          @override
          Widget build(BuildContext context, FormRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // 
            // You can use [ref.isAdding] or [ref.isEditing] to determine if the form is currently adding new data or editing data.
            //
            // If editing is in progress, it is possible to get the ID of the item being edited with [ref.editId].
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalColumn(
                children: [
                  // TODO: Implement the fixed view.
                  
                ],
              ),
            );
          }
        }
        ```
3. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `listform_add`

1. 下記のコマンドを実行して`listform_add`のViewを作成。

    ```shell
    katana code view listform_add [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
    - 例：
        ```dart
        // lib/pages/memo_add.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo_add.page.dart";

        /// Page for forms to add data.
        @immutable
        @PagePath("memo/add")
        class MemoAddPage extends FormAddPageScopedWidget {
          const MemoAddPage({
            super.key,
          });

          /// Used to transition to the MemoAddPage screen.
          ///
          /// ```dart
          /// router.push(MemoAddPage.query(parameters));    // Push page to MemoAddPage.
          /// router.replace(MemoAddPage.query(parameters)); // Replace page to MemoAddPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoAddPageQuery();

          @override
          FormScopedWidget build(BuildContext context, PageRef ref) =>
              const _MemoAddForm();
        }

        /// Widgets for form views.
        @immutable
        class _MemoAddForm extends FormScopedWidget {
          const _MemoAddForm({super.key});

          /// Used to transition to the MemoAddPage screen.
          ///
          /// ```dart
          /// router.push(MemoForm.addQuery(parameters));    // Push page to MemoAddPage.
          /// router.replace(MemoForm.addQuery(parameters)); // Replace page to MemoAddPage.
          /// ```
          static const addQuery = MemoAddPage.query;

          /// Used to transition to the MemoEditPage screen.
          ///
          /// ```dart
          /// router.push(MemoForm.editQuery(parameters));    // Push page to MemoEditPage.
          /// router.replace(MemoForm.editQuery(parameters)); // Replace page to MemoEditPage.
          /// ```
          static const editQuery = MemoEditPage.query;

          @override
          Widget build(BuildContext context, FormRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // 
            // You can use [ref.isAdding] or [ref.isEditing] to determine if the form is currently adding new data or editing data.
            //
            // If editing is in progress, it is possible to get the ID of the item being edited with [ref.editId].
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalListView(
                children: [
                  // TODO: Implement the list view.
                  
                ],
              ),
            );
          }
        }
        ```
3. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `listform_edit`

1. 下記のコマンドを実行して`listform_edit`のViewを作成。

    ```shell
    katana code view listform_edit [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
    - 例：
        ```dart
        // lib/pages/memo_edit.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo_edit.page.dart";

        /// Page for forms to edit data.
        @immutable
        @PagePath("memo/:edit_id/edit")
        class MemoEditPage extends FormEditPageScopedWidget {
          const MemoEditPage({
            @PageParam("edit_id") required super.editId,
            super.key,
          });

          /// Used to transition to the MemoEditPage screen.
          ///
          /// ```dart
          /// router.push(MemoEditPage.query(parameters));    // Push page to MemoEditPage.
          /// router.replace(MemoEditPage.query(parameters)); // Replace page to MemoEditPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoEditPageQuery();

          @override
          FormScopedWidget build(BuildContext context, PageRef ref) =>
              const _MemoEditForm();
        }

        /// Widgets for form views.
        @immutable
        class _MemoEditForm extends FormScopedWidget {
          const _MemoEditForm({super.key});

          @override
          Widget build(BuildContext context, FormRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // 
            // You can use [ref.isAdding] or [ref.isEditing] to determine if the form is currently adding new data or editing data.
            //
            // If editing is in progress, it is possible to get the ID of the item being edited with [ref.editId].
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              appBar: UniversalAppBar(
                // TODO: Implement the app bar.
                
              ),
              body: UniversalListView(
                children: [
                  // TODO: Implement the list view.
                  
                ],
              ),
            );
          }
        }
        ```
3. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `navigation`

1. 下記のコマンドを実行して`navigation`のViewを作成。

    ```shell
    katana code view navigation [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. `navigation`の中で表示する`Page`一覧に応じてenum内の`// TODO: Define the type of navigation.`、`// TODO: Specify a label for each navigation.`、`// TODO: Specify a icon for each navigation.`、`// TODO: Specify a RouteQuery for each navigation.`を書き換える。
4. 3で定義した`Page`の一覧から最初に表示する`Page`を`// TODO: Specify the initial navigation.`に設定する。
    - 例：
        ```dart
        // lib/pages/index.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "index.page.dart";

        /// Define a list of navigation for use with IndexPage.
        enum IndexPageNavigation {
          // TODO: Define the type of navigation.
          home,
          search,
          mypage;

          /// The first navigation to display.
          // TODO: Specify the initial navigation.
          static const IndexPageNavigation initialNavigation = IndexPageNavigation.home;

          /// Get the label of IndexPageNavigation.
          // TODO: Specify a label for each navigation.
          String get label {
            switch (this) {
              case IndexPageNavigation.home:
                return "Home";
              case IndexPageNavigation.search:
                return "Search";
              case IndexPageNavigation.mypage:
                return "MyPage";
            }
          }


          /// Get the icon of IndexPageNavigation.
          // TODO: Specify a icon for each navigation.
          Widget get icon {
            switch (this) {
              case IndexPageNavigation.home:
                return const Icon(Icons.home);
              case IndexPageNavigation.search:
                return const Icon(Icons.search);
              case IndexPageNavigation.mypage:
                return const Icon(Icons.person);
            }
          }

          /// Get the route query of IndexPageNavigation.
          // TODO: Specify a RouteQuery for each navigation.
          RouteQuery? get routeQuery {
            switch (this) {
              case IndexPageNavigation.home:
                return HomePage.query();
              case IndexPageNavigation.search:
                return SearchPage.query();
              case IndexPageNavigation.mypage:
                return MypagePage.query();
            }
          }
        }

        /// Page widget for Index.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("index")
        class IndexPage extends PageScopedWidget {
          const IndexPage({
            super.key,
            // TODO: Set parameters for the page.
            
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          

          /// Used to transition to the IndexPage screen.
          ///
          /// ```dart
          /// router.push(IndexPage.query(parameters));    // Push page to IndexPage.
          /// router.replace(IndexPage.query(parameters)); // Replace page to IndexPage.
          /// ```
          @pageRouteQuery
          static const query = _$IndexPageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            final nestedRouter = ref.page.router(
              initialQuery: IndexPageNavigation.initialNavigation.routeQuery,
              pages: [],
            );
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold(
              body: Router.withConfig(config: nestedRouter),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: theme.color.background,
                selectedItemColor: theme.color.primary,
                unselectedItemColor: theme.color.weak,
                type: BottomNavigationBarType.fixed,
                currentIndex: nestedRouter.currentQuery?.key<IndexPageNavigation>()?.index ??
                    IndexPageNavigation.initialNavigation.index,
                onTap: (index) {
                  final routeQuery = IndexPageNavigation.values[index].routeQuery;
                  if (routeQuery == null) {
                    return;
                  }
                  nestedRouter.push(routeQuery);
                },
                items: [
                  ...IndexPageNavigation.values.map((e) {
                    return BottomNavigationBarItem(
                      icon: e.icon,
                      label: e.label,
                    );
                  }),
                ],
              ),
            );
          }
        }
        ```
5. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `tab`

1. 下記のコマンドを実行して`tab`のViewを作成。

    ```shell
    katana code view tab [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. `tab`の中で表示する`Page`一覧に応じてenum内の`// TODO: Define the type of tabs.`、`// TODO: Specify a label for each tab.`、`// TODO: Specify a widget for each tab.`を書き換える。
4. 3で定義した`Page`の一覧から最初に表示する`Page`を`// TODO: Specify the initial tab.`に設定する。
    - 例：
        ```dart
        // lib/pages/home.dart
        
        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "home.page.dart";

        /// Define a list of tabs for use with HomePage.
        enum HomePageTab {
          // TODO: Define the type of tabs.
          companyList,
          userList;

          /// The first tab to display.
          // TODO: Specify the initial tab.
          static const HomePageTab initialTab = HomePageTab.companyList;

          /// Get the label of HomePageTab.
          // TODO: Specify a label for each tab.
          String get label {
            switch (this) {
              case HomePageTab.companyList:
                return "Company List";
              case HomePageTab.userList:
                return "User List";
            }
          }

          /// Get the view widget of HomePageTab.
          // TODO: Specify a widget for each tab.
          Widget get view {
            switch (this) {
              case HomePageTab.companyList:
                return const CompanyListPage();
              case HomePageTab.userList:
                return const UserListPage();
            }
          }
        }

        /// Page widget for Home.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("home")
        class HomePage extends PageScopedWidget {
          const HomePage({
            super.key,
            // TODO: Set parameters for the page.
            
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          

          /// Used to transition to the HomePage screen.
          ///
          /// ```dart
          /// router.push(HomePage.query(parameters));    // Push page to HomePage.
          /// router.replace(HomePage.query(parameters)); // Replace page to HomePage.
          /// ```
          @pageRouteQuery
          static const query = _$HomePageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            

            final tabBar = TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.start,
              tabs: [
                ...HomePageTab.values.map((e) => Tab(text: e.label)),
              ],
            );
            final tabView = TabBarView(
              children: [
                ...HomePageTab.values.map((e) => e.view),
              ],
            );

            // Describes the structure of the page.
            // TODO: Implement the view.
            return DefaultTabController(
              initialIndex: HomePageTab.initialTab.index,
              length: HomePageTab.values.length,
              child: UniversalScaffold(
                appBar: UniversalAppBar(
                  bottom: tabBar,
                ),
                body: tabView,
              ),
            );
          }
        }
        ```
5. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

## `page`

1. 下記のコマンドを実行して`page`のViewを作成。

    ```shell
    katana code view page [PageName(SnakeCase&末尾のPageを取り除く)]
    ```

2. コマンド実行後、`lib/pages`以下に[PageName(SnakeCase&末尾のPageを取り除く)].dartファイルが作成される
3. 作成された`PageScopedWidget`を継承したクラス内の`// TODO: Set parameters for the page in the form [final String xxx].`以下に`Properties`に応じた`final`変数を定義
4. 3で定義した`final`変数に対するコンストラクタのパラメーターを`// TODO: Set parameters for the page.`以下に定義
    - プロパティの状態に応じて下記を実施
        - `RequiredOrOptional`が`Required`な場合は先頭に`required`をつける
        - `DefaultValue`な場合は末尾に`= [DefaultValue]`をつける
    - 例：
        ```dart
        // lib/pages/memo.dart

        // ignore: unused_import, unnecessary_import
        import "package:flutter/material.dart";
        // ignore: unused_import, unnecessary_import
        import "package:masamune/masamune.dart";
        import "package:masamune_universal_ui/masamune_universal_ui.dart";

        // ignore: unused_import, unnecessary_import
        import "package:flutter_masamune/main.dart";

        part "memo.page.dart";

        /// Page widget for Memo.
        @immutable
        // TODO: Set the path for the page.
        @PagePath("memo")
        class MemoPage extends PageScopedWidget {
          const MemoPage({
            super.key,
            // TODO: Set parameters for the page.
            required this.memoId,
          });

          // TODO: Set parameters for the page in the form [final String xxx].
          final String memoId;

          /// Used to transition to the MemoPage screen.
          /// 
          /// ```dart
          /// router.push(MemoPage.query(parameters));    // Push page to MemoPage.
          /// router.replace(MemoPage.query(parameters)); // Replace page to MemoPage.
          /// ```
          @pageRouteQuery
          static const query = _$MemoPageQuery();

          @override
          Widget build(BuildContext context, PageRef ref) {
            // Describes the process of loading
            // and defining variables required for the page.
            // TODO: Implement the variable loading process.
            

            // Describes the structure of the page.
            // TODO: Implement the view.
            return UniversalScaffold();
          }
        }
        ```
5. 4で変更したコンストラクタのパラメーターに合わせて`test/pages`以下に同じく作成された[PageName(SnakeCase&末尾のPageを取り除く)]_test.dartファイルの同一クラスの定義を書き換えエラーを解消する。
    - パラメーターはこの時点では自由に設定。
        - モックデータ作成後それに応じてパラメーターを有効なものに変更。
    - 例：
        ```dart
        // test/pages/memo_test.dart

        void main() {
          masamunePageTest(
            name: "MemoPage",
            builder: (context, ref) {
              // TODO: Write test code.
              return const MemoPage(memoId: "1");      
            },
          );
        }
        ```
6. 最後に下記コマンドで残りのコードを自動生成する

    ```shell
    katana code generate
    ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
