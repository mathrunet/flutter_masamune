part of '/masamune.dart';

/// This is an extension method of [ControllerQueryBase].
///
/// [ControllerQueryBase]の拡張メソッドです。
extension ControllerQueryBaseExtensions<TController extends Listenable>
    on ControllerQueryBase<TController> {
  /// Get [TController] stored in [ref] in the same way as `ref.app.controller`.
  ///
  /// `ref.app.controller`と同じように[ref]に格納されている[TController]を取得します。
  TController read(Ref ref) {
    return ref.controller(this);
  }

  /// Get [TController] while monitoring with widgets related to [ref] in the same way as `ref.app.controller`.
  ///
  /// [TController] is retained in the app scope.
  ///
  /// `ref.app.controller`と同じように[ref]に関連するウィジェットで監視を行いつつ[TController]を取得します。
  ///
  /// アプリスコープで[TController]が保持されます。
  TController watchOnApp(RefHasApp ref) {
    return ref.app.controller(this);
  }

  /// Get [TController] while monitoring with widgets related to [ref] in the same way as `ref.page.controller`.
  ///
  /// [TController] is retained in the page scope.
  ///
  /// `ref.page.controller`と同じように[ref]に関連するウィジェットで監視を行いつつ[TController]を取得します。
  ///
  /// ページスコープで[TController]が保持されます。
  TController watchOnPage(RefHasPage ref) {
    return ref.page.controller(this);
  }
}

/// This is an extension method of [Listenable].
///
/// [Listenable]の拡張メソッドです。
extension ListenableQueryExtensions<TController extends Listenable>
    on TController {
  /// Get [TController] while monitoring with widgets related to [ref] in the same way as `ref.global`.
  ///
  /// `ref.global`と同じように[ref]に関連するウィジェットで監視を行いつつ[TController]を取得します。
  TController watch(RefHasApp ref) {
    return ref.global(this);
  }
}
