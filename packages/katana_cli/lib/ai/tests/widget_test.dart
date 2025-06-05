// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of widget_test.md.
///
/// widget_test.mdの中身。
class WidgetTestMdCliAiCode extends CliAiCode {
  /// Contents of widget_test.md.
  ///
  /// widget_test.mdの中身。
  const WidgetTestMdCliAiCode();

  @override
  String get name => "`Widget`のテストの実装";

  @override
  String get globs => "lib/**/*.dart";

  @override
  String get directory => "tests";

  @override
  String get description => "`Widget`のテストの実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`test/widgets`フォルダに作成されているテストファイルを下記の手順で修正する。
各テストファイルに対応する`Widget`は`lib/widgets`フォルダに作成されている。

1. `test/widgets`フォルダに作成されているテストファイルを修正。
    - `test/widgets/**/*_test.dart`ファイルを開く。
    - 対応する`lib/widgets/**/*.dart`ファイルを開き、コンストラクタを確認。引数が一致していなければ修正する。
        - 引数に渡す値の型がDart/Flutterの`プリミティブタイプ`であれば自由に決めてよい。
            - ただし、`xxxId`といった`Model`に紐づくIDであれば、`lib/adapter.dart`内に記載されている対応するモックデータのIDを記載する。
        - 引数に渡す値の型が`Model`であれば必要な処理を`masamuneWidgetTest`の`loader`に記載し値を返す。返した値は`builder`の`value`に渡されるので、（必要であれば値のNullチェックを行ったうえで）その値を引数に渡す。
            - `Model`の読み込みにIDが必要な場合は、`lib/adapter.dart`内に記載されている対応するモックデータのIDを記載する。
        - 複数の`Model`や`Future`の読み込みが必要な場合はRecordsとして返す。
    - 例：通常の修正方法
        ```dart
        // test/widgets/memo_tile_test.dart

        void main() {
          masamuneWidgetTest(
            name: "MemoTileWidget",
            builder: (context, ref, value) {
              // TODO: Write test code.
              return const MemoTileWidget(
                title: Text("Memo Title"),
              );
            },
          );
        }
        ```
    - 例：Model IDを渡す場合
        ```dart
        // test/widgets/memo_tile_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`が定義されている前提

        void main() {
          masamuneWidgetTest(
            name: "MemoTileWidget",
            builder: (context, ref, value) {
              // TODO: Write test code.
              return const MemoLoaderWidget(
                memoId: "5972db7b4c9b4ab59ca6f31512c2bfab",
              );
            },
          );
        }
        ```
    - 例：`Document`の`Model`を渡す場合
        ```dart
        // test/widgets/memo_tile_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`が定義されている前提

        void main() {
          masamuneWidgetTest(
            name: "MemoTileWidget",
            loader: (context, ref) async {
              final value = ref.appRef.model(MemoModel.document("5972db7b4c9b4ab59ca6f31512c2bfab"));
              await value.load();
              return value;
            },
            builder: (context, ref, value) {
              if (value == null) {
                return const Empty();
              }
              // TODO: Write test code.
              return const MemoLoaderWidget(
                memoDocument: value,
              );
            },
          );
        }
        ```
    - 例：複数の`Document`の`Model`を渡す場合
        ```dart
        // test/widgets/memo_tile_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`と`5da16680f3234c6a9781505cc9080909`のIDを持つ`UserModel`が定義されている前提

        void main() {
          masamuneWidgetTest(
            name: "MemoTileWidget",
            loader: (context, ref) async {
              final memoValue = ref.appRef.model(MemoModel.document("5972db7b4c9b4ab59ca6f31512c2bfab"));
              final userValue = ref.appRef.model(UserModel.document("5da16680f3234c6a9781505cc9080909"));
              await (memoValue.load(), userValue.load()).wait;
              return (memoValue: memoValue, userValue: userValue);
            },
            builder: (context, ref, value) {
              if (value == null) {
                return const Empty();
              }
              // TODO: Write test code.
              return const MemoLoaderWidget(
                memoDocument: value.memoValue,
                userDocument: value.userValue,
              );
            },
          );
        }
        ```
2. `Widget`のゴールデンテスト用の画像ファイルの生成
    - `Widget`のテストを新しく作成した場合や`Widget`の更新を行った場合、下記のコマンドでゴールデンテスト用の画像ファイルを生成する。
        - 新規に作成したり更新していない`Widget`の場合は画像ファイルは作成しない。

        ```bash
        katana test update [Widget名],[Widget名],...
        ```

        - 例
            ```bash
            katana test update MemoTileWidget,MemoLoaderWidget
            ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
