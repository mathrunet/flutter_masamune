// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of model_extension_test.md.
///
/// model_extension_test.mdの中身。
class ModelExtensionTestMdCliAiCode extends CliAiCode {
  /// Contents of model_extension_test.md.
  ///
  /// model_extension_test.mdの中身。
  const ModelExtensionTestMdCliAiCode();

  @override
  String get name => "`Model`の`toTile`拡張メソッドの実装";

  @override
  String get globs => "lib/**/*.dart";

  @override
  String get directory => "tests";

  @override
  String get description => "`Model`の`toTile`拡張メソッドの実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`test/models`フォルダに作成されているテストファイルを下記の手順で修正する。
各テストファイルに対応する`Model`の`toTile`拡張メソッドは`lib/models`フォルダの`*.extension.dart`ファイルに定義されている。

1. `test/models`フォルダに作成されているテストファイルを修正。
    - `test/models/**/*_test.dart`ファイルを開く。
    - 対応する`lib/models/**/*.extension.dart`ファイルを開き、引数を確認。引数が一致していなければ修正する。
    - `toTile`メソッドの読み込みに必要な`Model`の`Document`を`masamuneModelTest`の`document`に渡す。
    - 例：`MemoModel`の`Document`を渡す場合
        ```dart
        // test/models/memo_model_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`が定義されている前提

        void main() {
          masamuneModelTest(
            name: "MemoModel",
            document: (context, ref) => ref.appRef.model(MemoModel.document("5972db7b4c9b4ab59ca6f31512c2bfab")),
            builder: (context, ref, value) {
              // TODO: Write test code.
              return value.toTile(context);
            },
          );
        }
        ```
2. `Model`の`toTile`拡張メソッドのゴールデンテスト用の画像ファイルの生成
    - `Model`の`toTile`拡張メソッドのテストを新しく作成した場合や`Model`の`toTile`拡張メソッドの更新を行った場合、下記のコマンドでゴールデンテスト用の画像ファイルを生成する。
        - 新規に作成したり更新していない`Model`の`toTile`拡張メソッドの場合は画像ファイルは作成しない。

        ```bash
        katana test update [Model],[Model名],...
        ```

        - 例
            ```bash
            katana test update MemoModel,UserModel
            ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
""";
  }
}
