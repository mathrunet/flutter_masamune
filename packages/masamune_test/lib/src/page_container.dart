part of "/masamune_test.dart";

class _PageContainer extends PageScopedWidget {
  const _PageContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, PageRef ref) {
    return child;
  }
}
