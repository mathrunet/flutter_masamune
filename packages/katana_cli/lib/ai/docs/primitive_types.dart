// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of primitive_types.md.
///
/// primitive_types.mdの中身。
class PrimitiveTypesMdCliAiCode extends CliAiCode {
  /// Contents of primitive_types.md.
  ///
  /// primitive_types.mdの中身。
  const PrimitiveTypesMdCliAiCode();

  @override
  String get name => "プリミティブタイプの一覧";

  @override
  String get description => "Flutter/Dartにおいて様々な場所で利用可能なタイプであるプリミティブタイプの一覧";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
Flutter/Dartにおいて様々な場所で利用可能なタイプであるプリミティブタイプの一覧を下記に記載する。

## 利用可能な場所一覧

- `Model`の`DataField`におけるタイプ
- `Page`や`Widget`、`Controller`等のコンストラクタパラメーター
- `Page`や`Widget`、`Controller`等のフィールド
- 各関数やメソッドの引数と戻り値
- 処理内の変数

## プリミティブタイプの一覧

| Type | Summary |
| --- | --- |
| `String` | 文字列。 |
| `int` | 整数。 |
| `double` | 小数。 |
| `bool` | 真偽値。 |
| `enum` | 列挙体。`katana code enum xxxx`でコードを出力した後`enum XxxEnum {}`にて定義された列挙体名が入る。選択肢が限られている場合はこちらを優先して利用。 |
| `List<[Type]>` | タイプを配列として複数持ちたい場合に利用。[Type]にはListも含めたその他タイプが入る。 |
| `Map<String, [Type]>` | タイプを連想配列として複数持ちたい場合に利用。キーには必ず`String`が入り[Type]にはMapも含めたその他タイプが入る。 |
| `Set<[Type]>` | タイプを重複禁止の配列として複数持ちたい場合に利用。[Type]にはSetも含めたその他タイプが入る。 |
""";
  }
}
