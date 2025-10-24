// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of mock_data_usage.md.
///
/// mock_data_usage.mdの中身。
class MockDataUsageMdCliAiCode extends CliAiCode {
  /// Contents of mock_data_usage.md.
  ///
  /// mock_data_usage.mdの中身。
  const MockDataUsageMdCliAiCode();

  @override
  String get name => "モックデータについて";

  @override
  String get description => "モックデータについて";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## モックデータについて。

- Masamuneフレームワークではモックデータを利用してモックアプリの作成やテストを行う。
    - `RuntimeModelAdapter`に予めデータを設定しておきそれをアプリケーションやテストで利用することで`Model`経由で設定されたデータの読み書きをすることが可能。
    - `Model`の扱い方自体は`documents/rules/docs/model_usage.md`に記載されているのでそちらを参照。

### モックデータの実装方法
    - `lib/adapter.dart`内にある`RuntimeModelAdapter`の`initialValue`に`ModelInitialValue`を継承した値を追加していく
        - 各`Model`に対する`ModelInitialValue`は`MemoModelInitialCollection`のような形で実装されているのでそれを利用する
    - 各種`ModelInitialValue`は`String`をキー、対応する`Model`を値とする`Map`を渡して定義する
        - キーは基本的に32桁の英数字（e.g. `a23c3fad389a45b39c9b1f930b364466`）を定義
            - Masamuneフレームワーク（`package:masamune/masamune.dart`）に実装されている`generateCode(32, seed: n)`でランダムに生成可能
            - テスト用にいくつかは固定IDで作成することを推奨
    - `Collection`で利用する場合は10個程度のデータを用意
    - `ModelRef<AnyModel>`を参照する場合は`AnyModelRefPath(uid)`を渡すことで参照可能
        - `uid`は`AnyModelInitialCollection({uid: AnyModel()})`のように定義されていることが前提
    - 例：
        ```dart
        // lib/adapter.dart

        /// Test user id.
        /// 
        /// Please set up mock data using this.
        const testUserUid = "5da16680f3234c6a9781505cc9080909";

        /// Current time.
        /// 
        /// Set the current time for testing.
        /// 
        /// Please set up mock data using this.
        final testCurrentTime = Clock(2025, 1, 1, 12, 0, 0);

        /// App Model.
        /// 
        /// Testing model adapter.
        final runtimeModelAdapter = RuntimeModelAdapter(
          initialValue: [
            MemoModelInitialCollection({
              "a5ba9e241dd94d32b2d869d6bb3e804b" : MemoModel(
                title: "title 0",
                content: "content 0",
                createdBy: UserModelRefPath(testUserUid),
                createdAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: 0))),
                updatedAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: 0))),
              ),
              "2844e503e4d242c79f5f45e59d7adeb6" : MemoModel(
                title: "title 1",
                content: "content 1",
                createdBy: UserModelRefPath(testUserUid),
                createdAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: 1))),
                updatedAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: 1))),
              ),
              for (var i = 2; i < 10; i++)
              generateCode(32,  seed: i) : MemoModel(
                title: "title $i",
                content: "content $i",
                createdBy: UserModelRefPath(testUserUid),
                createdAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: i))),
                updatedAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: i))),
              ),
            }),
            UserModelInitialCollection({
              testUserUid: UserModel(
                name: "Main User",
                email: "main@example.com",
                createdAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: i))),
                updatedAt: ModelTimestamp(testCurrentTime.subtract(Duration(days: i))),
              ),
            }),
          ],
        );
        ```

### モックデータの利用方法

1. `MasamuneApp`に直接指定
    - すべての`Model`に対してモックデータを利用する場合はこの方法を推奨

    ```dart
    // lib/main.dart
    
    /// App.
    void main() {
      runMasamuneApp(
        (ref) => MasamuneApp(
          title: title,
          appRef: appRef,
          theme: theme,
          routerConfig: router,
          localize: l,
          authAdapter: authAdapter,
          modelAdapter: runtimeModelAdapter,
          storageAdapter: storageAdapter,
          functionsAdapter: functionsAdapter,
          masamuneAdapters: ref.adapters,
          loggerAdapters: ref.loggerAdapters,
          navigatorObservers: ref.navigatorObservers,
        ),
        masamuneAdapters: masamuneAdapters,
        loggerAdapters: loggerAdapters,
      );
    }
    ```

2. 個別の`Model`に対してモックデータを利用する場合

    ```dart
    // lib/models/user.dart
    
    /// Value for model.
    @freezed
    @formValue
    @immutable
    @CollectionModelPath(
      "user",
      adapter: runtimeModelAdapter,
      // runtimeModelAdapterがconst出ない場合は
      // adapter: "runtimeModelAdapter"
      // のように文字列で変数名を指定する。（importは必要）
    )
    abstract class UserModel with _$UserModel {
      /// Value for model.
      const factory UserModel({
        String? name,
        ModelImageUri? image,
        ModelDate? birth,
        String? description,

    ~~~~
    ```

3. テストでの利用方法
    - テストではtest/flutter_test_config.dart`にある`MasamuneTestConfig`に`runtimeModelAdapter`を指定することでモックデータを利用することが可能。

    ```dart
    // test/flutter_test_config.dart

    /// Performing test initialization.
    Future<void> testExecutable(FutureOr<void> Function() testMain) {
      return MasamuneTestConfig.initialize(
        run: testMain,
        initialUserId: "01979a941df17912ad971dc123cc75da",
        theme: theme,
        modelAdapter: runtimeModelAdapter,
        authAdapter: runtimeAuthAdapter,
        storageAdapter: runtimeStorageAdapter,
        functionsAdapter: runtimeFunctionsAdapter,
        loggerAdapters: runtimeLoggerAdapters,
        masamuneAdapters: runtimeMasamuneAdapters,
      );
    }
    ```
""";
  }
}
