part of "/katana_theme_builder.dart";

/// Nodes for assets.
///
/// アセット用のノード。
class AssetNode {
  AssetNode._withNode({
    required this.name,
    required this.path,
    required this.value,
  }) : children = const [];
  AssetNode._withChildren({
    required this.name,
    required this.path,
    required this.children,
  }) : value = null;

  /// Asset Data.
  ///
  /// アセットデータ。
  final AssetValue? value;

  /// Path of the asset node.
  ///
  /// アセットノードのパス。
  final String path;

  /// Asset Name.
  ///
  /// アセットの名前。
  final String name;

  /// List of children of the asset.
  ///
  /// アセットの子供の一覧。
  final List<AssetNode> children;

  /// Parses the list of [AssetNode] from [values] and [path].
  ///
  /// [values]と[path]から[AssetNode]の一覧のパースします。
  static List<AssetNode> parse(
    Map<String, dynamic> values, [
    String path = "",
  ]) {
    final res = <AssetNode>[];
    for (final tmp in values.entries) {
      final value = tmp.value;
      if (value is Map<String, dynamic>) {
        res.add(
          AssetNode._withChildren(
            name: tmp.key,
            path: "$path/${tmp.key}",
            children: parse(value, "$path/${tmp.key}"),
          ),
        );
      } else if (value is AssetValue) {
        res.add(
          AssetNode._withNode(
            name: tmp.key,
            path: "$path/${tmp.key}",
            value: value,
          ),
        );
      }
    }
    return res;
  }

  /// Build methods to create `ImageProvider`.
  ///
  /// `ImageProvider`を作成するためのメソッドをビルドします。
  Method? buildProvider() {
    if (value == null) {
      return null;
    }
    switch (value!.type) {
      case AssetValueType.image:
        return Method(
          (f) => f
            ..name = "provider"
            ..returns = const Reference("ImageProvider")
            ..lambda = true
            ..type = MethodType.getter
            ..body = const Code("AssetImage(path)"),
        );
      case AssetValueType.svg:
        return Method(
          (f) => f
            ..name = "provider"
            ..returns = const Reference("ImageProvider")
            ..lambda = true
            ..type = MethodType.getter
            ..body = const Code(
              "MemoizedAssetSvgImageProvider(path)",
            ),
        );
      case AssetValueType.text:
        return Method(
          (f) => f
            ..name = "provider"
            ..returns = const Reference("TextProvider")
            ..lambda = true
            ..type = MethodType.getter
            ..body = const Code("AssetTextProvider(path)"),
        );
      case AssetValueType.video:
        return Method(
          (f) => f
            ..name = "provider"
            ..returns = const Reference("VideoProvider")
            ..lambda = true
            ..type = MethodType.getter
            ..body = const Code("AssetVideoProvider(path)"),
        );
      default:
        return null;
    }
  }

  /// Create an extension method by passing [config].
  ///
  /// [config]を渡して拡張メソッドを作成します。
  Method toExtensionSpec(AssetConfig config) {
    return Method(
      (m) => m
        ..name = name
        ..type = MethodType.getter
        ..lambda = true
        ..returns = Reference("_\$${path.toSHA1()}")
        ..body = Code("const _\$${path.toSHA1()}()"),
    );
  }

  /// Create a class by passing [config].
  ///
  /// [config]を渡してクラスを作成します。
  List<Spec> toClassSpec(AssetConfig config) {
    if (value != null) {
      if (!config.checkEnabled(value!.type)) {
        return [];
      }
      final provider = buildProvider();
      return [
        Class(
          (c) => c
            ..name = "_\$${path.toSHA1()}"
            ..constructors.addAll([
              Constructor(
                (c) => c..constant = true,
              )
            ])
            ..fields.addAll([
              Field(
                (f) => f
                  ..name = "path"
                  ..modifier = FieldModifier.final$
                  ..assignment = Code("\"${value!.path}\""),
              ),
            ])
            ..methods.addAll([
              if (provider != null) provider,
            ]),
        ),
      ];
    } else {
      return [
        Class(
          (c) => c
            ..name = "_\$${path.toSHA1()}"
            ..constructors.addAll([
              Constructor(
                (c) => c..constant = true,
              )
            ])
            ..fields.addAll([
              ...children.mapAndRemoveEmpty((node) {
                if (node.value != null &&
                    !config.checkEnabled(node.value!.type)) {
                  return null;
                }
                return Field(
                  (f) => f
                    ..name = node.name
                    ..modifier = FieldModifier.final$
                    ..assignment = Code("const _\$${node.path.toSHA1()}()"),
                );
              }),
            ]),
        ),
        ...children.expand((node) {
          if (node.value != null && !config.checkEnabled(node.value!.type)) {
            return [];
          }
          return node.toClassSpec(config);
        })
      ];
    }
  }
}
