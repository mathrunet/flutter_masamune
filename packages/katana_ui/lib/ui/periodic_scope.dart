part of "/katana_ui.dart";

/// A widget that automatically rebuilds at regular intervals.
///
/// This widget provides periodic UI updates perfect for timers, countdowns,
/// clocks, and any content that needs regular refreshing. It provides the
/// current DateTime to the builder on each rebuild.
///
/// Features:
/// - Automatic periodic rebuilds at specified intervals
/// - Current DateTime provided to builder
/// - Proper timer cleanup to prevent memory leaks
/// - Simple builder pattern
/// - Customizable update interval
/// - Automatic disposal when widget is removed
///
/// Example:
/// ```dart
/// PeriodicScope(
///   duration: const Duration(seconds: 1),
///   builder: (context, now) {
///     return Text(
///       '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
///       style: Theme.of(context).textTheme.headlineMedium,
///     );
///   },
/// )
/// ```
///
/// 一定間隔で自動的に再構築されるウィジェット。
///
/// タイマー、カウントダウン、時計、定期的な更新が必要なコンテンツに最適な、
/// 定期的なUI更新を提供します。各再構築時に現在のDateTimeをビルダーに提供します。
///
/// 特徴:
/// - 指定された間隔での自動的な定期再構築
/// - ビルダーに現在のDateTimeを提供
/// - メモリリークを防ぐための適切なタイマークリーンアップ
/// - シンプルなビルダーパターン
/// - カスタマイズ可能な更新間隔
/// - ウィジェット削除時の自動破棄
///
/// 例:
/// ```dart
/// PeriodicScope(
///   duration: const Duration(seconds: 1),
///   builder: (context, now) {
///     return Text(
///       '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
///       style: Theme.of(context).textTheme.headlineMedium,
///     );
///   },
/// )
/// ```
class PeriodicScope extends StatefulWidget {
  /// A widget that automatically rebuilds at regular intervals.
  ///
  /// This widget provides periodic UI updates perfect for timers, countdowns,
  /// clocks, and any content that needs regular refreshing. It provides the
  /// current DateTime to the builder on each rebuild.
  ///
  /// Features:
  /// - Automatic periodic rebuilds at specified intervals
  /// - Current DateTime provided to builder
  /// - Proper timer cleanup to prevent memory leaks
  /// - Simple builder pattern
  /// - Customizable update interval
  /// - Automatic disposal when widget is removed
  ///
  /// Example:
  /// ```dart
  /// PeriodicScope(
  ///   duration: const Duration(seconds: 1),
  ///   builder: (context, now) {
  ///     return Text(
  ///       '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
  ///       style: Theme.of(context).textTheme.headlineMedium,
  ///     );
  ///   },
  /// )
  /// ```
  ///
  /// 一定間隔で自動的に再構築されるウィジェット。
  ///
  /// タイマー、カウントダウン、時計、定期的な更新が必要なコンテンツに最適な、
  /// 定期的なUI更新を提供します。各再構築時に現在のDateTimeをビルダーに提供します。
  ///
  /// 特徴:
  /// - 指定された間隔での自動的な定期再構築
  /// - ビルダーに現在のDateTimeを提供
  /// - メモリリークを防ぐための適切なタイマークリーンアップ
  /// - シンプルなビルダーパターン
  /// - カスタマイズ可能な更新間隔
  /// - ウィジェット削除時の自動破棄
  ///
  /// 例:
  /// ```dart
  /// PeriodicScope(
  ///   duration: const Duration(seconds: 1),
  ///   builder: (context, now) {
  ///     return Text(
  ///       '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
  ///       style: Theme.of(context).textTheme.headlineMedium,
  ///     );
  ///   },
  /// )
  /// ```
  const PeriodicScope({
    required this.duration,
    required this.builder,
    super.key,
  });

  /// Interval between drawings.
  ///
  /// 描画を行う間隔。
  final Duration duration;

  /// Builder for drawing.
  ///
  /// 描画を行うためのビルダー。
  final Widget Function(BuildContext context, DateTime now) builder;

  @override
  State<StatefulWidget> createState() => _PeriodicScopeState();
}

class _PeriodicScopeState extends State<PeriodicScope> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final now = Clock.now();
    return widget.builder.call(context, now);
  }
}
