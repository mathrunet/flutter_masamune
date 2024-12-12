part of '/masamune_module_chat_system.dart';

/// [BottomNavigationBar] for chat.
///
/// Speech can be transmitted to the AI or text can be described and passed to the AI.
///
/// チャット用の[BottomNavigationBar]。
///
/// 発話をAIに伝えたり、テキストを記載してAIに渡したりすることができます。
///
/// [controller]を渡して利用します。
class ChatSystemBottomBar extends StatefulWidget {
  /// [BottomNavigationBar] for chat.
  ///
  /// Speech can be transmitted to the AI or text can be described and passed to the AI.
  ///
  /// チャット用の[BottomNavigationBar]。
  ///
  /// 発話をAIに伝えたり、テキストを記載してAIに渡したりすることができます。
  ///
  /// [controller]を渡して利用します。
  const ChatSystemBottomBar({
    super.key,
    required this.controller,
    this.speakingLabel,
  });

  /// Chat system controller.
  ///
  /// チャットシステムのコントローラー。
  final ChatSystemModule controller;

  /// Labels to be displayed during speech.
  ///
  /// 発話中に表示するラベル。
  final Widget? speakingLabel;

  @override
  State<ChatSystemBottomBar> createState() => _ChatSystemBottomBarState();
}

class _ChatSystemBottomBarState extends State<ChatSystemBottomBar> {
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handledOnUpdate);
    _textEditingController = TextEditingController();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ChatSystemBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handledOnUpdate);
      widget.controller.addListener(_handledOnUpdate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handledOnUpdate);
    _textEditingController.dispose();
  }

  void _sendMessage([String? value]) {
    if (widget.controller.status != ChatSystemStatus.personWait) {
      return;
    }
    value ??= _textEditingController.text;
    _textEditingController.clear();
    widget.controller.inputPerson(message: value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: widget.controller.status == ChatSystemStatus.personSpeak
              ? 1.0
              : 0,
          duration: 300.ms,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.inverseSurface.withValues(alpha: 0.5),
              borderRadius: 16.r,
            ),
            margin: 8.pb,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: DefaultTextStyle(
              style: theme.textTheme.labelMedium
                      ?.withColor(theme.colorScheme.onInverseSurface) ??
                  const TextStyle(),
              child: widget.speakingLabel ?? const Text("Speaking..."),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: widget.controller.status ==
                                ChatSystemStatus.personWait ||
                            widget.controller.status ==
                                ChatSystemStatus.personSpeak
                        ? () {
                            _textEditingController.clear();
                            if (widget.controller.status ==
                                ChatSystemStatus.personSpeak) {
                              widget.controller.stopListenPerson();
                            } else {
                              widget.controller.startListenPerson();
                            }
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.controller.status ==
                                ChatSystemStatus.personSpeak
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      padding: 8.p,
                      child: Icon(
                        Icons.mic,
                        size: 28,
                        color: widget.controller.status ==
                                ChatSystemStatus.personSpeak
                            ? theme.colorScheme.onPrimary
                            : theme.disabledColor,
                      ),
                    ),
                  ),
                  8.sx,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: 24.r,
                        shape: BoxShape.rectangle,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FormTextField(
                              enabled: widget.controller.status ==
                                  ChatSystemStatus.personWait,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              controller: _textEditingController,
                              style: const FormStyle(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              ),
                              onSubmitted: (value) {
                                _sendMessage(value);
                              },
                            ),
                          ),
                          8.sx,
                          InkWell(
                            onTap: _sendMessage,
                            child: Icon(
                              Icons.send,
                              size: 24,
                              color: theme.disabledColor,
                            ),
                          ),
                          8.sx,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
