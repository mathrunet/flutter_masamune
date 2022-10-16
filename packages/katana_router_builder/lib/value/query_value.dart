part of katana_router_builder;

class QueryValue {
  const QueryValue({
    required this.library,
    required this.path,
    required this.query,
    required this.element,
  });

  final String path;
  final String library;
  final String query;
  final ClassElement element;
}
