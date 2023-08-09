part of masamune_ai_openai;

/// Class used to create prompts.
///
/// Specify [initialValue] to set the initial message. The system message can also be specified here.
///
/// You can use [filterOnSend] and [filterOnReceive] to process messages sent to and received from GPT.
///
/// If [priorMessage] is specified, GPT will generate the next message based on this message.
///
/// プロンプトを作成するために使用するクラスです。
///
/// [initialValue]を指定して初期メッセージを設定します。システムメッセージもここで指定することができます。
///
/// [filterOnSend]や[filterOnReceive]でGPTにわたすメッセージや受け取ったメッセージを加工することができます。
///
/// [priorMessage]を指定しておくと、GPTはこのメッセージを元に次のメッセージを生成します。
@immutable
class OpenAIChatPromptBuilder {
  /// Class used to create prompts.
  ///
  /// Specify [initialValue] to set the initial message. The system message can also be specified here.
  ///
  /// You can use [filterOnSend] and [filterOnReceive] to process messages sent to and received from GPT.
  ///
  /// If [priorMessage] is specified, GPT will generate the next message based on this message.
  ///
  /// プロンプトを作成するために使用するクラスです。
  ///
  /// [initialValue]を指定して初期メッセージを設定します。システムメッセージもここで指定することができます。
  ///
  /// [filterOnSend]や[filterOnReceive]でGPTにわたすメッセージや受け取ったメッセージを加工することができます。
  ///
  /// [priorMessage]を指定しておくと、GPTはこのメッセージを元に次のメッセージを生成します。
  const OpenAIChatPromptBuilder({
    this.initialValue,
    this.temperature,
    this.filterOnReceive,
    this.filterOnSend,
    this.priorMessage,
  });

  /// Initial message.
  ///
  /// 初期メッセージ。
  final List<OpenAIChatMsg>? initialValue;

  /// The temperature of the response, specified as 0-1.
  ///
  /// レスポンスの温度感。0-1で指定します。
  final double? temperature;

  /// Filters for sending messages.
  ///
  /// メッセージを送信する際のフィルター。
  final String Function(String content)? filterOnSend;

  /// Filters for receiving messages.
  ///
  /// メッセージを受信する際のフィルター。
  final String Function(String content, FunctionCallResponse? functionCall)?
      filterOnReceive;

  /// Prior message.
  ///
  /// 先行メッセージ。
  final String? priorMessage;
}
