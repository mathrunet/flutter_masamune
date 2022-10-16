part of katana_router;

/// Provides extension methods for [NavigatorState].
/// [NavigatorState]の拡張メソッドを提供します。
extension RoutingNavigatorStateExtensions on NavigatorState {
  /// After returning to the first page, you will be redirected to the [newRoute] page.
  /// 最初のページに戻った後[newRoute]のページに遷移します。
  Future<T?> resetAndPush<T extends Object?>(
    Route<T> newRoute,
  ) {
    return pushAndRemoveUntil(
      newRoute,
      (route) => false,
    );
  }

  /// Page back until you find the page for [name].
  /// [name]のページが見つかるまでページを戻ります。
  ///
  /// If not found, return to the first page.
  /// 見つからない場合は最初のページまで戻ります。
  void popUntilNamed(String name) {
    popUntil((route) {
      return route.settings.name == name;
    });
  }

  /// After returning to the first page, you will be redirected to the page named [newRouteName].
  /// 最初のページに戻った後[newRouteName]の名前のページに遷移します。
  ///
  /// You can pass parameters to the page by giving [arguments].
  /// [arguments]を与えることでページにパラメータを渡すことができます。
  Future<T?> resetAndPushNamed<T extends Object?>(
    String newRouteName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil(
      newRouteName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Page back to the [pageQuery] page.
  /// [pageQuery]のページまでページを戻ります。
  ///
  /// If not found, return to the first page.
  /// 見つからない場合は最初のページまで戻ります。
  void popUntilPage(RouteQuery pageQuery) {
    return popUntilNamed(pageQuery.toString());
  }

  /// After returning to the first page, you will be redirected to the [newRoutePage] page.
  /// 最初のページに戻った後[newRoutePage]のページに遷移します。
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
  /// You can specify page transitions, etc. by giving [query].
  /// [query]を与えることでページのトランジションなどを指定することができます。
  Future<T?> resetAndPushPage<T extends Object?>(
    RouteQuery newRoutePage, [
    TransitionQuery? query,
  ]) async {
    final route = newRoutePage.route<T>(query);
    return resetAndPush<T>(
      route.createRoute(context),
    );
  }

  /// You can return one page and go to the [routePage] page.
  /// 一つページを戻り[routePage]のページに遷移することができます。
  ///
  /// By giving [result] when returning to one page, you will receive [result] on the page you have returned to.
  /// 一つページを戻る際に[result]を与えることで戻った先のページで[result]を受け取ります。
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
  /// You can specify page transitions, etc. by giving [query].
  /// [query]を与えることでページのトランジションなどを指定することができます。
  Future<T?> popAndPushPage<T extends Object?, TO extends Object?>(
    RouteQuery routePage, {
    TO? result,
    TransitionQuery? query,
  }) {
    pop<TO>(result);
    return pushPage(routePage, query);
  }

  /// Moves to a new [routePage].
  /// 新しい[routePage]に遷移します。
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
  /// You can specify page transitions, etc. by giving [query].
  /// [query]を与えることでページのトランジションなどを指定することができます。
  Future<T?> pushPage<T extends Object?>(
    RouteQuery routePage, [
    TransitionQuery? query,
  ]) async {
    final route = routePage.route<T>(query);
    return push<T>(
      route.createRoute(context),
    );
  }

  /// After returning to the page that matches the [predicate] condition, the user is redirected to the [newRoutePage] page.
  /// [predicate]の条件に合致するページに戻った後[newRoutePage]のページに遷移します。
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
  /// You can specify page transitions, etc. by giving [query].
  /// [query]を与えることでページのトランジションなどを指定することができます。
  Future<T?> pushPageAndRemoveUntil<T extends Object?>(
    RouteQuery newRoutePage,
    RoutePredicate predicate, [
    TransitionQuery? query,
  ]) async {
    final route = newRoutePage.route<T>(query);
    return pushAndRemoveUntil<T>(
      route.createRoute(context),
      predicate,
    );
  }

  /// Replace the current page with the new [routePage].
  /// 現在のページを新しい[routePage]に置き換えます。
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
  /// You can specify page transitions, etc. by giving [query].
  /// [query]を与えることでページのトランジションなどを指定することができます。
  Future<T?> pushReplacementPage<T extends Object?, TO extends Object?>(
    RouteQuery routePage, {
    TO? result,
    TransitionQuery? query,
  }) async {
    return pushReplacement<T, TO>(
      routePage.route<T>(query).createRoute(context),
      result: result,
    );
  }
}

/// Provides extension methods for [BuildContext].
/// [BuildContext]の拡張メソッドを提供します。
extension RoutingBuildContedxtExtensions on BuildContext {
  /// Get [AppRouterBase].
  /// [AppRouterBase]を取得します。
  ///
  /// Page transitions can be performed directly by executing [AppRouterBase.push], [AppRouterBase.replace], or [AppRouterBase.pop].
  /// [AppRouterBase.push]や[AppRouterBase.replace]、[AppRouterBase.pop]を実行することでページ遷移を直接行うことが可能です。
  AppRouterBase get router {
    return AppRouterBase.of(this);
  }

  /// Get the root [AppRouterBase].
  /// ルートの[AppRouterBase]を取得します。
  ///
  /// Page transitions can be performed directly by executing [AppRouterBase.push], [AppRouterBase.replace], or [AppRouterBase.pop].
  /// [AppRouterBase.push]や[AppRouterBase.replace]、[AppRouterBase.pop]を実行することでページ遷移を直接行うことが可能です。
  AppRouterBase get rootRouter {
    return AppRouterBase.of(this, root: true);
  }
}
