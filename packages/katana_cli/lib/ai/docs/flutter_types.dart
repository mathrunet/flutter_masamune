import 'package:katana_cli/katana_cli.dart';

/// Contents of flutter_types.mdc.
///
/// flutter_types.mdcの中身。
class FlutterTypesMdcCliAiCode extends CliAiCode {
  /// Contents of flutter_types.mdc.
  ///
  /// flutter_types.mdcの中身。
  const FlutterTypesMdcCliAiCode();

  @override
  String get name => "主要なFlutter/Dartのタイプ一覧";

  @override
  String get description =>
      "`Widget`や`Page`、`Controller`等のコンストラクタパラメーター、フィールド、関数やメソッドの引数と戻り値、処理内の変数等様々な場所で利用可能なFlutter/Dartのタイプ一覧";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Widget`や`Page`、`Controller`等のコンストラクタパラメーター、フィールド、関数やメソッドの引数と戻り値、処理内の変数等様々な場所で利用可能なタイプである主要なFlutter/Dartのタイプ一覧を下記に記載する。

## 利用可能な場所一覧

- `Page`や`Widget`、`Controller`等のコンストラクタパラメーター
- `Page`や`Widget`、`Controller`等のフィールド
- 各関数やメソッドの引数と戻り値
- 処理内の変数

※`Model`の`DataField`におけるタイプには利用不可。

## 主要なFlutter/Dartのタイプ一覧

| Type | Summary |
| --- | --- |
| `Widget` | FlutterのWidgetを継承したクラスすべて。Masamuneフレームワークにおける`Widget`や`Page`も含む。 |
| `Future<[Type]>` | 非同期処理の結果を返す。 |
| `FutureOr<[Type]>` | 非同期処理の結果を返す。 |
| `VoidCallback` | 引数がなく戻り値がない関数。 |
| `ValueChanged<[Type]>` | 値が変更された際に呼び出される関数。 |
""";
  }
}
