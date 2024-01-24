part of '/katana_listenables_builder.dart';

extension _InterfaceTypeExtensions on InterfaceType {
  String get aliasName {
    final aliasElement = alias?.element;
    if (aliasElement != null) {
      return aliasElement.name;
    }
    return toString();
  }
}
