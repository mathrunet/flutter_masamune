part of '/masamune_module_chat_system.dart';

/// A list view showing the chat history.
///
/// Pass [controller] for use.
///
/// チャットの履歴を表示するリストビュー。
///
/// [controller]を渡して利用します。
class ChatSystemListView extends StatefulWidget {
  /// A list view showing the chat history.
  ///
  /// Pass [controller] for use.
  ///
  /// チャットの履歴を表示するリストビュー。
  ///
  /// [controller]を渡して利用します。
  const ChatSystemListView({
    super.key,
    required this.controller,
    this.aiIcon,
    this.aiActionsBuilder,
    this.padding,
  });

  /// Chat system controller.
  ///
  /// チャットシステムのコントローラー。
  final ChatSystemModule controller;

  /// Icons for AI.
  ///
  /// AI用のアイコン。
  final Widget? aiIcon;

  /// AI Chat Window Actions.
  ///
  /// AIチャットウインドウのアクション。
  final List<Widget> Function(
      BuildContext context, ChatSystemValue item, int index)? aiActionsBuilder;

  /// List view padding.
  ///
  /// リストビューのパディング。
  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => _ChatSystemListViewState();
}

class _ChatSystemListViewState extends State<ChatSystemListView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ChatSystemListView oldWidget) {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListBuilder<ChatSystemValue>(
      padding: widget.padding ?? const EdgeInsets.all(16),
      reverse: true,
      source: widget.controller.value.reversed.toList(),
      builder: (context, item, index) {
        if (item.role == ChatSystemRole.ai) {
          return [
            ChatTile(
              item.waiting
                  ? Container(
                      alignment: Alignment.center,
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.disabledColor,
                      ),
                    )
                  : Text(
                      item.displayText,
                      softWrap: true,
                    ),
              leading: widget.aiIcon ?? const Icon(Icons.person),
              actions: widget.aiActionsBuilder != null
                  ? widget.aiActionsBuilder!.call(context, item, index)
                  : [],
            ),
          ];
        } else {
          return [
            ChatTile(
              item.waiting
                  ? Container(
                      alignment: Alignment.center,
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.disabledColor,
                      ),
                    )
                  : Text(
                      item.displayText,
                      softWrap: true,
                    ),
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ];
        }
      },
    );
  }
}
