part of '/katana_ui.dart';

/// Provides easy modal functionality.
///
/// Displays a message modal that allows only one action with [alert].
///
/// Displays a message modal with two possible actions at [confirm].
///
/// 簡単なモーダルの機能を提供します。
///
/// [alert]でアクションを１つだけ可能なメッセージモーダルを表示します。
///
/// [confirm]でアクションを２つ実行可能なメッセージモーダルを表示します。
class Modal {
  const Modal._();

  /// Give [builder] to display the modal.
  ///
  /// The dialog can be closed by executing `onClose` passed to [builder].
  ///
  /// Pass the currently available [BuildContext] in [context].
  ///
  /// Describe the title of the message in [title].
  ///
  /// Specify the background color with [backgroundColor] and the text color with [color].
  ///
  /// If [disableBackKey] is set to `true`, it is possible to disable the back button on Android devices.
  ///
  /// If [popOnPress] is `true`, the modal is automatically closed when the action is executed.
  ///
  /// If [willShowRepetition] is set to `true`, the modal is automatically redisplayed if `onClose` interrupts the process with an [Exception].
  ///
  /// It is possible to wait with `await` until the modal closes.
  ///
  /// [builder]を与えてモーダルを表示します。
  ///
  /// [builder]には`onClose`が渡されこれを実行することでダイアログを閉じることができます。
  ///
  /// [context]で現在利用可能な[BuildContext]を渡します。
  ///
  /// [title]でメッセージのタイトルを記述します。
  ///
  /// [backgroundColor]で背景色、[color]でテキストカラーを指定します。
  ///
  /// [disableBackKey]を`true`にした場合、Android端末での戻るボタンを無効化することが可能です。
  ///
  /// [popOnPress]が`true`の場合は、アクションを実行した際、モーダルを自動で閉じます。
  ///
  /// [willShowRepetition]を`true`にした場合、`onClose`が[Exception]で処理を中断した場合、自動でモーダルを再表示します。
  ///
  /// モーダルが閉じるまで`await`で待つことが可能です。
  static Future<void> show(
    BuildContext context, {
    Color? backgroundColor,
    Color? color,
    required String title,
    required List<Widget> Function(ModalRef ref) builder,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    AlignmentGeometry? alignment,
  }) async {
    bool clicked = false;
    ScaffoldMessenger.of(context);
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return;
    }
    final ref = ModalRef._(() {
      if (popOnPress) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      clicked = true;
    });

    final foregroundColor = color ??
        Theme.of(context).dialogTheme.iconColor ??
        Theme.of(context).colorScheme.onSurface;
    backgroundColor ??= Theme.of(context).dialogTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: !disableBackKey,
            child: SimpleDialog(
              contentPadding: contentPadding,
              alignment: alignment,
              title: Text(
                title,
                style: TextStyle(
                  color: foregroundColor,
                ),
              ),
              backgroundColor: backgroundColor,
              surfaceTintColor: backgroundColor,
              children: builder.call(ref),
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
  }

  /// Displays a message modal with only one possible action.
  ///
  /// [context] to pass the currently available [BuildContext].
  ///
  /// Describe the message title in [title] and the message content in [text].
  ///
  /// The text of the action button is described in [submitText], and the processing when the action is executed is described in [onSubmit].
  ///
  /// Specify the background color with [backgroundColor] and the text color with [color].
  ///
  /// If [disableBackKey] is set to `true`, it is possible to disable the back button on Android devices.
  ///
  /// If [popOnPress] is `true`, the modal is automatically closed when the action is executed.
  ///
  /// If [willShowRepetition] is set to `true`, the modal is automatically redisplayed if [onSubmit] aborts the process with an [Exception].
  ///
  /// It is possible to wait with `await` until the modal closes.
  ///
  /// アクションを１つだけ可能なメッセージモーダルを表示します。
  ///
  /// [context]で現在利用可能な[BuildContext]を渡します。
  ///
  /// [title]でメッセージのタイトル[text]でメッセージの内容を記述します。
  ///
  /// [submitText]でアクションボタンのテキスト、[onSubmit]にアクションを実行する際の処理を記述します。
  ///
  /// [backgroundColor]で背景色、[color]でテキストカラーを指定します。
  ///
  /// [disableBackKey]を`true`にした場合、Android端末での戻るボタンを無効化することが可能です。
  ///
  /// [popOnPress]が`true`の場合は、アクションを実行した際、モーダルを自動で閉じます。
  ///
  /// [willShowRepetition]を`true`にした場合、[onSubmit]が[Exception]で処理を中断した場合、自動でモーダルを再表示します。
  ///
  /// モーダルが閉じるまで`await`で待つことが可能です。
  static Future<void> alert(
    BuildContext context, {
    required String submitText,
    Color? backgroundColor,
    Color? color,
    required String title,
    required String text,
    VoidCallback? onSubmit,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool clicked = false;
    ScaffoldMessenger.of(context);
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return;
    }
    final foregroundColor = color ??
        Theme.of(context).dialogTheme.iconColor ??
        Theme.of(context).colorScheme.onSurface;
    backgroundColor ??= Theme.of(context).dialogTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: !disableBackKey,
            child: AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  color: foregroundColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(
                    color: foregroundColor,
                  ),
                ),
              ),
              backgroundColor: backgroundColor,
              surfaceTintColor: backgroundColor,
              actions: <Widget>[
                TextButton(
                  child: Text(submitText),
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onSubmit?.call();
                    clicked = true;
                  },
                )
              ],
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
  }

  /// Displays a message modal that can perform two actions.
  ///
  /// [context] to pass the currently available [BuildContext].
  ///
  /// Describe the message title in [title] and the message content in [text].
  ///
  /// In the [submitText] field, enter the text of the confirmed action button, and in the [onSubmit] field, enter the processing to be performed when the confirmed action is executed.
  ///
  /// The text of the cancel action button is described in [cancelText], and the processing when the cancel action is executed is described in [onCancel].
  ///
  /// Specify the background color with [backgroundColor] and the text color with [color].
  ///
  /// If [popOnPress] is `true`, the modal is automatically closed when the action is executed.
  ///
  /// If [willShowRepetition] is set to `true`, the modal is automatically redisplayed if [onSubmit] aborts the process with an [Exception].
  ///
  /// Returns `true` if the modal's confirm button is pressed, or `false` if it is canceled.
  ///
  /// アクションを２つ実行可能なメッセージモーダルを表示します。
  ///
  /// [context]で現在利用可能な[BuildContext]を渡します。
  ///
  /// [title]でメッセージのタイトル[text]でメッセージの内容を記述します。
  ///
  /// [submitText]で確定アクションボタンのテキスト、[onSubmit]に確定アクションを実行する際の処理を記述します。
  ///
  /// [cancelText]でキャンセルアクションボタンのテキスト、[onCancel]にキャンセルアクションを実行する際の処理を記述します。
  ///
  /// [backgroundColor]で背景色、[color]でテキストカラーを指定します。
  ///
  /// [popOnPress]が`true`の場合は、アクションを実行した際、モーダルを自動で閉じます。
  ///
  /// [willShowRepetition]を`true`にした場合、[onSubmit]が[Exception]で処理を中断した場合、自動でモーダルを再表示します。
  ///
  /// モーダルが閉じるまで`await`で待つことが可能です。
  ///
  /// モーダルの確定ボタンが押された場合`true`、キャンセルされた場合は`false`が返されます。
  static Future<bool> confirm(
    BuildContext context, {
    Color? backgroundColor,
    Color? color,
    required String submitText,
    required String cancelText,
    required String title,
    required String text,
    VoidCallback? onSubmit,
    VoidCallback? onCancel,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool state = false;
    bool clicked = false;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return state;
    }
    final foregroundColor = color ??
        Theme.of(context).dialogTheme.iconColor ??
        Theme.of(context).colorScheme.onSurface;
    backgroundColor ??= Theme.of(context).dialogTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                color: foregroundColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                ),
              ),
            ),
            backgroundColor: backgroundColor,
            surfaceTintColor: backgroundColor,
            actions: <Widget>[
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  if (popOnPress) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  onCancel?.call();
                  state = false;
                  clicked = true;
                },
              ),
              TextButton(
                child: Text(submitText),
                onPressed: () {
                  if (popOnPress) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  onSubmit?.call();
                  state = true;
                  clicked = true;
                },
              )
            ],
          );
        },
      );
    } while (willShowRepetition && !clicked);
    return state;
  }
}

/// Class for controlling Modal.
///
/// Modalをコントロールするためのクラスです。
@immutable
class ModalRef {
  const ModalRef._(this._onClose);

  final VoidCallback _onClose;

  /// Closes the modal.
  ///
  /// モーダルを閉じます。
  void close() => _onClose();
}
