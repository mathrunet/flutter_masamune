part of "/masamune_auth_firebase.dart";

/// [FunctionsAction] for deleting a user in FirebaseAuthentication.
///
/// FirebaseAuthenticationのユーザーを削除するための[FunctionsAction]。
///
/// {@macro functions_action}
class FirebaseDeleteUserFunctionsAction
    extends FunctionsAction<FirebaseDeleteUserFunctionsActionResponse> {
  /// [FunctionsAction] for deleting a user in FirebaseAuthentication.
  ///
  /// FirebaseAuthenticationのユーザーを削除するための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const FirebaseDeleteUserFunctionsAction({
    required this.userId,
  });

  /// ID of the user to be deleted.
  ///
  /// 削除するユーザーID。
  final String userId;

  @override
  String get action => "delete_user";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
    };
  }

  @override
  FirebaseDeleteUserFunctionsActionResponse toResponse(DynamicMap map) {
    try {
      if (map.isEmpty) {
        throw Exception("Failed to get response from delete_user.");
      }

      return const FirebaseDeleteUserFunctionsActionResponse();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

/// Response to [FunctionsAction] for deleting a user in FirebaseAuthentication.
///
/// FirebaseAuthenticationのユーザーを削除するための[FunctionsAction]のレスポンス。
class FirebaseDeleteUserFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response to [FunctionsAction] for deleting a user in FirebaseAuthentication.
  ///
  /// FirebaseAuthenticationのユーザーを削除するための[FunctionsAction]のレスポンス。
  const FirebaseDeleteUserFunctionsActionResponse();
}
