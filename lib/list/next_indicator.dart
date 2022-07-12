part of masamune.list;

@immutable
class NextIndicator extends StatelessWidget {
  const NextIndicator({
    this.enabled = true,
    required this.child,
    required this.onLoadMore,
  });

  final bool enabled;
  final Widget child;

  /// Return true is refresh success.
  final Future<bool> Function() onLoadMore;
  @override
  Widget build(BuildContext context) {
    return LoadMore(
      child: child,
      onLoadMore: onLoadMore,
      isFinish: !enabled,
    );
  }
}
