part of masamune_scheduler;

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
  static String createScheduleId({
    required DateTime time,
    required String command,
    String? target,
  }) {
    return "${time.format("yyyyMMddHHmmssSSS")}:$command:$target";
  }
}

/// Provides extension methods for [CollectionModelQuery].
///
/// [CollectionModelQuery]の拡張メソッドを提供します。
extension SchedulerCollectionModelQueryExtensions on CollectionModelQuery {
  /// Create a document with a schedule for adding and updating models at specified dates and times.
  ///
  /// You must create a model with [ModelScheduleMixin] mixed in.
  ///
  /// モデルを指定日時に追加・更新するためのスケジュールを持ったドキュメントを作成します。
  ///
  /// [ModelScheduleMixin]をミックスインしたモデルを作成する必要があります。
  DocumentModelQuery createSchedule({
    required DateTime time,
    required String command,
    String? target,
  }) {
    return create(
      SchedulerQuery.createScheduleId(
        time: time,
        command: command,
        target: target,
      ),
    );
  }
}
