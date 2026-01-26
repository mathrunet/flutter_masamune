# `Model`の`toTile`拡張メソッドの実装

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
2. `Model`の`toTile`拡張メソッドのUI確認
    - `Model`の`toTile`拡張メソッドのテストを新しく作成した場合や`Model`の`toTile`拡張メソッドの更新を行った場合の確認方法。

    ### 開発中の素早いUI確認
    - 下記のコマンドで素早くUI確認用の画像ファイルを生成できます（推奨）。
        ```bash
        katana code update [Model名],[Model名],...
        ```
        - 出力先: `documents/debugs/**/*.png`
        - 特徴: 数秒で完了、頻繁な確認に最適
        - 例:
            ```bash
            katana code update MemoModel,UserModel
            ```

    ### コミット前の最終確認（⚠️時間がかかる）
    - コミット前の最終確認時のみ、下記のコマンドでゴールデンテスト用の画像ファイルを生成します。
    - **注意**: Docker使用のため時間がかかります。完了直前に1度だけ実行してください。
        ```bash
        katana test build [Model名],[Model名],...
        ```
        - 出力先: `documents/test/**/*.png`
        - 特徴: Docker使用で時間がかかる、コミット前に1度だけ実行
        - 例:
            ```bash
            katana test build MemoModel,UserModel
            ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
