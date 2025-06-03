part of "/masamune_scheduler.dart";

/// Holds configuration data for the scheduler.
///
/// You can use [path] to obtain a common path for the scheduler.
///
/// スケジューラー用のコンフィグデータを保持しています。
///
/// [path]でスケジューラー用の共通のパスを取得することができます。
class SchedulerQuery {
  SchedulerQuery._();

  /// Collection path to register the scheduler.
  ///
  /// スケジューラーを登録するためのコレクションパス。
  static const String path = "plugins/scheduler/schedule";

  /// Get the ID for the scheduler document.
  ///
  /// スケジューラーのドキュメント用のIDを取得します。
  static String generateScheduleId({
    required DateTime time,
    required String command,
    String? target,
  }) {
    return "${time.format("yyyyMMddHHmmssSSS")}:$command:$target";
  }
}
