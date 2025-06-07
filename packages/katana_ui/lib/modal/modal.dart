part of "/katana_ui.dart";

/// Provides easy modal functionality.
///
/// Displays a message modal that allows only one action with [alert].
///
/// Displays a message modal with two possible actions at [confirm].
///
/// Displays a bottom sheet as a modal with [bottomSheet].
///
/// You can also extend the [Modal] class to create your own modals.
/// In that case, pass a class implementing [Modal] in the [show] method to display the modal.
///
/// Implement it in the [build] method. [ref] is passed to [ModalRef].
///
/// 簡単なモーダルの機能を提供します。
///
/// [alert]でアクションを１つだけ可能なメッセージモーダルを表示します。
///
/// [confirm]でアクションを２つ実行可能なメッセージモーダルを表示します。
///
/// [bottomSheet]でボトムシートとしてモーダルを表示します。
///
/// [Modal]クラスを拡張して独自のモーダルを作成することも可能です。
/// その場合は[show]メソッドで[Modal]を実装したクラスを渡してモーダルを表示します。
///
/// 実装は[build]メソッドで行います。[ref]には[ModalRef]が渡されます。
abstract class Modal<T> {
  /// Provides easy modal functionality.
  ///
  /// Displays a message modal that allows only one action with [alert].
  ///
  /// Displays a message modal with two possible actions at [confirm].
  ///
  /// Displays a bottom sheet as a modal with [bottomSheet].
  ///
  /// You can also extend the [Modal] class to create your own modals.
  /// In that case, pass a class implementing [Modal] in the [show] method to display the modal.
  ///
  /// Implement it in the [build] method. [ref] is passed to [ModalRef].
  ///
  /// 簡単なモーダルの機能を提供します。
  ///
  /// [alert]でアクションを１つだけ可能なメッセージモーダルを表示します。
  ///
  /// [confirm]でアクションを２つ実行可能なメッセージモーダルを表示します。
  ///
  /// [bottomSheet]でボトムシートとしてモーダルを表示します。
  ///
  /// [Modal]クラスを拡張して独自のモーダルを作成することも可能です。
  /// その場合は[show]メソッドで[Modal]を実装したクラスを渡してモーダルを表示します。
  ///
  /// 実装は[build]メソッドで行います。[ref]には[ModalRef]が渡されます。
  const Modal();

  /// Implement it in the [build] method. [ref] is passed to [ModalRef].
  ///
  /// モーダルのコンテンツを実装するために[build]メソッドを実装します。[ref]には[ModalRef]が渡されます。
  Widget build(BuildContext context, ModalRef<T> ref);

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
  /// [modal]に[Modal]を実装したクラスを与えてモーダルを表示します。
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
  static Future<T?> show<T>(
    BuildContext context, {
    required Modal<T> modal,
    Color? backgroundColor,
    Color? color,
    String? title,
    Widget? leading,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    AlignmentGeometry? alignment,
  }) async {
    assert(
      (title == null && leading == null) ||
          (title != null && leading == null) ||
          (title != null && leading != null),
      "If [leading] is used, [title] is also required.",
    );
    var clicked = false;
    ScaffoldMessenger.of(context);
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return null;
    }
    final ref = ModalRef<T>._(context, (result) {
      if (popOnPress) {
        Navigator.of(context, rootNavigator: true).pop(result);
      }
      clicked = true;
    });

    T? result;
    final theme = Theme.of(context);
    final foregroundColor =
        color ?? theme.dialogTheme.iconColor ?? theme.colorScheme.onSurface;
    backgroundColor ??=
        theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface;
    do {
      result = await showDialog<T>(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
            data: theme.copyWith(
              dialogTheme: theme.dialogTheme.copyWith(
                backgroundColor: backgroundColor,
                iconColor: foregroundColor,
              ),
            ),
            child: PopScope(
              canPop: !disableBackKey,
              child: SimpleDialog(
                contentPadding: contentPadding,
                alignment: alignment,
                title: title != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (leading != null) ...[
                            leading,
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: foregroundColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                backgroundColor: backgroundColor,
                surfaceTintColor: backgroundColor,
                children: [modal.build(context, ref)],
              ),
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
    return result;
  }

  /// Displays a message modal with only one possible action.
  ///
  /// [context] to pass the currently available [BuildContext].
  ///
  /// Use [title] to describe the message title [text] to describe the message content. By using [child], the text can be substituted by a widget.
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
  /// [title]でメッセージのタイトル[text]でメッセージの内容を記述します。[child]を使用することで、テキストをウィジェットで代用することが可能です。
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
    required String title,
    required String submitText,
    Color? backgroundColor,
    Color? color,
    String? text,
    Widget? child,
    Widget? leading,
    VoidCallback? onSubmit,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
    ButtonStyle? buttonStyle,
  }) async {
    assert(
      (text != null && child == null) || (text == null && child != null),
      "If [child] is used, [text] is not required.",
    );
    var clicked = false;
    ScaffoldMessenger.of(context);
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return;
    }
    final theme = Theme.of(context);
    final foregroundColor =
        color ?? theme.dialogTheme.iconColor ?? theme.colorScheme.onSurface;
    backgroundColor ??=
        theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface;

    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
            data: theme.copyWith(
              dialogTheme: theme.dialogTheme.copyWith(
                backgroundColor: backgroundColor,
                iconColor: foregroundColor,
              ),
            ),
            child: PopScope(
              canPop: !disableBackKey,
              child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      leading,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: foregroundColor,
                    ),
                    child: child ?? Text(text ?? ""),
                  ),
                ),
                backgroundColor: backgroundColor,
                surfaceTintColor: backgroundColor,
                actions: <Widget>[
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      if (popOnPress) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                      onSubmit?.call();
                      clicked = true;
                    },
                    child: Text(submitText),
                  )
                ],
              ),
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
  /// Use [title] to describe the message title [text] to describe the message content. By using [child], the text can be substituted by a widget.
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
  /// [title]でメッセージのタイトル[text]でメッセージの内容を記述します。[child]を使用することで、テキストをウィジェットで代用することが可能です。
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
    required String title,
    required String submitText,
    required String cancelText,
    Color? backgroundColor,
    Color? color,
    String? text,
    Widget? child,
    Widget? leading,
    VoidCallback? onSubmit,
    VoidCallback? onCancel,
    bool popOnPress = true,
    bool willShowRepetition = false,
    ButtonStyle? submitButtonStyle,
    ButtonStyle? cancelButtonStyle,
  }) async {
    var state = false;
    var clicked = false;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return state;
    }
    final theme = Theme.of(context);
    final foregroundColor =
        color ?? theme.dialogTheme.iconColor ?? theme.colorScheme.onSurface;
    backgroundColor ??=
        theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface;
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
            data: theme.copyWith(
              dialogTheme: theme.dialogTheme.copyWith(
                backgroundColor: backgroundColor,
                iconColor: foregroundColor,
              ),
            ),
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: foregroundColor,
                  ),
                  child: child ?? Text(text ?? ""),
                ),
              ),
              backgroundColor: backgroundColor,
              surfaceTintColor: backgroundColor,
              actions: <Widget>[
                TextButton(
                  style: cancelButtonStyle,
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onCancel?.call();
                    state = false;
                    clicked = true;
                  },
                  child: Text(cancelText),
                ),
                TextButton(
                  style: submitButtonStyle,
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onSubmit?.call();
                    state = true;
                    clicked = true;
                  },
                  child: Text(submitText),
                )
              ],
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
    return state;
  }

  /// Display the bottom sheet as a modal.
  ///
  /// The widget to be displayed is passed to [builder].
  ///
  /// Specify the background color with [backgroundColor] and the text color with [color].
  ///
  /// モーダルとしてのボトムシートを表示します。
  ///
  /// [builder]には表示するウィジェットを渡します。
  ///
  /// [backgroundColor]で背景色、[color]でテキストカラーを指定します。
  static Future<void> bottomSheet(
    BuildContext context, {
    required List<Widget> Function(BuildContext context, VoidCallback onClose)
        builder,
    Color? backgroundColor,
    Color? color,
    bool isScrollControlled = false,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
  }) async {
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return;
    }
    final theme = Theme.of(context);
    final foregroundColor =
        color ?? theme.dialogTheme.iconColor ?? theme.colorScheme.onSurface;
    backgroundColor ??=
        theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface;
    void onClose() {
      Navigator.of(context, rootNavigator: true).pop();
    }

    await showModalBottomSheet(
      context: overlay.context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      builder: (context) {
        return Theme(
          data: theme.copyWith(
            dialogTheme: theme.dialogTheme.copyWith(
              backgroundColor: backgroundColor,
              iconColor: foregroundColor,
            ),
          ),
          child: ColoredBox(
            color: backgroundColor!,
            child: SafeArea(
              top: false,
              child: IconTheme(
                data: IconThemeData(color: foregroundColor),
                child: DefaultTextStyle(
                  style: TextStyle(color: foregroundColor),
                  child: Padding(
                    padding: contentPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: builder.call(context, onClose),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Class for controlling Modal.
///
/// Modalをコントロールするためのクラスです。
@immutable
class ModalRef<T> {
  const ModalRef._(
    this._context,
    this._onClose,
  );

  final void Function(T? result) _onClose;

  /// The root [BuildContext] of the modal.
  ///
  /// モーダルのルート[BuildContext]。
  BuildContext get rootContext => _context;
  final BuildContext _context;

  /// Closes the modal.
  ///
  /// モーダルを閉じます。
  void close([T? result]) => _onClose(result);
}
