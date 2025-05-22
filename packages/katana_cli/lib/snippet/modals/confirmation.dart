import 'package:katana_cli/katana_cli.dart';

/// Confirmation modal template.
///
/// 確認モーダルのテンプレート。
class ModalsConfirmationCliCodeSnippet extends CliCodeSnippet {
  /// Confirmation modal template.
  ///
  /// 確認モーダルのテンプレート。
  const ModalsConfirmationCliCodeSnippet();

  @override
  String get name => "ModalsConfirmation";

  @override
  String get prefix => "@modals/confirm";

  @override
  String get description => "Create a Confirmation modal. 確認モーダルを作成。";

  @override
  String body(String path, String baseName, String className) {
    return r"""Modal.confirm(
  context,
  title: l().confirmation,
  // TODO: Write a message
  text: "",
  // TODO: Describe the operation
  submitText: l().ok,
  cancelText: l().cancel,
  onSubmit: () {
    executeGuarded(
      context,
      () async {
        // TODO: Describe the process

        Modal.alert(
          context,
          title: l().success,
          // TODO: Write the completion message
          text: "",
          // TODO: Describe the action
          submitText: l().close,
          onSubmit: () {
            // TODO: Post-completion processing
          },
        );
      },
      onError: (error, stacktrace) {
        Modal.alert(
          context,
          title: l().error,
          // TODO: Describe the error message
          text: "${error.toString()}\n${stacktrace.toString()}",
          // TODO: Describe the action
          submitText: l().close,
        );
      },
    );
  },
);
""";
  }
}
