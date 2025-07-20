part of "/katana_scoped.dart";

/// Base class for References passed from ScopedWidget, etc.
///
/// This can be extended with an extension to add a method for handling [ScopedValue].
///
/// In that case, use [getScopedValue] to create a method that generates a [ScopedValue] and returns the value.
///
/// ScopedWidget等から渡されるReferenceのベースクラス。
///
/// これをextensionで拡張することで[ScopedValue]を扱うメソッドを追加することができます。
///
/// その場合、[getScopedValue]で[ScopedValue]を生成して値を返すメソッドを作成してください。
///
/// ```dart
/// extension RefCacheExtensions on Ref {
///   T cache<T>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getState<T, _CacheValue<T>>(
///       () => _CacheValue<T>(callback: callback, keys: keys),
///       listen: false,
///     );
///   }
/// }
/// ```
@immutable
abstract class Ref implements RefOrRefHasAny {
  /// {@template ref}
  /// Base class for References passed from ScopedWidget, etc.
  ///
  /// This can be extended with an extension to add a method for handling [ScopedValue].
  ///
  /// In that case, use [getScopedValue] to generate and pass [ScopedValue].
  ///
  /// ScopedWidget等から渡されるReferenceのベースクラス。
  ///
  /// これをextensionで拡張することで[ScopedValue]を扱うメソッドを追加することができます。
  ///
  /// その場合、[getScopedValue]で[ScopedValue]を生成して渡してください。
  ///
  /// ```dart
  /// extension RefCacheExtensions on Ref {
  ///   T cache<T>(
  ///     T Function() callback, {
  ///     List<Object> keys = const [],
  ///   }) {
  ///     return getState<T, _CacheValue<T>>(
  ///       () => _CacheValue<T>(callback: callback, keys: keys),
  ///       listen: false,
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  const Ref();

  /// {@template get_scoped_value}
  /// A method that returns the value of [TResult] while creating, saving, and managing the state of [TScopedValue].
  ///
  /// Specify a callback to generate [TScopedValue] in [provider].
  ///
  /// If [listen] is specified, the process of redrawing the widget or page will run when the value is updated (when [ScopedValueState.setState] is executed) on the widget or page that uses this.
  ///
  /// Basically, [TScopedValue] is stored with the type name of [TScopedValue] as `Key`.
  /// (All generic types are also taken into account. ValueNotifier&lt;int&gt;` and `ValueNotifier&lt;double&gt;` are recognized as separate `Keys`)
  ///
  /// If a value already exists for the same `Key` in the respective scopes of the app, page, and widget, the same object is retrieved as the last retrieved object.
  /// (If the scope is different, such as app and page, you will get a different object even if the same `Key` is used.)
  ///
  /// If you want to keep them as different values with the same type on the same scope, specify [name] explicitly.
  /// If both type and [name] are the same, they are considered to be the same `Key`.
  ///
  /// [TScopedValue]の生成・保存・状態管理を行いつつ[TResult]の値を返すメソッド。
  ///
  /// [provider]に[TScopedValue]を生成するためのコールバックを指定します。
  ///
  /// [listen]を指定するとこれを利用したWidgetやページで値の更新時（[ScopedValueState.setState]実行時）にWidgetやページを再描画する処理が走ります。
  ///
  /// 基本的には[TScopedValue]の型名を`Key`として[TScopedValue]が保存されます。
  /// （ジェネリックタイプもすべて考慮されます。`ValueNotifier<int>`と`ValueNotifier<double>`は別の`Key`として認識されます。）
  ///
  /// アプリとページ、ウィジェットのそれぞれのスコープにおいて、すでに同じ`Key`に値が存在している場合、前回取得したオブジェクトと同じオブジェクトが取得されます。
  /// （アプリとページなどスコープが異なる場合は同じ`Key`だった場合でも別のオブジェクトが取得されます。）
  ///
  /// 同一スコープ上で同じ型で別の値として保持したい場合は[name]を明示的に指定してください。
  /// 型と[name]がどちらも同じ場合は同じ`Key`としてみなされます。
  /// {@endtemplate}
  TResult getScopedValue<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function(Ref ref) provider, {
    void Function(ScopedValueState<TResult, TScopedValue> state)? onInit,
    void Function(ScopedValueState<TResult, TScopedValue> state)? onUpdate,
    bool listen = false,
    Object? name,
  });

  /// {@template get_already_exists_scoped_value}
  /// Obtains a [TScopedValue] already stored in [ScopedValueContainer].
  ///
  /// Returns [Null] if [TScopedValue] does not exist.
  ///
  /// If [TScopedValue] was saved with [name], specify the same [name].
  ///
  /// If [listen] is `true`, then it should be associated with the widget to notify it of changes.
  ///
  /// If [recursive] is `true`, the search is recursive from child to parent in the same scope.
  ///
  /// [ScopedValueState.setState], [ScopedValueState.initValue] and [ScopedValueState.didUpdateValue] are not executed.
  ///
  /// [ScopedValueContainer]にすでに保存されている[TScopedValue]を取得します。
  ///
  /// [TScopedValue]が存在しない場合は[Null]を返します。
  ///
  /// [name]を指定して[TScopedValue]を保存していた場合、同じ[name]を指定してください。
  ///
  /// [listen]が`true`の場合、ウィジェットに関連付けて変更を通知するようにします。
  ///
  /// [recursive]が`true`な場合、同じスコープの子から親へと再帰的に検索します。
  ///
  /// [ScopedValueState.setState]や[ScopedValueState.initValue]、[ScopedValueState.didUpdateValue]は実行されません。
  /// {@endtemplate}
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    Object? name,
    bool listen = false,
    bool recursive = true,
  });
}

/// Reference with [ScopedValueRef] in the application scope.
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores the value in the application.
///
/// For example, data loaded from a remote server should be stored in the application scope since it is used between pages. Therefore, by extending this class to explicitly limit the scope in which it is used, it is possible to specify how data is held in a way that is easy for developers to understand.
///
/// アプリケーションスコープの[Ref]を持ったリファレンス。
///
/// これをextensionで拡張することでアプリケーションに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
///　例えば、リモートサーバーからロードするデータはページ間で利用されるものなのでアプリケーションスコープで保存されるべきものです。そのためこのクラスを拡張して利用されるスコープを明示的に限定することで開発者に分かりやすくデータの持ち方を指定することが可能です。
///
/// ```dart
/// extension AppRefRepositoryExtensions on RefHasApp {
///   T repository<T extends ChangeNotifier>(
///     T Function() callback,
///   ) {
///     return app.watch(callback);
///   }
/// }
/// ```
@immutable
abstract class RefHasApp implements RefOrRefHasAny, RefHasAny {
  /// [Ref] in the application scope.
  ///
  /// アプリケーションスコープの[Ref]。
  AppScopedValueRef get app;
}

/// Reference with page scope [Ref].
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value per page.
///
/// For example, the state of the currently displayed tab should be stored on a page-by-page basis. Therefore, by extending this class to explicitly limit the scope of use, it is possible to specify how data is held in a way that is easy for developers to understand.
///
/// ページスコープの[Ref]を持ったリファレンス。
///
/// これをextensionで拡張することでページごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
///　例えば、現在表示しているタブの状態などはページごとに保存されるべきものです。そのためこのクラスを拡張して利用されるスコープを明示的に限定することで開発者に分かりやすくデータの持ち方を指定することが可能です。
///
/// ```dart
/// extension PageRefTabExtensions on RefHasPage {
///   String useTab(
///     String defaultTabId
///   ) {
///     return page.watch(() => ValueNotifier(defaultTabId));
///   }
/// }
/// ```
@immutable
abstract class RefHasPage implements RefOrRefHasAny, RefHasAny {
  /// [Ref] in the page scope.
  ///
  /// ページスコープの[Ref]。
  PageScopedValueRef get page;
}

/// Reference with widget scope [Ref].
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value for each widget.
///
/// For example, if you want to create a system where the text character is changed each time a button is tapped, the state should be stored in the widget. Therefore, by extending this class to explicitly limit the scope in which it is used, it is possible to specify how the data is held in a way that is easy for the developer to understand.
///
/// ウィジェットスコープの[Ref]を持ったリファレンス。
///
/// これをextensionで拡張することでウィジェットごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
///　例えば、テキストの文字をボタンがタップされるごとに変更されるような仕組みを作りたい場合、ウィジェットの中に状態が保存されるべきです。そのためこのクラスを拡張して利用されるスコープを明示的に限定することで開発者に分かりやすくデータの持ち方を指定することが可能です。
///
/// ```dart
/// extension WidgetRefValueExtensions on RefHasWidget {
///   String useValue(
///     String defaultValue
///   ) {
///     return widget.watch(() => ValueNotifier(defaultValue));
///   }
/// }
/// ```
@immutable
abstract class RefHasWidget implements RefOrRefHasAny, RefHasAny {
  /// [Ref] in the widget scope.
  ///
  /// ウィジェットスコープの[Ref]。
  WidgetScopedValueRef get widget;
}

/// [RefHasApp] or [RefHasPage], [RefHasWidget].
///
/// [RefHasApp]もしくは[RefHasPage]、[RefHasWidget]。
@immutable
abstract class RefHasAny implements RefOrRefHasAny {}

/// [Ref] or [RefHasApp], [RefHasPage], [RefHasWidget].
///
/// [Ref]もしくは[RefHasApp]、[RefHasPage]、[RefHasWidget]。
@immutable
abstract class RefOrRefHasAny {}
