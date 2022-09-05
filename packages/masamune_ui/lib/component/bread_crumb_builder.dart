part of masamune_ui;

class BreadCrumbBuilder<T> extends StatelessWidget {
  const BreadCrumbBuilder({
    required this.source,
    required this.builder,
    this.divider,
    this.overflow = const WrapOverflow(),
  }) : _length = source.length;

  final List<T> source;
  final BreadCrumbItem Function(T item, int index) builder;
  final Widget? divider;
  final BreadCrumbOverflow overflow;
  final int _length;

  @override
  Widget build(BuildContext context) {
    return BreadCrumb.builder(
      itemCount: _length,
      builder: _builder,
      divider: divider,
      overflow: overflow,
    );
  }

  BreadCrumbItem _builder(int index) {
    final item = source[index];
    return builder.call(item, index);
  }
}
