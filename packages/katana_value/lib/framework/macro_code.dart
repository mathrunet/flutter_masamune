part of '/katana_value.dart';

final _dartCore = Uri.parse("dart:core");

/// The type used in the macro.
///
/// マクロで利用する型。
enum MacroCode {
  /// Object.
  ///
  /// Object.
  object;

  /// Get the code of the related object. You will need [introspector].
  ///
  /// 関連するオブジェクトのコードを取得します。[introspector]が必要になります。
  Future<NamedTypeAnnotationCode> getCode(
    DeclarationPhaseIntrospector introspector,
  ) async {
    switch (this) {
      case MacroCode.object:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_dartCore, "Object"),
        );
    }
  }
}
