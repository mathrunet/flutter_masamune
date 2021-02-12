part of masamune.list;

class MultiMediaView<T> extends StatelessWidget {
  MultiMediaView({
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.fileBuilder,
    this.typeKey = "type",
    this.fileKey = "file",
    this.urlKey = "url",
    this.networkBuilder,
    String? json,
    List<Map<String, dynamic>> items = const [],
  }) : items = json.isNotEmpty
            ? jsonDecodeAsList(json!).mapAndRemoveEmpty<Map<String, dynamic>>(
                (item) => item as Map<String, dynamic>,
              )
            : items;

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Map<String, dynamic>> items;
  final String typeKey;
  final String fileKey;
  final String urlKey;
  final Widget Function(File file, AssetType type)? fileBuilder;
  final Widget Function(String url, AssetType type)? networkBuilder;

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
      if (!item.containsKey(typeKey)) {
        return null;
      }
      if (item.containsKey(fileKey) && fileBuilder != null) {
        return _addPadding(
          fileBuilder?.call(
                File(item[fileKey]),
                _convertType(item[typeKey]),
              ) ??
              const Empty(),
        );
      } else if (item.containsKey(urlKey) && networkBuilder != null) {
        return _addPadding(
          networkBuilder?.call(
                item[urlKey],
                _convertType(item[typeKey]),
              ) ??
              const Empty(),
        );
      }
      return null;
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
