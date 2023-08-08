part of katana_router.web;

/// Sets the URL strategy of your web app to using paths instead of a leading hash (#).
///
/// You can safely call this on all platforms, i.e. also when running on mobile or desktop. In that case, it will simply be a noop.
///
/// Web アプリの URL 戦略を、先頭のハッシュ (#) の代わりにパスを使用するように設定します。
///
/// これは、すべてのプラットフォームで安全に呼び出すことができます。つまり、モバイルまたはデスクトップで実行している場合でも同様です。その場合、それは単にヌープになります。
void setPathUrlStrategy() {
  setUrlStrategy(PathUrlStrategy());
}
