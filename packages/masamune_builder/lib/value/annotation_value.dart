part of '/masamune_builder.dart';

/// Class for storing annotation values.
///
/// Specify the class element in [element] and the annotation type in [annotationType].
///
/// アノテーションの値を保存するためのクラス。
///
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class ModelAnnotationValue {
  /// Class for storing annotation values.
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  ///
  /// アノテーションの値を保存するためのクラス。
  ///
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  ModelAnnotationValue(this.element, this.annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);

    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        final source = meta.toSource();
        path = obj.getField("path")?.toStringValue();
        mirror = obj.getField("mirror")?.toStringValue();
        endpoint = obj.getField("endpoint")?.toStringValue();
        docsPath = obj.getField("docsPath")?.toStringValue();
        comment = obj.getField("comment")?.toStringValue();

        final permissionMatch = _permissionRegExp.firstMatch(source);
        if (permissionMatch != null) {
          permission = permissionMatch
                  .group(1)
                  ?.split(",")
                  .map((e) => PermissionValue.from(
                        e.trim().trimString("'").trimString('"'),
                      ))
                  .toList() ??
              const [];
        } else {
          permission = const [];
        }
        final mirrorPermissionMatch =
            _mirrorPermissionRegExp.firstMatch(source);
        if (mirrorPermissionMatch != null) {
          mirrorPermission = mirrorPermissionMatch
                  .group(1)
                  ?.split(",")
                  .map((e) => PermissionValue.from(
                        e.trim().trimString("'").trimString('"'),
                      ))
                  .toList() ??
              permission ??
              const [];
        } else {
          mirrorPermission = permission ?? const [];
        }

        final adapterMatch = _adapterRegExp.firstMatch(source);
        if (adapterMatch != null) {
          final mirrorMatch = _mirrorWithSingleQuoteRegExp.firstMatch(source) ??
              _mirrorWithDoubleQuoteRegExp.firstMatch(source) ??
              _mirrorWithVariableRegExp.firstMatch(source);
          final permissionMatch = _permissionRegExp.firstMatch(source);
          final mirrorPermissionMatch =
              _mirrorPermissionRegExp.firstMatch(source);
          final match = adapterMatch
              .group(1)
              ?.replaceAll(mirrorMatch?.group(0) ?? "", "")
              .replaceAll(permissionMatch?.group(0) ?? "", "")
              .replaceAll(mirrorPermissionMatch?.group(0) ?? "", "")
              .trim()
              .trimString(",")
              .trim();
          if (match.isNotEmpty) {
            adapter = match!.trimString("'").trimString('"');
          } else {
            adapter = null;
          }
        } else {
          adapter = null;
        }
        return;
      }
    }
    path = null;
    mirror = null;
    adapter = null;
    endpoint = null;
    docsPath = null;
    comment = null;
  }

  /// Check if the class element has
  ///
  /// クラスエレメントが指定したアノテーションを持っているか確認します。
  static bool hasMatch(ClassElement element, Type annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);
    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        return true;
      }
    }
    return false;
  }

  static final _mirrorWithSingleQuoteRegExp =
      RegExp(r"mirror\s*:\s*('[^']+'),?");
  static final _mirrorWithDoubleQuoteRegExp =
      RegExp(r'mirror\s*:\s*("[^"]+"),?');
  static final _mirrorWithVariableRegExp =
      RegExp(r'mirror\s*:\s*([a-zA-Z0-9$._-]+),?');
  static final _permissionRegExp = RegExp(r"permission\s*:\s*\[([^\]]*)\],?");
  static final _mirrorPermissionRegExp =
      RegExp(r"mirrorPermission\s*:\s*\[([^\]]*)\],?");
  static final _adapterRegExp = RegExp(r"adapter\s*:\s*(.+),?\s*\)\s*$");

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  ///
  /// アノテーションのタイプ
  final Type annotationType;

  /// Path.
  ///
  /// パス。
  late final String? path;

  /// Mirror Path.
  ///
  /// ミラーパス。
  late final String? mirror;

  /// Adapter configuration.
  ///
  /// アダプターの設定。
  late final String? adapter;

  /// Endpoint configuration.
  ///
  /// エンドポイントの設定。
  late final String? endpoint;

  /// Set the document path.
  ///
  /// ドキュメントパスの設定。
  late final String? docsPath;

  /// Comment Settings.
  ///
  /// コメントの設定。
  late final String? comment;

  /// Permission settings.
  ///
  /// パーミッションの設定。
  late final List<PermissionValue>? permission;

  /// Set permissions for [mirror].
  ///
  /// [mirror]用のパーミッションの設定。
  late final List<PermissionValue>? mirrorPermission;

  @override
  String toString() {
    return "$runtimeType()";
  }
}
