part of '/masamune_force_updater.dart';

/// Class for storing the procedure for registering with [ForceUpdater].
///
/// [checkUpdate] checks whether an update should be performed.
///
/// The [onShowUpdateDialog] displays the update dialog.
///
/// Update with [onUpdate].
///
/// [ForceUpdater]に登録するための手順を格納するためのクラス。
///
/// [checkUpdate]でアップデートを行うべきかのチェックを行います。
///
/// [onShowUpdateDialog]でアップデートのダイアログを表示します。
///
/// [onUpdate]でアップデートを行います。
@immutable
class ForceUpdaterItem {
  /// Class for storing the procedure for registering with [ForceUpdater].
  ///
  /// [checkUpdate] checks whether an update should be performed.
  ///
  /// The [onShowUpdateDialog] displays the update dialog.
  ///
  /// Update with [onUpdate].
  ///
  /// [ForceUpdater]に登録するための手順を格納するためのクラス。
  ///
  /// [checkUpdate]でアップデートを行うべきかのチェックを行います。
  ///
  /// [onShowUpdateDialog]でアップデートのダイアログを表示します。
  ///
  /// [onUpdate]でアップデートを行います。
  const ForceUpdaterItem({
    required this.checkUpdate,
    required this.onShowUpdateDialog,
    required this.onUpdate,
  });

  /// Check whether an update should be performed.
  ///
  /// If the return value is `true`, the update is performed.
  ///
  /// アップデートを行うべきかのチェックを行います。
  ///
  /// 返り値に`true`を返した場合はアップデートを行います。
  final Future<bool> Function() checkUpdate;

  /// Display the update dialog.
  ///
  /// If the return value is `true`, the update is performed.
  ///
  /// アップデートのダイアログを表示します。
  ///
  /// [context]には現状の[BuildContext]を渡してください。
  ///
  /// 返り値に`true`を返した場合はアップデートを行います。
  final Future<bool> Function(BuildContext context) onShowUpdateDialog;

  /// Actual updates will be made.
  ///
  /// If [update] is `true`, updates are performed.
  ///
  /// 実際のアップデートを行います。
  ///
  /// [update]が`true`の場合はアップデートを行います。
  final Future<void> Function(bool update) onUpdate;
}
