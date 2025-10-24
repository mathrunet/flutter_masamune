part of "/katana_ui.dart";

/// A builder widget that displays loading indicators while waiting for multiple futures.
///
/// This widget waits for multiple Future, FutureOr, or null values to complete
/// and displays a loading indicator until all are finished. Perfect for data
/// loading screens, async initialization, and multi-source data fetching.
///
/// Features:
/// - Wait for multiple futures simultaneously
/// - Customizable loading widget
/// - Default centered CircularProgressIndicator
/// - Configurable indicator color
/// - Handles Future, FutureOr, and null values
/// - Automatic null filtering
///
/// Example:
/// ```dart
/// LoadingBuilder(
///   futures: [
///     fetchUserData(),
///     fetchSettings(),
///     fetchNotifications(),
///   ],
///   builder: (context) {
///     return Column(
///       children: [
///         Text("All data loaded!"),
///         UserDataWidget(),
///         SettingsWidget(),
///       ],
///     );
///   },
/// )
/// ```
///
/// 複数のfutureを待機している間にローディングインジケータを表示するビルダーウィジェット。
///
/// このウィジェットは複数のFuture、FutureOr、またはnull値が完了するのを待ち、
/// すべてが完了するまでローディングインジケータを表示します。データローディング画面、
/// 非同期初期化、複数ソースからのデータ取得に最適です。
///
/// 特徴:
/// - 複数のfutureを同時に待機
/// - カスタマイズ可能なローディングウィジェット
/// - デフォルトの中央配置CircularProgressIndicator
/// - 設定可能なインジケータカラー
/// - Future、FutureOr、null値を処理
/// - 自動的なnullフィルタリング
///
/// 例:
/// ```dart
/// LoadingBuilder(
///   futures: [
///     fetchUserData(),
///     fetchSettings(),
///     fetchNotifications(),
///   ],
///   builder: (context) {
///     return Column(
///       children: [
///         Text("すべてのデータが読み込まれました！"),
///         UserDataWidget(),
///         SettingsWidget(),
///       ],
///     );
///   },
/// )
/// ```
class LoadingBuilder extends StatelessWidget {
  /// A builder widget that displays loading indicators while waiting for multiple futures.
  ///
  /// This widget waits for multiple Future, FutureOr, or null values to complete
  /// and displays a loading indicator until all are finished. Perfect for data
  /// loading screens, async initialization, and multi-source data fetching.
  ///
  /// Features:
  /// - Wait for multiple futures simultaneously
  /// - Customizable loading widget
  /// - Default centered CircularProgressIndicator
  /// - Configurable indicator color
  /// - Handles Future, FutureOr, and null values
  /// - Automatic null filtering
  ///
  /// Example:
  /// ```dart
  /// LoadingBuilder(
  ///   futures: [
  ///     fetchUserData(),
  ///     fetchSettings(),
  ///     fetchNotifications(),
  ///   ],
  ///   builder: (context) {
  ///     return Column(
  ///       children: [
  ///         Text("All data loaded!"),
  ///         UserDataWidget(),
  ///         SettingsWidget(),
  ///       ],
  ///     );
  ///   },
  /// )
  /// ```
  ///
  /// 複数のfutureを待機している間にローディングインジケータを表示するビルダーウィジェット。
  ///
  /// このウィジェットは複数のFuture、FutureOr、またはnull値が完了するのを待ち、
  /// すべてが完了するまでローディングインジケータを表示します。データローディング画面、
  /// 非同期初期化、複数ソースからのデータ取得に最適です。
  ///
  /// 特徴:
  /// - 複数のfutureを同時に待機
  /// - カスタマイズ可能なローディングウィジェット
  /// - デフォルトの中央配置CircularProgressIndicator
  /// - 設定可能なインジケータカラー
  /// - Future、FutureOr、null値を処理
  /// - 自動的なnullフィルタリング
  ///
  /// 例:
  /// ```dart
  /// LoadingBuilder(
  ///   futures: [
  ///     fetchUserData(),
  ///     fetchSettings(),
  ///     fetchNotifications(),
  ///   ],
  ///   builder: (context) {
  ///     return Column(
  ///       children: [
  ///         Text("すべてのデータが読み込まれました！"),
  ///         UserDataWidget(),
  ///         SettingsWidget(),
  ///       ],
  ///     );
  ///   },
  /// )
  /// ```
  const LoadingBuilder({
    required this.futures,
    required this.builder,
    super.key,
    this.indicatorColor,
    this.loading,
  });

  /// Pass a list of [Future], [FutureOr], and [Null] to wait for.
  ///
  /// Only the part of the list that corresponds to [Future] is subject to wait.
  ///
  /// 待つ対象となる[Future]、[FutureOr]、[Null]のリストを渡します。
  ///
  /// この中で[Future]にあたる部分のみが待つ対象となります。
  final List<FutureOr<dynamic>?> futures;

  /// [builder] builder to build the widget to be drawn after [futures] is completed.
  ///
  /// [builder]で[futures]が完了した後に描画するウィジェットをビルドするビルダー。
  final Widget Function(BuildContext context) builder;

  /// Widget to display when waiting for [futures].
  ///
  /// If this is not specified, [CircularProgressIndicator] is displayed.
  ///
  /// [futures]を待っている場合に表示するウィジェット。
  ///
  /// これが指定されない場合[CircularProgressIndicator]が表示されます。
  final Widget? loading;

  /// You can change the color of the [CircularProgressIndicator] when it is displayed when [loading] is not specified.
  ///
  /// [loading]を指定しない場合に[CircularProgressIndicator]を表示するときにその色を変えることができます。
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final futureList = futures.whereType<Future>();
    final waitList = futureList.isNotEmpty ? Future.wait(futureList) : null;
    if (waitList == null) {
      return builder(context);
    }
    return FutureBuilder(
      future: waitList,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: loading ??
                CircularProgressIndicator(
                  backgroundColor:
                      indicatorColor ?? Theme.of(context).disabledColor,
                ),
          );
        } else {
          return builder(context);
        }
      },
    );
  }
}
