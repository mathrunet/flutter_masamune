part of '/masamune_model_firebase_data_connect_builder.dart';

/// FirebaseDataConnect authentication type.
///
/// FirebaseDataConnectの認証タイプ。
enum AuthType {
  /// No access.
  ///
  /// アクセスなし。
  noAccess,

  /// User.
  ///
  /// ユーザーのみ。
  user,

  /// Public.
  ///
  /// だれでも公開。
  public;

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case AuthType.noAccess:
        return "NO_ACCESS";
      case AuthType.user:
        return "USER";
      case AuthType.public:
        return "PUBLIC";
    }
  }
}

extension on ModelAnnotationValue {
  AuthType toAuthType({
    required List<ModelPermissionQueryType> permissionType,
  }) {
    if (permissionType.isEmpty) {
      return AuthType.noAccess;
    }
    final type = permission?.firstWhereOrNull(
      (item) => permissionType.any((e) => e.className == item.type),
    );
    if (type == null) {
      return AuthType.noAccess;
    }
    if (type.user == ModelPermissionQueryUserType.allUsers.methodName) {
      return AuthType.public;
    }
    return AuthType.user;
  }
}
