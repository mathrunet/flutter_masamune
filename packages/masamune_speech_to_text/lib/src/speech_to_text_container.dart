part of "/masamune_speech_to_text.dart";

/// Container for Speech-to-Text.
///
/// Speech-to-Textのコンテナ。
abstract class SpeechToTextContainer {
  /// Container for Speech-to-Text.
  ///
  /// Speech-to-Textのコンテナ。
  SpeechToTextContainer({
    this.onError,
    this.onStatus,
  });

  /// Called when an error occurs.
  ///
  /// エラーが発生した場合に呼ばれます。
  final void Function(Object error)? onError;

  /// Called when the status changes.
  ///
  /// ステータスが変更された場合に呼ばれます。
  final void Function(String status)? onStatus;

  /// Returns `true` if the container is listening.
  ///
  /// コンテナが音声認識中の場合`true`を返します。
  bool get listening;

  /// Complete the container with an error.
  ///
  /// コンテナをエラーで完了します。
  void error(Object error);

  /// Complete the container.
  ///
  /// コンテナを完了します。
  void complete(SpeechToTextResponse? response);
}
