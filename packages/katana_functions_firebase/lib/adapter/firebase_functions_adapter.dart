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

  @override
  Future<OpenAIChatGPTMessage?> openAIChatGPT({
    required List<OpenAIChatGPTMessage> messages,
    OpenAIChatGPTModel model = OpenAIChatGPTModel.gpt35Turbo,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      final res =
          await functions.httpsCallable("openai_chat_gpt").call<DynamicMap>(
        {
          "message": messages
              .map((e) => {
                    "role": e.role.name,
                    "content": e.text,
                  })
              .toList(),
          "model": model.name,
        },
      );
      if (res.data.isEmpty) {
        throw Exception("Failed to get response from openai_chat_gpt.");
      }

      final choices = res.data.getAsList<DynamicMap>("choices");
      if (choices.isEmpty) {
        throw Exception("Failed to get response from openai_chat_gpt.");
      }

      final token = res.data.getAsMap("usage").get("total_tokens", 0);
      final message = choices.first.getAsMap("message");
      final role = message.get("role", "");
      final content = message.get("content", "");
      return OpenAIChatGPTMessage(
        role: OpenAIChatGPTRole.values
                .firstWhereOrNull((item) => item.name == role) ??
            OpenAIChatGPTRole.user,
        text: content,
        token: token,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
