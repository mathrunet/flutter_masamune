part of katana_functions_firebase;

/// Adapter to return server-side processing using Firebase Functions.
///
/// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
///
/// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// The region of the instance can be changed by passing [region].
///
/// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
///
/// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
///
/// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// [region]を渡すことでインスタンスのリージョンを変更することが可能です。
class FirebaseFunctionsAdapter extends FunctionsAdapter {
  /// Adapter to return server-side processing using Firebase Functions.
  ///
  /// The server-side implementation can be simplified by using `@mathrunet/mathamune` in npm.
  ///
  /// Basically, the default [FirebaseFunctions.instance] is used, but it is possible to use a specified authentication database by passing [functions] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// The region of the instance can be changed by passing [region].
  ///
  /// Firebase Functionsを利用してサーバー側の処理を返すためのアダプター。
  ///
  /// npmの`@mathrunet/masamune`を利用することでサーバー側の実装を簡略化することができます。
  ///
  /// 基本的にデフォルトの[FirebaseFunctions.instance]が利用されますが、アダプターの作成時に[functions]を渡すことで指定された認証データベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// [region]を渡すことでインスタンスのリージョンを変更することが可能です。
  const FirebaseFunctionsAdapter({
    this.options,
    this.region,
    FirebaseFunctions? functions,
  }) : _functions = functions;

  /// Instances of Firebase Functions.
  ///
  /// Firebase Functionsのインスタンス。
  FirebaseFunctions get functions {
    if (_functions != null) {
      return _functions!;
    }
    if (region.isEmpty) {
      return FirebaseFunctions.instance;
    } else {
      return FirebaseFunctions.instanceFor(region: region);
    }
  }

  final FirebaseFunctions? _functions;

  /// Options for initializing Firebase.
  ///
  /// Firebaseを初期化する際のオプション。
  final FirebaseOptions? options;

  /// Firebase Functions Region.
  ///
  /// Firebase Functionsのリージョン。
  final String? region;

  @override
  String get endpoint => FirebaseCore.functionsEndpoint;

  @override
  Future<TResponse> execute<TResponse>(
      FunctionsAction<TResponse> action) async {
    await FirebaseCore.initialize(options: options);
    try {
      return await action.execute((map) async {
        final res =
            await functions.httpsCallable(action.action).call<DynamicMap>(map);
        return res.data;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
