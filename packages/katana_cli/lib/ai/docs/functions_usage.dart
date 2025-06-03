// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of functions_usage.md.
///
/// functions_usage.mdの中身。
class FunctionsUsageDocsMdCliAiCode extends CliAiCode {
  /// Contents of functions_usage.md.
  ///
  /// functions_usage.mdの中身。
  const FunctionsUsageDocsMdCliAiCode();

  @override
  String get name => "`Functions`の実装方法とその利用方法";

  @override
  String get description => "サーバーの処理を実行する`Functions`の実装方法とその利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## `Functions`の実装方法

新しく`Functions`を作成する場合は下記の流れに沿って実装を行う。種類に応じて実施するコマンドが異なる。
`firebase/firebase.json`が存在しない場合は実施不可能。

### サーバー側の`Functions`を直接呼び出す`Server Call`の場合

1. 下記のコマンドを実行しファイル作成

    ```bash
    katana code server call [FunctionName(SnakeCase)]
    ```

2. 下記にファイルが作成される
    - `firebase/functions/src/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`にデプロイされるコード。こちらにはサーバー側のコードを記載
    - `firebase/functions/test/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`のテストコード。こちらにはサーバー側のコードをテストするためのコードを記載
    - `lib/functions/[FunctionName(SnakeCase)].dart`
        - `Flutter`用のコード。こちらにはサーバー側のコードを呼び出し、返答を受け取るメソッドを記載

3. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`process`メソッド内にコードを記載
    - `query.data.xxx`から`Functions`に渡された引数を取得できる
    - `{[key: string]: any}`をreturnすることで`Functions`のレスポンスを送信することができる
    - エラーが発生した場合は`throw new functions.https.HttpsError`を実行
    - 例：
        ```typescript
        const companyId = query.data.companyId as string | null | undefined;
        const userId = query.data.userId as string | null | undefined;
        if (!companyId || !userId) {
            throw new functions.https.HttpsError(
                "invalid-argument", "Invalid argument."
            );
        }
        return {
            "companyId": companyId,
            "userId": userId,
        };
        ```
4. `lib/functions/[FunctionName(SnakeCase)].dart`の`FunctionsAction`クラスの`toMap`メソッドに`Functions`実行時に渡す引数を記載
5. `lib/functions/[FunctionName(SnakeCase)].dart`の`TestFunctionsActionResponse`クラスにレスポンスを格納できるように修正
    - 例：
        ```dart
        // lib/functions/test.dart
        
        /// [FunctionsAction] for calling `test_call` in FirebaseFunctions.
        ///
        /// FirebaseFunctionsの`test_call`をコールするための[FunctionsAction]。
        ///
        /// ```dart
        /// final response = await appFunction.execute(TestFunctionsAction());
        /// ```
        class TestFunctionsAction
            extends FunctionsAction<TestFunctionsActionResponse> {
          /// [FunctionsAction] for calling `test_call` in FirebaseFunctions.
          ///
          /// FirebaseFunctionsの`test_call`をコールするための[FunctionsAction]。
          ///
          /// ```dart
          /// final response = await appFunction.execute(TestFunctionsAction());
          /// ```
          const TestFunctionsAction({
            /// 渡す引数
            required this.companyId,
            required this.userId,
          });

          /// 渡す引数
          final String companyId;
          final String userId;

          @override
          String get action => "test_call";

          @override
          DynamicMap? toMap() {
            return {
              // 渡す引数を格納
              "companyId": companyId,
              "userId": userId,
            };
          }

          @override
          TestFunctionsActionResponse toResponse(DynamicMap map) {
            return TestFunctionsActionResponse(
              // レスポンスをそのまま渡す
              companyId: map["companyId"] as String,
              userId: map["userId"] as String,
            );
          }
        }

        /// [FunctionsActionResponse] that defines the response to [TestFunctionsAction].
        ///
        /// [TestFunctionsAction]のレスポンスを定義する[FunctionsActionResponse]。
        class TestFunctionsActionResponse extends FunctionsActionResponse {
          /// [FunctionsActionResponse] that defines the response to [TestFunctionsAction].
          ///
          /// [TestFunctionsAction]のレスポンスを定義する[FunctionsActionResponse]。
          const TestFunctionsActionResponse({
            // レスポンスを格納
            required this.companyId,
            required this.userId,
          });

          // レスポンスを格納
          final String companyId;
          final String userId;
        }
        ```

6. `lib/main.dart`にある`appFunction`を用いることで`Functions`を呼び出すことができる
    - 例：
        ```dart
        final TestFunctionsActionResponse response = await appFunction.execute(
            TestFunctionsAction(
                companyId: "companyId",
                userId: "userId",
            ),
        );

        print(response.companyId);
        print(response.userId);
        ```

### Http経由でサーバーの`Functions`を呼び出す`Http Request`の場合

1. 下記のコマンドを実行しファイル作成

    ```bash
    katana code server request [FunctionName(SnakeCase)]
    ```

2. 下記にファイルが作成される
    - `firebase/functions/src/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`にデプロイされるコード。こちらにはサーバー側のコードを記載
    - `firebase/functions/test/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`のテストコード。こちらにはサーバー側のコードをテストするためのコードを記載

3. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`process`メソッド内にコードを記載
    - `request.params.xxx`から`Functions`に渡された引数を取得できる
    - `response.status(200).send(responseBody);`を実行することでステータスコード200のレスポンスを返すことができる
    - `response.status(400).send(responseBody);`を実行することでステータスコード400のレスポンスを返すことができる
    - 例：
        ```typescript
        const companyId = request.params.companyId as string | null | undefined;
        const userId = request.params.userId as string | null | undefined;
        if (!companyId || !userId) {
            response.status(400).send({ 
                "error": "Invalid argument.",
            });
            return;
        }
        response.status(200).send({
            "companyId": companyId,
            "userId": userId,
        });
        ```

### 定期的にサーバーの`Functions`を呼び出す`Schedule`の場合

1. 下記のコマンドを実行しファイル作成

    ```bash
    katana code server schedule [FunctionName(SnakeCase)]
    ```

2. 下記にファイルが作成される
    - `firebase/functions/src/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`にデプロイされるコード。こちらにはサーバー側のコードを記載
    - `firebase/functions/test/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`のテストコード。こちらにはサーバー側のコードをテストするためのコードを記載

3. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`scuedule`変数に`Functions`を呼び出す間隔を記載
    - `CronTab`や`Cloud Functions for Firebase`の`schedule`を指定することが可能
    - 例：
        ```typescript
        const schedule = "0 0 * * *";
        ```

4. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`process`メソッド内にコードを記載


### Firestoreトリガーを利用する`Firestore Trigger`の場合

1. 下記のコマンドを実行しファイル作成

    ```bash
    katana code server firestore [FunctionName(SnakeCase)]
    ```

2. 下記にファイルが作成される
    - `firebase/functions/src/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`にデプロイされるコード。こちらにはサーバー側のコードを記載
    - `firebase/functions/test/[FunctionName(SnakeCase)].ts`
        - `Cloud Functions for Firebase`のテストコード。こちらにはサーバー側のコードをテストするためのコードを記載

3. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`path`変数内にトリガーの実行を監視するFirestoreの`Document`のパスを記載
    - `my-collection/{docId}`の形で`{}`で囲んだ部分は任意の文字列となる
    - 例：
        ```typescript
        const path = "my-collection/{docId}";
        ```

4. `firebase/functions/src/[FunctionName(SnakeCase)].ts`の`process`メソッド内にコードを記載
    - `event.params.xxx`からFirestoreの`Document`のパスに含まれる任意の文字列を取得できる
    - `event.data.after`および`event.data.before`からFirestoreの`Document`のデータの変更前後を取得できる
        - `event.data.after`および`event.data.before`は`null`の場合があり、`null`の状態に応じて処理を分岐させることができる
            - `event.data.before`が`null`かつ`event.data.after`が`null`でない場合は`Document`が作成されたということを意味する
            - `event.data.before`が`null`でなく`event.data.after`が`null`の場合は`Document`が削除されたということを意味する
            - `event.data.before`も`event.data.after`も`null`でない場合は`Document`が更新されたということを意味する
    - 例：
        ```typescript
        const docId = event.params.docId as string | null | undefined;
        if (!docId) {
            throw new functions.https.HttpsError("invalid-argument", "Invalid argument.");
        }
        ```
""";
  }
}
