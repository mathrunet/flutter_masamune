part of masamune.list;

class MultiMediaView<T> extends StatelessWidget {
  MultiMediaView({
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.builder,
    this.typeKey = Const.type,
    this.pathKey = "path",
    String? json,
    List<DynamicMap> items = const [],
  }) : items = json.isNotEmpty
            ? jsonDecodeAsList(json!).mapAndRemoveEmpty<DynamicMap>(
                (item) => item as DynamicMap,
              )
            : items;

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final List<DynamicMap> items;
  final String typeKey;
  final String pathKey;
  final Widget Function(String url, AssetType type, bool isLocal)? builder;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _buildWidget(context),
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _buildWidget(context),
      );
    }
  }

  List<Widget> _buildWidget(BuildContext context) {
    return items.mapAndRemoveEmpty((item) {
      if (!item.containsKey(typeKey) ||
          !item.containsKey(pathKey) ||
          builder == null) {
        return null;
      }
      final path = item[pathKey];
      return _addPadding(
        builder?.call(
              path,
              _convertType(item[typeKey]),
              !path.startsWith("http"),
            ) ??
            const Empty(),
      );
    });
  }

  Widget _addPadding(Widget widget) {
    if (direction == Axis.horizontal) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: widget,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: widget,
      );
    }
  }

  AssetType _convertType(String type) {
    for (final val in AssetType.values) {
      if (val.toString() == "AssetType.$type") {
        return val;
      }
    }
    return AssetType.none;
  }
}
