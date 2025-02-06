import 'package:katana_cli/katana_cli.dart';

/// Contents of primitive_types.mdc.
///
/// primitive_types.mdcの中身。
class PrimitiveTypesMdcCliAiCode extends CliAiCode {
  /// Contents of primitive_types.mdc.
  ///
  /// primitive_types.mdcの中身。
  const PrimitiveTypesMdcCliAiCode();

  @override
  String get name => "プリミティブ型の一覧";

  @override
  String get description => "プリミティブ型の一覧";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
Dart言語において様々な場所で利用可能なタイプであるプリミティブ型の一覧を下記に記載する。

## 利用可能な場所一覧

- `Model`の`DataField`におけるタイプ
- `Page`や`Widget`、`Controller`等のコンストラクタパラメーター
- `Page`や`Widget`、`Controller`等のフィールド
- 各関数やメソッドの引数と戻り値
- 処理内の変数

## プリミティブ型の一覧

| タイプ | 概要 |
| --- | --- |
| `String` | 文字列。 |
| `int` | 整数。 |
| `double` | 小数。 |
| `bool` | 真偽値。 |
| `enum` | 列挙体。`katana code enum xxxx`でコードを出力した後`enum XxxEnum {}`にて定義された列挙体名が入る。選択肢が限られている場合はこちらを優先して利用。 |
| `List<[タイプ]>` | タイプを配列として複数持ちたい場合に利用。[タイプ]にはListも含めたその他タイプが入る。 |
| `Map<String, [タイプ]>` | タイプを連想配列として複数持ちたい場合に利用。キーには必ず`String`が入り[タイプ]にはMapも含めたその他タイプが入る。 |
| `Set<[タイプ]>` | タイプを重複禁止の配列として複数持ちたい場合に利用。[タイプ]にはSetも含めたその他タイプが入る。 |
""";
  }
}
