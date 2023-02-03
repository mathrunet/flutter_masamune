part of katana_prefs;

/// Base class for creating Prefs classes.
///
/// [load] to retrieve data in `SharedPreferences` asynchronously.
///
/// Prefsのクラスを作成するためのベースクラス。
///
/// [load]を実行すると`SharedPreferences`のデータの取得を非同期で行います。
abstract class PrefsBase implements ChangeNotifier {
  /// Asynchronous retrieval of `SharedPreferences` data.
  ///
  /// `SharedPreferences`のデータの取得を非同期で行います。
  Future<void> load() => throw UnimplementedError();

  /// You can wait until it finishes when you run [load].
  ///
  /// [load]を実行した場合にそれが終わるまで待つことができます。
  Future<void>? get loading => throw UnimplementedError();

  @override
  void addListener(VoidCallback listener) => throw UnimplementedError();
  @override
  void removeListener(VoidCallback listener) => throw UnimplementedError();
  @override
  void notifyListeners() => throw UnimplementedError();
  @override
  void dispose() => throw UnimplementedError();
  @override
  bool get hasListeners => throw UnimplementedError();
}
