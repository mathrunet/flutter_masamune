part of katana_module;

/// Page config for external modules.
///
/// Used to generate links.
@immutable
class ExternalPageConfig<TWidget extends Widget> extends PageConfig<TWidget> {
  const ExternalPageConfig(String path) : super(path, null, true);
}

/// Config class for describing the page configuration of a module.
@immutable
class PageConfig<TWidget extends Widget> {
  const PageConfig(
    this.path, [
    this.widget,
    this.external = false,
  ]);
  static final RegExp _keyRegex = RegExp(r"\{([^\}]+)\}");

  /// Page path.
  final String path;

  /// Page widget.
  final TWidget? widget;

  /// True for external pages.
  final bool external;

  /// Convert PageConfig data for RouteSettings.
  Map<String, RouteConfig> toRouteSetting() {
    if (widget == null) {
      return {};
    }
    return {
      path: RouteConfig((_) => widget!),
    };
  }

  /// Convert paths with mapping according to [replace].
  ///
  /// ```
  /// final path = "/detail/{detail_id}";
  /// final page = PageConfig(path);
  /// final replacedPath = page.apply({"detail_id": "12345678"});
  /// ```
  ///
  /// In this case, `replacedPath` will contain `/detail/12345678`.
  ///
  /// Additional strings can be given at the beginning of the path by specifying [prefix].
  String apply(
    PageModule module, [
    Map<String, String> replace = const {},
  ]) {
    return PageModule._mergeRoutePath(
      external ? "" : module._normalizedRoutePath,
      path,
    ).replaceAllMapped(_keyRegex, (match) {
      final tag = match.group(1);
      if (tag.isNotEmpty && replace.containsKey(tag)) {
        return replace.get(tag!, "");
      } else {
        return "";
      }
    });
  }

  /// Convert paths with mapping according to [replace].
  ///
  /// ```
  /// final path = "/detail/{detail_id}";
  /// final page = PageConfig(path);
  /// final replacedPath = page.apply({"detail_id": "12345678"});
  /// ```
  ///
  /// In this case, `replacedPath` will contain `/detail/12345678`.
  ///
  /// Additional strings can be given at the beginning of the path by specifying [prefix].
  PageConfig applyWith(
    PageModule module, [
    Map<String, String> replace = const {},
  ]) {
    return PageConfig(apply(module, replace), widget);
  }

  /// Retrieve all query keys (keys enclosed in {}).
  List<String> get queryKeys {
    return _keyRegex.allMatches(path).mapAndRemoveEmpty((e) => e.group(1));
  }
}
