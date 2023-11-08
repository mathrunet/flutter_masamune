part of '/katana_router.dart';

/// Provides extension methods for [NavigatorState].
///
/// [NavigatorState]の拡張メソッドを提供します。
extension RoutingNavigatorStateExtensions on NavigatorState {
  /// After returning to the first page, you will be redirected to the [newRoute] page.
  ///
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
  ///
  /// If not found, return to the first page.
  ///
  /// [name]のページが見つかるまでページを戻ります。
  ///
  /// 見つからない場合は最初のページまで戻ります。
  void popUntilNamed(String name) {
    popUntil((route) {
      return route.settings.name == name;
    });
  }

  /// After returning to the first page, you will be redirected to the page named [newRouteName].
  ///
  /// You can pass parameters to the page by giving [arguments].
  ///
  /// 最初のページに戻った後[newRouteName]の名前のページに遷移します。
  ///
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

  /// Page back to the [routeQuery] page.
  ///
  /// If not found, return to the first page.
  ///
  /// [routeQuery]のページまでページを戻ります。
  ///
  /// 見つからない場合は最初のページまで戻ります。
  void popUntilPage(RouteQuery routeQuery) {
    return popUntilNamed(routeQuery.toString());
  }

  /// After returning to the first page, you will be redirected to the [newRoutePage] page.
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  ///
  /// You can specify page transitions, etc. by giving [query].
  ///
  /// 最初のページに戻った後[newRoutePage]のページに遷移します。
  ///
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
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
  ///
  /// By giving [result] when returning to one page, you will receive [result] on the page you have returned to.
  ///
  /// If there is a [RedirectQuery] in [routePage] and the condition is met, the user may be redirected to that page.
  ///
  /// You can specify page transitions, etc. by giving [query].
  ///
  /// 一つページを戻り[routePage]のページに遷移することができます。
  ///
  /// 一つページを戻る際に[result]を与えることで戻った先のページで[result]を受け取ります。
  ///
  /// [routePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
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
  ///
  /// If there is a [RedirectQuery] in [routePage] and the condition is met, the user may be redirected to that page.
  ///
  /// You can specify page transitions, etc. by giving [query].
  ///
  /// 新しい[routePage]に遷移します。
  ///
  /// [routePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
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
  ///
  /// If there is a [RedirectQuery] in [newRoutePage] and the condition is met, the user may be redirected to that page.
  ///
  /// You can specify page transitions, etc. by giving [query].
  ///
  /// [predicate]の条件に合致するページに戻った後[newRoutePage]のページに遷移します。
  ///
  /// [newRoutePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
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
  ///
  /// If there is a [RedirectQuery] in [routePage] and the condition is met, the user may be redirected to that page.
  ///
  /// You can specify page transitions, etc. by giving [query].
  ///
  /// 現在のページを新しい[routePage]に置き換えます。
  ///
  /// [routePage]内に[RedirectQuery]があり条件に合致した場合、そのページに遷移する場合があります。
  ///
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
///
/// [BuildContext]の拡張メソッドを提供します。
extension RoutingBuildContedxtExtensions on BuildContext {
  /// Get [AppRouter].
  ///
  /// Page transitions can be performed directly by executing [AppRouter.push], [AppRouter.replace], or [AppRouter.pop].
  ///
  /// [AppRouter]を取得します。
  ///
  /// [AppRouter.push]や[AppRouter.replace]、[AppRouter.pop]を実行することでページ遷移を直接行うことが可能です。
  AppRouter get router {
    return AppRouter.of(this);
  }

  /// Get the root [AppRouter].
  ///
  /// Page transitions can be performed directly by executing [AppRouter.push], [AppRouter.replace], or [AppRouter.pop].
  ///
  /// ルートの[AppRouter]を取得します。
  ///
  /// [AppRouter.push]や[AppRouter.replace]、[AppRouter.pop]を実行することでページ遷移を直接行うことが可能です。
  AppRouter get rootRouter {
    return AppRouter.of(this, root: true);
  }

  /// Get the root [BuildContext] that is not affected by the build of the page.
  ///
  /// ページのビルドに影響されないルートの[BuildContext]を取得します。
  BuildContext get rootContext {
    final navigator = Navigator.of(this, rootNavigator: true);
    return navigator.context;
  }
}

/// Provides extension methods for [RouteQuery].
///
/// [RouteQuery]の拡張メソッドを提供します。
extension RouteQueryRouterExtensions on RouteQuery {
  /// Passing [router] will take you to a new page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [router]を渡すことにより新しいページに遷移します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> push<E>(
    AppRouter? router, [
    TransitionQuery? transitionQuery,
  ]) {
    if (router == null) {
      return Future.value();
    }
    return router.push<E>(
      this,
      transitionQuery,
    );
  }

  /// Passing [router] replaces the currently displayed page with a new page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [router]を渡すことにより現在表示されているページを新しいページに置き換えます。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> replace<E>(
    AppRouter? router, [
    TransitionQuery? transitionQuery,
  ]) {
    if (router == null) {
      return Future.value();
    }
    return router.replace<E>(
      this,
      transitionQuery,
    );
  }

  /// It keeps [pop] until the history stack runs out and then [push] itself.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// ヒストリーのスタックがなくなるまで[pop]し続けた後自身を[push]します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  Future<E?> resetAndPush<E>(
    AppRouter? router, [
    TransitionQuery? transitionQuery,
  ]) {
    if (router == null) {
      return Future.value();
    }
    return router.resetAndPush<E>(
      this,
      transitionQuery,
    );
  }
}
