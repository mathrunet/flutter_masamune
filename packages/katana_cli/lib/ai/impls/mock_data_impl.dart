// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of mock_data_impl.md.
///
/// mock_data_impl.mdの中身。
class MockDataImplMdCliAiCode extends CliAiCode {
  /// Contents of mock_data_impl.md.
  ///
  /// mock_data_impl.mdの中身。
  const MockDataImplMdCliAiCode();

  @override
  String get name => "モックデータの実装";

  @override
  String get globs => "lib/adapter.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Model設計書`を用いたモックデータの実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/model_design.md`に記載されている`Model設計書`からモックデータを生成する方法
`documents/designs/model_design.md`が存在しない場合は絶対に実施しない

1. `Model設計書`を参照して各`Model`に対してモックデータを作成
    - `lib/adapter.dart`内にある`RuntimeModelAdapter`の`initialValue`に`ModelInitialValue`を継承した値を追加していく
        - 各`Model`に対する`ModelInitialValue`は`MemoModelInitialCollection`のような形で実装されているのでそれを利用する
    - 各種`ModelInitialValue`は`String`をキー、対応する`Model`を値とする`Map`を渡して定義する
        - キーは基本的に32桁の英数字（e.g. `a23c3fad389a45b39c9b1f930b364466`）を定義
            - Masamuneフレームワーク（`package:masamune/masamune.dart`）に実装されている`generateCode(32, seed: n)`でランダムに生成可能
    - `Collection`で利用する場合は10個程度のデータを用意
    - `ModelRef<AnyModel>`を参照する場合は`AnyModelRefPath(uid)`を渡すことで参照可能
        - `uid`は`AnyModelInitialCollection({uid: AnyModel()})`のように定義されていることが前提
    - 例：
        ```dart
        // lib/adapter.dart

        // 参照用のユーザーIDを予め定義しておく
        const userUid = "5da16680f3234c6a9781505cc9080909";

        /// App Model.
        ///
        /// By replacing this with another adapter, the data storage location can be changed.
        // TODO: Change the database.
        final modelAdapter = RuntimeModelAdapter(
          initialValue: [
            MemoModelInitialCollection({
              for (var i = 0; i < 10; i++)
              generateCode(32,  seed: i) : MemoModel(
                title: "title $i",
                content: "content $i",
                createdBy: UserModelRefPath(userUid),
                createdAt: ModelTimestamp(DateTime.now().subtract(Duration(days: i))),
                updatedAt: ModelTimestamp(DateTime.now().subtract(Duration(days: i))),
              ),
            }),
            UserModelInitialCollection({
              userUid: UserModel(
                name: "Main User",
                email: "main@example.com",
                createdAt: ModelTimestamp(DateTime.now().subtract(Duration(days: i))),
                updatedAt: ModelTimestamp(DateTime.now().subtract(Duration(days: i))),
              ),
            }),
          ],
        );
        ```
""";
  }
}
