// ignore_for_file: deprecated_member_use

part of '/katana_value.dart';

final _dartCore = Uri.parse("dart:core");
final _katana = Uri.parse("package:katana/katana.dart");

/// The type used in the macro.
///
/// マクロで利用する型。
enum MacroCode {
  /// Object.
  ///
  /// Object.
  object,

  /// MapEntry.
  ///
  /// MapEntry.
  mapEntry,

  /// `identical` from dart:core.
  ///
  /// dart:coreの`identical`。
  identical,

  /// `deepEquals` function from katana.
  ///
  /// katanaの`deepEquals`関数。
  deepEquals,

  /// `deepHash` function from katana.
  ///
  /// katanaの`deepHash`関数。
  deepHash;

  /// Get the code of the related object. You will need [introspector].
  ///
  /// 関連するオブジェクトのコードを取得します。[introspector]が必要になります。
  Future<NamedTypeAnnotationCode> code(
    DeclarationPhaseIntrospector introspector,
  ) async {
    switch (this) {
      case MacroCode.object:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_dartCore, "Object"),
        );
      case MacroCode.mapEntry:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_dartCore, "MapEntry"),
        );
      case MacroCode.identical:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_dartCore, "identical"),
        );
      case MacroCode.deepEquals:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_katana, "deepEquals"),
        );
      case MacroCode.deepHash:
        return NamedTypeAnnotationCode(
          name: await introspector.resolveIdentifier(_katana, "deepHash"),
        );
    }
  }
}
