part of katana_listenables_builder;

/// Create a base class.
///
/// Pass the value for the query to [model].
///
/// ベースを作成します。
///
/// [model]にクエリー用の値を渡します。
List<Spec> baseClass(
  ClassValue model,
) {
  return [
    Class(
      (c) => c
        ..name = "_\$${model.name}"
        ..abstract = true
        ..extend = const Reference("AppLocalizeBase")
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "delegates"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("List<LocalizationsDelegate>")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "delegates"
                    ..type = const Reference("List<LocalizationsDelegate>")
                    ..defaultTo =
                        const Code("GlobalMaterialLocalizations.delegates"),
                )
              ])
              ..body = Code(
                "return [const _\$${model.name}Delegate(), ...delegates,];",
              ),
          ),
          Method(
            (m) => m
              ..name = "supportedLocales"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("List<Locale>")
              ..body = Code(
                "return _\$${model.name.toCamelCase()}Localizations.keys.toList();",
              ),
          ),
          Method(
            (m) => m
              ..name = "call"
              ..returns = Reference("_\$${model.name}$_kBaseName")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "context"
                    ..type = const Reference("BuildContext?"),
                )
              ])
              ..body = Code(
                "final l = context != null ? Localizations.localeOf(context) : locale;if (_\$${model.name.toCamelCase()}Localizations.containsKey(l)) {return _\$${model.name.toCamelCase()}Localizations[l]!;} else {return _\$${model.name.toCamelCase()}Localizations.values.first;}",
              ),
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
