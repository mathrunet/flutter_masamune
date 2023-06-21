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

  @override
  Future<String> getAgoraToken({
    required String channelName,
    AgoraClientRole clientRole = AgoraClientRole.audience,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      final res = await functions.httpsCallable("agora_token").call<DynamicMap>(
        {
          "role": clientRole == AgoraClientRole.audience
              ? "audience"
              : "broadcaster",
          "name": channelName,
        },
      );
      if (res.data.isEmpty) {
        throw Exception("Failed to get response from agora_token.");
      }

      final token = res.data.get("token", "");
      if (token.isEmpty) {
        throw Exception("Failed to get response from agora_token.");
      }
      return token;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<TStripeResponse?> stipe<TStripeResponse extends StripeActionResponse>({
    required StripeAction<TStripeResponse> action,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      return await action.execute((map) async {
        final res =
            await functions.httpsCallable("stripe").call<DynamicMap>(map);
        return res.data;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> sendMailByGmail({
    required String from,
    required String to,
    required String title,
    required String content,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      await functions.httpsCallable("gmail").call(
        {
          "from": from,
          "to": to,
          "title": title,
          "content": content,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> sendMailBySendGrid({
    required String from,
    required String to,
    required String title,
    required String content,
  }) async {
    await FirebaseCore.initialize(options: options);
    try {
      await functions.httpsCallable("send_grid").call(
        {
          "from": from,
          "to": to,
          "title": title,
          "content": content,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> verifyPurchase({required PurchaseSettings setting}) async {
    await FirebaseCore.initialize(options: options);
    try {
      return await setting.execute((map) async {
        final res =
            await functions.httpsCallable(setting.action).call<DynamicMap>(map);
        return res.data;
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
