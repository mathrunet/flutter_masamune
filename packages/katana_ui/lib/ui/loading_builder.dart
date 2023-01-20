part of katana_ui;

/// Pass multiple Future/FutureOr/Null data and display [loading] or [CircularProgressIndicator] until all completions are completed.
///
/// Pass the target [Future] in [futures].
///
/// In [builder], you can specify the widget to be drawn after [futures] is completed.
///
/// If [indicatorColor] is specified, the color of [CircularProgressIndicator] can be changed when it is displayed when [loading] is not specified.
///
/// 複数のFuture/FutureOr/Nullデータを渡してすべての完了を完了するまで[loading]や[CircularProgressIndicator]を表示します。
///
/// [futures]で対象となる[Future]を渡します。
///
/// [builder]で[futures]が完了した後に描画するウィジェットを指定できます。
///
/// [indicatorColor]を指定すると[loading]を指定しない場合に[CircularProgressIndicator]を表示するときにその色を変えることができます。
class LoadingBuilder extends StatelessWidget {
  /// Pass multiple Future/FutureOr/Null data and display [loading] or [CircularProgressIndicator] until all completions are completed.
  ///
  /// Pass the target [Future] in [futures].
  ///
  /// In [builder], you can specify the widget to be drawn after [futures] is completed.
  ///
  /// If [indicatorColor] is specified, the color of [CircularProgressIndicator] can be changed when it is displayed when [loading] is not specified.
  ///
  /// 複数のFuture/FutureOr/Nullデータを渡してすべての完了を完了するまで[loading]や[CircularProgressIndicator]を表示します。
  ///
  /// [futures]で対象となる[Future]を渡します。
  ///
  /// [builder]で[futures]が完了した後に描画するウィジェットを指定できます。
  ///
  /// [indicatorColor]を指定すると[loading]を指定しない場合に[CircularProgressIndicator]を表示するときにその色を変えることができます。
  const LoadingBuilder({
    super.key,
    required this.futures,
    required this.builder,
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
    final _futures = futures.whereType<Future>();
    final _wait = _futures.isNotEmpty ? Future.wait(_futures) : null;
    if (_wait == null) {
      return builder(context);
    }
    return FutureBuilder(
      future: _wait,
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
