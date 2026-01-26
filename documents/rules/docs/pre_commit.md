# コミット前のチェック作業について

## コミット前のチェック作業について。

- コミット前に必ず下記を実施しコードの品質と安全性を保つ。
    1. 下記のコマンドを実施してコードのフォーマットを行う。
        ```bash
        dart fix --apply lib && dart format . && flutter pub run import_sorter:main
        ```

    2. 下記のコマンドを実施してコードのバリデーションを行う。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        ```bash
        flutter analyze && dart run custom_lint

    3. `Page`や`Widget`、`Model`の`toTile`のエクステンションの更新が行われていた場合は、下記のコマンドを実施してゴールデンテスト用の画像を更新する。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合は`katana test debug`でエラーになります。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 出力先: `documents/test/**/*.png`
        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```
        ```

    4. 下記のコマンドを実施して全体のテストを行う。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。
        ```bash
        katana test debug
        ```

    5. 1〜4のステップでエラーやWarningが発生した場合は、再度1からステップをやり直す。エラーやWarningがなくなるまで繰り返す。

    6. エラーがなくなったら下記のコマンドを実施してCI用のゴールデンテスト用の画像を更新する。
        - **重要**: このコマンドはDocker使用のため時間がかかります。コミット直前に1度だけ実行してください。
        - 各種UIが更新されているにも関わらずこのステップが実行されない場合はCI側の`katana test run`でエラーになります。

        ```bash
        katana test build [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 出力先: `documents/test/**/*.png`
        - 例:
            ```bash
            katana test build TestPage,TestWidget,TestModel
            ```
