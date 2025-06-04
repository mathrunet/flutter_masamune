part of "/masamune.dart";

/// This is an extension method of [ControllerQueryBase].
///
/// [ControllerQueryBase]の拡張メソッドです。
extension ControllerQueryBaseExtensions<TController extends Listenable>
    on ControllerQueryBase<TController> {
  /// Get [TController] stored in [ref] in the same way as `ref.app.controller`.
  ///
  /// `ref.app.controller`と同じように[ref]に格納されている[TController]を取得します。
  TController read(AppRef ref) {
    return ref.controller(this);
  }

  /// Get [TController] while monitoring with widgets related to [ref] in the same way as `ref.app.controller`.
  ///
  /// [TController] is retained in the app scope.
  ///
  /// `ref.app.controller`と同じように[ref]に関連するウィジェットで監視を行いつつ[TController]を取得します。
  ///
  /// アプリスコープで[TController]が保持されます。
  TController watch(RefHasApp ref) {
    return ref.app.controller(this);
  }
}
