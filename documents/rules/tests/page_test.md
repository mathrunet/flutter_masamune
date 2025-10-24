# `Page`のテストの実装

`test/pages`フォルダに作成されているテストファイルを下記の手順で修正する。
各テストファイルに対応する`Page`は`lib/pages`フォルダに作成されている。

1. `test/pages`フォルダに作成されているテストファイルを修正。
    - `test/pages/**/*_test.dart`ファイルを開く。
    - 対応する`lib/pages/**/*.dart`ファイルを開き、コンストラクタを確認。引数が一致していなければ修正する。
        - 引数に渡す値の型がDart/Flutterの`プリミティブタイプ`であれば自由に決めてよい。
            - ただし、`xxxId`といった`Model`に紐づくIDであれば、`lib/adapter.dart`内に記載されている対応するモックデータのIDを記載する。
        - 引数に渡す値の型が`Model`であれば必要な処理を`masamuneWidgetTest`の`loader`に記載し値を返す。返した値は`builder`の`value`に渡されるので、（必要であれば値のNullチェックを行ったうえで）その値を引数に渡す。
            - `Model`の読み込みにIDが必要な場合は、`lib/adapter.dart`内に記載されている対応するモックデータのIDを記載する。
        - 複数の`Model`や`Future`の読み込みが必要な場合はRecordsとして返す。
    - 例：通常の修正方法
        ```dart
        // test/pages/memo_page_test.dart

        void main() {
          masamunePageTest(
            name: "MemoPage",
            builder: (context, ref, value) {
              // TODO: Write test code.
              return const MemoPage(
                title: Text("Memo Title"),
              );
            },
          );
        }
        ```
    - 例：Model IDを渡す場合
        ```dart
        // test/pages/memo_detail_page_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`が定義されている前提

        void main() {
          masamunePageTest(
            name: "MemoDetailPage",
            builder: (context, ref, value) {
              // TODO: Write test code.
              return const MemoDetailPage(
                memoId: "5972db7b4c9b4ab59ca6f31512c2bfab",
              );
            },
          );
        }
        ```
    - 例：`Document`の`Model`を渡す場合
        ```dart
        // test/pages/memo_detail_page_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`が定義されている前提

        void main() {
          masamunePageTest(
            name: "MemoDetailPage",
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
              return const MemoDetailPage(
                memoDocument: value,
              );
            },
          );
        }
        ```
    - 例：複数の`Document`の`Model`を渡す場合
        ```dart
        // test/pages/memo_detail_page_test.dart
        // `lib/adapter.dart`内に`5972db7b4c9b4ab59ca6f31512c2bfab`のIDを持つ`MemoModel`と`5da16680f3234c6a9781505cc9080909`のIDを持つ`UserModel`が定義されている前提

        void main() {
          masamunePageTest(
            name: "MemoDetailPage",
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
              return const MemoDetailPage(
                memoDocument: value.memoValue,
                userDocument: value.userValue,
              );
            },
          );
        }
        ```
2. `Page`のUI確認
    - `Page`のテストを新しく作成した場合や`Page`の更新を行った場合の確認方法。

    ### 開発中の素早いUI確認
    - 下記のコマンドで素早くUI確認用の画像ファイルを生成できます（推奨）。
        ```bash
        katana code debug [Page名],[Page名],...
        ```
        - 出力先: `documents/debugs/**/*.png`
        - 特徴: 数秒で完了、頻繁な確認に最適
        - 例:
            ```bash
            katana code debug MemoPage,MemoDetailPage
            ```

    ### コミット前の最終確認（⚠️時間がかかる）
    - コミット前の最終確認時のみ、下記のコマンドでゴールデンテスト用の画像ファイルを生成します。
    - **注意**: Docker使用のため時間がかかります。完了直前に1度だけ実行してください。
        ```bash
        katana test update [Page名],[Page名],...
        ```
        - 出力先: `documents/test/**/*.png`
        - 特徴: Docker使用で時間がかかる、コミット前に1度だけ実行
        - 例:
            ```bash
            katana test update MemoPage,MemoDetailPage
            ```

- FlutterやMasamuneの実装方法の詳細や細かい制約については`documents/rules/**/*.md`を参照
