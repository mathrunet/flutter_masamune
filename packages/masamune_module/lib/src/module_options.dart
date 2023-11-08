part of '/masamune_module.dart';

/// Module Options.
///
/// Defines module-specific words and settings.
///
/// モジュールのオプション。
///
/// モジュール特有の単語や設定を定義します。
abstract class ModuleOptions {
  /// Module Options.
  ///
  /// Defines module-specific words and settings.
  ///
  /// モジュールのオプション。
  ///
  /// モジュール特有の単語や設定を定義します。
  const ModuleOptions();
}

/// List of module pages.
///
/// Defines module-specific pages.
///
/// モジュールのページ一覧。
///
/// モジュール特有のページを定義します。
abstract class ModulePages {
  /// List of module pages.
  ///
  /// Defines module-specific pages.
  ///
  /// モジュールのページ一覧。
  ///
  /// モジュール特有のページを定義します。
  const ModulePages();

  /// Defines a list of pages.
  ///
  /// ページのリストを定義します。
  List<RouteQueryBuilder> get pages;
}
