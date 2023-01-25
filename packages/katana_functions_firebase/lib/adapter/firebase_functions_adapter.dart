part of katana_functions_firebase;

/// Adapter to return server-side processing using Firebase Functions.
///
/// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
///
/// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
///
/// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
///
/// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
class FirebaseFunctionsAdapter extends FunctionsAdapter {
  /// Adapter to return server-side processing using Firebase Functions.
  ///
  /// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
  ///
  /// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
  ///
  /// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
  ///
  /// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  const FirebaseFunctionsAdapter({
    this.options,
    FirebaseFunctions? functions,
  }) : _functions = functions;

  /// Instances of Firebase Functions.
  ///
  /// Firebase Functionsのインスタンス。
  FirebaseFunctions get functions {
    return _functions ?? FirebaseFunctions.instance;
  }

  final FirebaseFunctions? _functions;

  /// Options for initializing Firebase.
  ///
  /// Firebaseを初期化する際のオプション。
  final FirebaseOptions? options;

  @override
  Future<void> sendNotification({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      final regExp = RegExp(r"[a-zA-Z0-9]{11}:[0-9a-zA-Z_-]+");
      final isToken = regExp.hasMatch(target);
      await FirebaseCore.initialize();
      await functions.httpsCallable("send_notification").call(
        {
          "title": title,
          "text": text,
          if (channel != null) "channel_id": channel,
          if (data != null) "data": data,
          if (isToken) "token": target else "topic": target,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
