part of '/masamune_force_updater.dart';

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
        final update = await item.onShowUpdateDialog(context);
        await item.onUpdate(update);
      }
    }
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
