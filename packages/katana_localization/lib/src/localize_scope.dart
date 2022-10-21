part of katana_localization;

/// Widget to detect localization changes.
///
/// Passing [localize] will rebuild all widgets for language changes made in [AppLocalizeBase].
///
/// Place it on top of [MaterialApp], etc. as shown in the example below. Also, pass appropriate values for [MaterialApp.locale], [MaterialApp.localizationsDelegates], [MaterialApp.supportedLocales], and [MaterialApp. localeResolutionCallback], respectively.
///
/// ローカライズの変更を検知するためのウィジェット。
///
/// [localize]を渡すことで[AppLocalizeBase]で行われた言語の変更に対してすべてのウィジェットを再ビルドします。
///
/// 下記例のように[MaterialApp]などの上に置いてください。また、[builder]の[localize]から[MaterialApp.locale]、[MaterialApp.localizationsDelegates]、[MaterialApp.supportedLocales]、[MaterialApp.localeResolutionCallback]に対してそれぞれ適切な値を渡してください。
///
/// ```dart
/// LocalizeScope(
///   localize: AppLocalize(),
///   builder: (context, localize) {
///     return MaterialApp(
///       locale: localize.locale,
///       localizationsDelegates: localize.delegates(),
///       supportedLocales: localize.supportedLocales(),
///       localeResolutionCallback: localize.localeResolutionCallback(),
///     );
///   }
/// );
/// ```
class LocalizeScope extends StatefulWidget {
  /// Widget to detect localization changes.
  ///
  /// Passing [localize] will rebuild all widgets for language changes made in [AppLocalizeBase].
  ///
  /// Place it on top of [MaterialApp], etc. as shown in the example below. Also, pass appropriate values for [MaterialApp.locale], [MaterialApp.localizationsDelegates], [MaterialApp.supportedLocales], and [MaterialApp. localeResolutionCallback], respectively.
  ///
  /// ローカライズの変更を検知するためのウィジェット。
  ///
  /// [localize]を渡すことで[AppLocalizeBase]で行われた言語の変更に対してすべてのウィジェットを再ビルドします。
  ///
  /// 下記例のように[MaterialApp]などの上に置いてください。また、[builder]の[localize]から[MaterialApp.locale]、[MaterialApp.localizationsDelegates]、[MaterialApp.supportedLocales]、[MaterialApp.localeResolutionCallback]に対してそれぞれ適切な値を渡してください。
  ///
  /// ```dart
  /// LocalizeScope(
  ///   localize: AppLocalize(),
  ///   builder: (context, localize) {
  ///     return MaterialApp(
  ///       locale: localize.locale,
  ///       localizationsDelegates: localize.delegates(),
  ///       supportedLocales: localize.supportedLocales(),
  ///       localeResolutionCallback: localize.localeResolutionCallback(),
  ///     );
  ///   }
  /// );
  /// ```
  const LocalizeScope({
    super.key,
    required this.localize,
    required this.builder,
  });

  /// AppLocalizeBase] manages the language settings for the application.
  ///
  /// アプリケーションの言語設定を管理する[AppLocalizeBase]。
  final AppLocalizeBase localize;

  /// The builder of the subject to be rebuilt.
  ///
  /// Return [MaterialApp], etc. as shown in the example below. Also, from [localize] in [builder], pass appropriate values for [MaterialApp.locale], [MaterialApp.localizationsDelegates], [MaterialApp.supportedLocales], and [MaterialApp. localeResolutionCallback], respectively.
  ///
  ///リビルドを行う対象のビルダー。
  ///
  /// 下記例のように[MaterialApp]などを返してください。また、[builder]の[localize]から[MaterialApp.locale]、[MaterialApp.localizationsDelegates]、[MaterialApp.supportedLocales]、[MaterialApp.localeResolutionCallback]に対してそれぞれ適切な値を渡してください。
  ///
  /// ```dart
  /// LocalizeScope(
  ///   localize: AppLocalize(),
  ///   builder: (context, localize) {
  ///     return MaterialApp(
  ///       locale: localize.locale,
  ///       localizationsDelegates: localize.delegates(),
  ///       supportedLocales: localize.supportedLocales(),
  ///       localeResolutionCallback: localize.localeResolutionCallback(),
  ///     );
  ///   }
  /// );
  /// ```
  final Widget Function(BuildContext context, AppLocalizeBase localize) builder;

  @override
  State<StatefulWidget> createState() => _LocalizeScopeState();
}

class _LocalizeScopeState extends State<LocalizeScope> {
  @override
  void initState() {
    super.initState();
    widget.localize.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateWidget(LocalizeScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.localize != oldWidget.localize) {
      oldWidget.localize.removeListener(_handledOnUpdate);
      oldWidget.localize.dispose();
      widget.localize.addListener(_handledOnUpdate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.localize.removeListener(_handledOnUpdate);
    widget.localize.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.localize);
  }
}
