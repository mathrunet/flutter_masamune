part of katana_functions;

/// An adapter to provide an interface to perform server-side processing.
///
/// Communicate with each server to return the appropriate response.
///
/// サーバー側の処理を実行するためのインターフェースを提供するためのアダプター。
///
/// 各サーバーと通信して適切なレスポンスを返すようにしてください。
@immutable
abstract class FunctionsAdapter {
  /// An adapter to provide an interface to perform server-side processing.
  ///
  /// Communicate with each server to return the appropriate response.
  ///
  /// サーバー側の処理を実行するためのインターフェースを提供するためのアダプター。
  ///
  /// 各サーバーと通信して適切なレスポンスを返すようにしてください。
  const FunctionsAdapter();

  /// You can retrieve the [FunctionsAdapter] first given by [FunctionsAdapterScope].
  ///
  /// 最初に[FunctionsAdapterScope]で与えた[FunctionsAdapter]を取得することができます。
  static FunctionsAdapter get primary {
    assert(
      _primary != null,
      "FunctionsAdapter is not set. Place [FunctionsAdapterScope] widget closer to the root.",
    );
    return _primary ?? const RuntimeFunctionsAdapter();
  }

  static FunctionsAdapter? _primary;

  /// URL of the endpoint where the Functions are executed.
  ///
  /// Functionsを実行するエンドポイントのURL。
  String get endpoint;

  /// PUSH notification.
  ///
  /// Pass the title of the notification to [title], the message to [text], and the destination to [target].
  ///
  /// If you want to plant data in the notification, use [data]. Pass the channel ID required for the specific platform to [channel].
  ///
  /// PUSH通知を行います。
  ///
  /// [title]に通知タイトル、[text]にメッセージ、[target]に宛先を渡します。
  ///
  /// 通知にデータを仕込みたい場合は[data]を利用します。[channel]に特定プラットフォームで必要なチャンネルIDを渡します。
  Future<void> sendNotification({
    required String title,
    required String text,
    String? channel,
    DynamicMap? data,
    required String target,
  });

  /// Chat using OpenAI's Chat GPT.
  ///
  /// Pass all previous correspondence to [messages].
  ///
  /// A new message, [OpenAIChatGPTMessage], is returned in the response.
  ///
  /// Pass the model to be used to [model].
  ///
  /// OpenAIのChat GPTを利用してチャットを行います。
  ///
  /// [messages]にそれまでのやりとりのすべてを渡してください。
  ///
  /// レスポンスに新しいメッセージの[OpenAIChatGPTMessage]を返ってきます。
  ///
  /// [model]には利用するモデルを渡してください。
  Future<OpenAIChatGPTMessage?> openAIChatGPT({
    required List<OpenAIChatGPTMessage> messages,
    OpenAIChatGPTModel model = OpenAIChatGPTModel.gpt35Turbo,
  });

  /// Functions for issuing tokens to be used by Agora.io.
  ///
  /// Pass the necessary values to [channelName] and [clientRole].
  ///
  /// Agora.ioで利用するトークンを発行するためのFunctions。
  ///
  /// [channelName]と[clientRole]に必要な値を渡してください。
  Future<String> getAgoraToken({
    required String channelName,
    AgoraClientRole clientRole = AgoraClientRole.audience,
  });

  /// Functions for server-side processing used by Stripe.
  ///
  /// [StripeAction] and [StripeActionResponse] must be prepared for each mode.
  ///
  /// Stripeで利用するサーバー側の処理を行うためのFunctions。
  ///
  /// 各モードに応じた[StripeAction]と[StripeActionResponse]を用意する必要があります。
  Future<TStripeResponse?> stipe<TStripeResponse extends StripeActionResponse>({
    required StripeAction<TStripeResponse> action,
  });

  /// Send email through Gmail.
  ///
  /// Specify the source email address in the [from] field and the destination email address in the [to] field.
  ///
  /// The title of the email is written in [title] and the body of the email is written in [content].
  ///
  /// Gmailを通してメールを送信します。
  ///
  /// [from]に送信元、[to]に送信先のメールアドレスを指定します。
  ///
  /// [title]にメールタイトル、[content]にメール本文を記載します。
  Future<void> sendMailByGmail({
    required String from,
    required String to,
    required String title,
    required String content,
  });

  /// Send email through SendGrid.
  ///
  /// Specify the source email address in the [from] field and the destination email address in the [to] field.
  ///
  /// The title of the email is written in [title] and the body of the email is written in [content].
  ///
  /// SendGridを通してメールを送信します。
  ///
  /// [from]に送信元、[to]に送信先のメールアドレスを指定します。
  ///
  /// [title]にメールタイトル、[content]にメール本文を記載します。
  Future<void> sendMailBySendGrid({
    required String from,
    required String to,
    required String title,
    required String content,
  });

  /// Server-side verification of billing.
  ///
  /// Pass [setting] according to billing type.
  ///
  /// If the return value is `true`, the verification succeeds; if it is `false`, the verification fails.
  ///
  /// 課金のサーバーサイド検証を行います。
  ///
  /// 課金タイプに応じて[setting]を渡してください。
  ///
  /// 戻り値が`true`の場合は検証成功、`false`の場合は検証失敗となります。
  Future<bool> verifyPurchase({
    required PurchaseSettings setting,
  });
}

/// [FunctionsAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [FunctionsAdapter] to [adapter].
///
/// Also, by using [FunctionsAdapterScope.of] in a descendant widget, you can retrieve the [FunctionsAdapter] set in the [FunctionsAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[FunctionsAdapter]を設定します。
///
/// [adapter]に[FunctionsAdapter]を渡してください。
///
/// また[FunctionsAdapterScope.of]を子孫のウィジェット内で利用することにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return FunctionsAdapterScope(
///       adapter: const RuntimeFunctionsAdapter(),
///       child: MaterialApp(
///         home: const StoragePage(),
///       ),
///     );
///   }
/// }
/// ```
class FunctionsAdapterScope extends StatefulWidget {
  /// [FunctionsAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [FunctionsAdapter] to [adapter].
  ///
  /// Also, by using [FunctionsAdapterScope.of] in a descendant widget, you can retrieve the [FunctionsAdapter] set in the [FunctionsAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[FunctionsAdapter]を設定します。
  ///
  /// [adapter]に[FunctionsAdapter]を渡してください。
  ///
  /// また[FunctionsAdapterScope.of]を子孫のウィジェット内で利用することにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FunctionsAdapterScope(
  ///       adapter: const RuntimeFunctionsAdapter(),
  ///       child: MaterialApp(
  ///         home: const StoragePage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const FunctionsAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [FunctionsAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[FunctionsAdapter]。
  final FunctionsAdapter adapter;

  /// By passing [context], the [FunctionsAdapter] set in [FunctionsAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [FunctionsAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
  ///
  /// 祖先に[FunctionsAdapterScope]がない場合はエラーになります。
  static FunctionsAdapter? of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<_FunctionsAdapterScope>();
    assert(
      scope != null,
      "FunctionsAdapterScope is not found. Place [FunctionsAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _FunctionsAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _FunctionsAdapterScopeState();
}

class _FunctionsAdapterScopeState extends State<FunctionsAdapterScope> {
  @override
  void initState() {
    super.initState();
    FunctionsAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionsAdapterScope(
      adapter: widget.adapter,
      child: widget.child,
    );
  }
}

class _FunctionsAdapterScope extends InheritedWidget {
  const _FunctionsAdapterScope({
    required super.child,
    required this.adapter,
  });

  final FunctionsAdapter adapter;

  @override
  bool updateShouldNotify(covariant _FunctionsAdapterScope oldWidget) => false;
}
