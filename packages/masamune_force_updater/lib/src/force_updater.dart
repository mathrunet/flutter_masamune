part of "/masamune_force_updater.dart";

/// [MasamuneControllerBase] for forced updates.
///
/// [checkUpdate] checks whether an update should be performed.
///
/// 強制アップデートを行うための[MasamuneControllerBase]。
///
/// [checkUpdate]でアップデートを行うべきかのチェックを行います。
class ForceUpdater
    extends MasamuneControllerBase<void, ForceUpdaterMasamuneAdapter> {
  /// [MasamuneControllerBase] for forced updates.
  ///
  /// [checkUpdate] checks whether an update should be performed.
  ///
  /// 強制アップデートを行うための[MasamuneControllerBase]。
  ///
  /// [checkUpdate]でアップデートを行うべきかのチェックを行います。
  ForceUpdater({super.adapter});

  /// Query for Picker.
  ///
  /// ```dart
  /// appRef.controller(ForceUpdater.query(parameters));     // Get from application scope.
  /// ref.app.controller(ForceUpdater.query(parameters));    // Watch at application scope.
  /// ref.page.controller(ForceUpdater.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$ForceUpdaterQuery();

  @override
  ForceUpdaterMasamuneAdapter get primaryAdapter =>
      ForceUpdaterMasamuneAdapter.primary;

  static Future<void> _defaultOnUpdate(bool update) => Future.value();

  /// Check whether an update should be performed.
  ///
  /// Pass the current [BuildContext] to [context].
  ///
  /// In [items], specify [ForceUpdaterItem] for updating.
  ///
  /// アップデートを行うべきかのチェックを行います。
  ///
  /// [context]には現状の[BuildContext]を渡してください。
  ///
  /// [items]にはアップデートを行うための[ForceUpdaterItem]を指定します。
  Future<void> checkUpdate(
    BuildContext context, {
    List<ForceUpdaterItem>? items,
  }) async {
    items ??= adapter.defaultUpdates;
    if (items.isEmpty) {
      return;
    }
    for (final item in items) {
      if (await item.checkUpdate()) {
        final ref = ForceUpdaterRef._(
          onUpdate: item.onUpdate ?? _defaultOnUpdate,
        );
        await item.onShowUpdateDialog(context, ref);
      }
    }
  }
}

/// Class for performing updates from [ForceUpdater].
///
/// [ForceUpdater]からアップデートを実行するためのクラス。
class ForceUpdaterRef {
  const ForceUpdaterRef._({
    required Future<void> Function(bool update) onUpdate,
  }) : _onUpdate = onUpdate;

  final Future<void> Function(bool update) _onUpdate;

  /// Update the application.
  ///
  /// If [update] is `true`, updates are performed.
  ///
  /// アプリケーションをアップデートします。
  ///
  /// [update]が`true`の場合はアップデートを行います。
  Future<void> update([bool update = true]) async {
    await _onUpdate(update);
  }

  /// Quit the application.
  ///
  /// アプリケーションを終了します。
  Future<void> quit() async {
    SystemNavigator.pop();
  }
}

@immutable
class _$ForceUpdaterQuery {
  const _$ForceUpdaterQuery();

  @useResult
  _$_ForceUpdaterQuery call() => _$_ForceUpdaterQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_ForceUpdaterQuery extends ControllerQueryBase<ForceUpdater> {
  const _$_ForceUpdaterQuery(
    this._name,
  );

  final String _name;

  @override
  ForceUpdater Function() call(Ref ref) {
    return () => ForceUpdater();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
