part of masamune_scheduler;

const _kModelSchedulerCommand = "model";

/// Mix-in to define a document with a schedule for adding and updating models at specified dates and times.
///
/// Mix this in with the value you want [DocumentBase] to have.
///
/// モデルを指定日時に追加・更新するためのスケジュールを持ったドキュメントを定義するためのミックスイン。
///
/// これを[DocumentBase]に持たせる値にミックスインしてください。
abstract class ModelScheduleMixin {
  /// Submission Date.
  ///
  /// 投稿日時。
  ModelTimestamp get time;

  /// The path to the posting.
  ///
  /// 投稿先のパス。
  String get path;
}

/// Provides extension methods for [CollectionBase] of [DocumentBase] with mixed-in [ModelScheduleMixin] objects.
///
/// [ModelScheduleMixin]をミックスインしたオブジェクトを持つ[DocumentBase]の[CollectionBase]の拡張メソッドを提供します。
extension ModelSchedulerCollectionExtensions<
        TModelSchedule extends ModelScheduleMixin,
        TDocument extends DocumentBase<TModelSchedule>>
    on CollectionBase<TDocument> {
  /// Create a document with a schedule for adding and updating models at specified dates and times.
  ///
  /// You must create a model with [ModelScheduleMixin] mixed in.
  ///
  /// モデルを指定日時に追加・更新するためのスケジュールを持ったドキュメントを作成します。
  ///
  /// [ModelScheduleMixin]をミックスインしたモデルを作成する必要があります。
  TDocument createSchedule({
    required DateTime time,
    String? target,
  }) {
    return create(
      SchedulerQuery.createScheduleId(
        time: time,
        command: _kModelSchedulerCommand,
        target: target,
      ),
    );
  }
}
