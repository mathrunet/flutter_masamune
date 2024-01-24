part of '/masamune_builder.dart';

/// Parsed value for permissions.
///
/// パーミッション用のパースされた値。
@immutable
class PermissionValue {
  const PermissionValue._({
    required this.type,
    required this.user,
    this.key,
  });

  static final _permissionValueRegExp =
      RegExp(r"([a-zA-Z0-9_-]+)\.([a-zA-Z0-9_-]+)\(([^\)]*)\)");

  /// Parsed value for permissions.
  ///
  /// パーミッション用のパースされた値。
  static PermissionValue from(String value) {
    final match = _permissionValueRegExp.firstMatch(value);
    if (match == null) {
      throw ArgumentError.value(value, "value");
    }
    return PermissionValue._(
      type: match.group(1)!,
      user: match.group(2)!,
      key: match.group(3),
    );
  }

  /// Permission Type.
  ///
  /// パーミッションのタイプ。
  final String type;

  /// Permission user type.
  ///
  /// パーミッションのユーザータイプ。
  final String user;

  /// Permission key.
  ///
  /// パーミッションのキー。
  final String? key;

  @override
  String toString() {
    return "$runtimeType($type, $user, $key)";
  }
}
