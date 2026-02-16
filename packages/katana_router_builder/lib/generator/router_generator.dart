part of "/katana_router_builder.dart";

/// Automatic generation of routers.
///
/// ルーターの自動生成を行います。
class RouterGenerator extends GeneratorForAnnotation<AppRoute> {
  /// Automatic generation of routers.
  ///
  /// ルーターの自動生成を行います。
  RouterGenerator();

  static const _typeChecker = TypeChecker.typeNamed(PagePath);
  static const _pageRouteQueryChecker = TypeChecker.typeNamed(PageRouteQuery);

  static final _regExp = RegExp(r"^/(?<packageName>[^/]+)/lib/(?<path>.+)$");

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        "`@AppRoute()` should only be given to top-level fields.\n"
        "```\n"
        "\n"
        "```\n",
        element: element,
      );
    }

    var i = 0;
    final import = <String, String>{};
    final export = <String, List<String>>{};
    final queries = <QueryValue>[];
    final names = <String>[];
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
              export[library] = [element.name ?? ""];
            } else {
              export[library]!.add(element.name ?? "");
            }
            if (!import.containsKey(library)) {
              final meta = element.metadata.annotations.first;
              final obj = meta.computeConstantValue()!;
              final name = obj.getField("name")?.toStringValue();
              String value;

              if (name != null && !names.contains(name)) {
                value = name;
                names.add(name);
              } else {
                value = (++i).toString();
              }

              import[library] = "_\$$value";
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
        ..directives.addAll([
          Directive.import(
            "package:flutter/material.dart",
          ),
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
    final code = generated.accept(emitter).toString();
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(
      code.isEmpty ? "// no code." : code,
    );
  }

  String? _getImportLibrary(LibraryElement element) {
    final path = element.library.toString();
    final match = _regExp.firstMatch(path);
    if (match == null) {
      return null;
    }
    return "package:${match.namedGroup("packageName")}/${match.namedGroup("path")}";
  }
}
