part of katana_localization_builder;

/// Create a base class.
///
/// Pass the value for the query in [model] and the path created from the annotation in [path]. Pass a list of locales to [locales].
///
/// ベースを作成します。
///
/// [model]にクエリー用の値を[path]にアノテーションから作成されたパスを渡します。[locales]にロケールのリストを渡します。
List<Spec> baseClass(
  ClassValue model,
  PathValue? path,
  List<String> locales,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..abstract = true
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "delegates"
              ..returns = const Reference("List<LocalizationsDelegate>")
              ..body = Code("return const [_\$${model.name}Delegate()];"),
          ),
          Method(
            (m) => m
              ..name = "supportedLocales"
              ..returns = const Reference("List<Locale>")
              ..body = Code(
                "return _\$${model.name.toCamelCase()}Localizations.keys.toList();",
              ),
          ),
          Method(
            (m) => m
              ..name = "of"
              ..static = true
              ..returns = Reference("_\$${model.name}$_kBaseName")
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "context"
                    ..type = const Reference("BuildContext"),
                )
              ])
              ..body = Code(
                "return Localizations.of<_\$${model.name}$_kBaseName>(context, _\$${model.name}$_kBaseName) ?? _\$${model.name.toCamelCase()}Localizations.values.first;",
              ),
          )
        ]),
    ),
    Extension(
      (e) => e
        ..name = "${model.name}BuildContextExtensions"
        ..on = const Reference("BuildContext")
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "l"
              ..type = MethodType.getter
              ..returns = Reference("_\$${model.name}$_kBaseName")
              ..lambda = true
              ..body = Code("_\$${model.name}.of(this)"),
          )
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}Delegate"
        ..extend =
            Reference("LocalizationsDelegate<_\$${model.name}$_kBaseName>")
        ..constructors.addAll([
          Constructor((c) => c..constant = true),
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "isSupported"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("bool")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "locale"
                    ..type = const Reference("Locale"),
                )
              ])
              ..body = Code(
                "_\$${model.name.toCamelCase()}Localizations.containsKey(locale)",
              ),
          ),
          Method(
            (m) => m
              ..name = "load"
              ..annotations.addAll([const Reference("override")])
              ..returns = Reference("Future<_\$${model.name}$_kBaseName>")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "locale"
                    ..type = const Reference("Locale"),
                )
              ])
              ..body = Code(
                "SynchronousFuture(_\$${model.name.toCamelCase()}Localizations[locale] ?? _\$${model.name.toCamelCase()}Localizations.values.first)",
              ),
          ),
          Method(
            (m) => m
              ..name = "shouldReload"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("bool")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "old"
                    ..type = Reference(
                      "LocalizationsDelegate<_\$${model.name}$_kBaseName>",
                    ),
                )
              ])
              ..body = const Code("false"),
          ),
        ]),
    ),
  ];
}
