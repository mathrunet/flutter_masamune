part of masamune_module;

class GroupConfig {
  const GroupConfig({
    required this.id,
    this.label = "",
    this.icon,
    this.value,
    this.query,
  });
  final String id;
  final String label;
  final IconData? icon;
  final ModelQuery? query;
  final Object? value;

  @override
  String toString() {
    return label;
  }
}
