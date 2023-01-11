part of katana_functions_firebase;

/// Adapter to return server-side processing using Firebase Functions.
///
/// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
///
/// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
///
/// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
class FirebaseFunctionsAdapter extends FunctionsAdapter {
  /// Adapter to return server-side processing using Firebase Functions.
  ///
  /// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
  ///
  /// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
  ///
  /// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
  const FirebaseFunctionsAdapter({
    required this.defaultAndroidNotificationChannelId,
  });

  /// Default AndroidNotificationChannelId.
  ///
  /// デフォルトのAndroidNotificationChannelId。
  final String defaultAndroidNotificationChannelId;

  /// Instances of Firebase Functions.
  ///
  /// Firebase Functionsのインスタンス。
  FirebaseFunctions get functions {
    return FirebaseFunctions.instance;
  }

  @override
  Future<void> sendNotification({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  }) async {
    try {
      final regExp = RegExp(r"[a-zA-Z0-9]{11}:[0-9a-zA-Z_-]+");
      final isToken = regExp.hasMatch(target);
      await FirebaseCore.initialize();
      await functions.httpsCallable("send_notification").call(
        {
          "title": title,
          "text": text,
          "channel_id": channel ?? defaultAndroidNotificationChannelId,
          if (data != null) "data": data,
          if (isToken) "token": target else "topic": target,
        },
      );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
