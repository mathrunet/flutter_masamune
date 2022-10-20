part of katana_router_builder;

/// Automatic generation of routers.
///
/// ルーターの自動生成を行います。
class RouterGenerator extends GeneratorForAnnotation<AppRoute> {
  /// Automatic generation of routers.
  ///
  /// ルーターの自動生成を行います。
  RouterGenerator();

  static const _typeChecker = TypeChecker.fromRuntime(PagePath);
  static const _pageRouteQueryChecker = TypeChecker.fromRuntime(PageRouteQuery);

  static final _regExp = RegExp(r"^/(?<packageName>[^/]+)/lib/(?<path>.+)$");

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        "Generator cannot target libraries that have not been migrated to "
        "null-safety.",
        element: element,
      );
    }

    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        "`@AppRoute()`はトップレベルのフィールドにのみ付与してください。\n"
        "```\n"
        "\n"
        "```\n",
        element: element,
      );
    }

    int i = 0;
    final import = <String, String>{};
    final export = <String, List<String>>{};
    final queries = <QueryValue>[];
    final assets = buildStep.findAssets(Glob("**.dart"));
    await for (final asset in assets) {
      if (!await buildStep.resolver.isLibrary(asset)) {
        continue;
      }
      final lib = LibraryReader(
        await buildStep.resolver.libraryFor(
          asset,
          allowSyntaxErrors: false,
        ),
      );
      for (final annotatedElement in lib.annotatedWith(_typeChecker)) {
        final element = annotatedElement.element;
        if (element is! ClassElement) {
          continue;
        }
        final annotation = annotatedElement.annotation;
        final path = annotation.read("path").stringValue.trimString("/");
        for (final field in element.fields) {
          if (_pageRouteQueryChecker.hasAnnotationOfExact(field)) {
            if (!field.isStatic || !field.isConst) {
              throw InvalidGenerationSourceError(
                "The `@pageRouteQuery()` can only be given to static and const fields.",
                element: field,
              );
            }
            final library = _getImportLibrary(lib.element);
            if (library.isEmpty) {
              continue;
            }
            if (!export.containsKey(library!)) {
              export[library] = [element.name];
            } else {
              export[library]!.add(element.name);
            }
            if (!import.containsKey(library)) {
              i++;
              import[library] = "_\$$i";
              queries.add(
                QueryValue(
                  library: library,
                  path: path,
                  query: "${import[library]}.${element.name}.${field.name}",
                  element: element,
                ),
              );
            } else {
              queries.add(
                QueryValue(
                  library: library,
                  path: path,
                  query: "${import[library]}.${element.name}.${field.name}",
                  element: element,
                ),
              );
            }
          }
        }
      }
    }

    final sorted = queries.sortTo((a, b) {
      return b.path.compareTo(a.path);
    });

    final generated = Library(
      (l) => l
        ..directives = ListBuilder([
          Directive.import(
            "package:katana_router/katana_router.dart",
          ),
          ...import
              .toList((key, value) => Directive.import(key, as: value))
              .toList()
              .sortTo((a, b) => a.url.compareTo(b.url)),
          ...export
              .toList((key, value) => Directive.export(key, show: value))
              .toList()
              .sortTo((a, b) => a.url.compareTo(b.url)),
        ])
        ..body.addAll(
          [
            ...routerClass(sorted),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }

  String? _getImportLibrary(LibraryElement element) {
    final path = element.librarySource.toString();
    final match = _regExp.firstMatch(path);
    if (match == null) {
      return null;
    }
    return "package:${match.namedGroup("packageName")}/${match.namedGroup("path")}";
  }
}
