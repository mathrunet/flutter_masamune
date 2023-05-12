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
                    ..defaultTo = const Code("const []"),
                )
              ])
              ..body = Code(
                "return [const _\$${model.name}MaterialDelegate(), const _\$${model.name}CupertinoDelegate(), const _\$${model.name}WidgetsDelegate(), ...delegates,];",
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
        ..name = "_\$${model.name}MaterialDelegate"
        ..extend =
            const Reference("LocalizationsDelegate<MaterialLocalizations>")
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
              ..returns = const Reference("Future<MaterialLocalizations>")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "locale"
                    ..type = const Reference("Locale"),
                )
              ])
              ..body = const Code(
                "SynchronousFuture(DefaultMaterialLocalizations())",
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
                    ..type = const Reference(
                      "LocalizationsDelegate<MaterialLocalizations>",
                    ),
                )
              ])
              ..body = const Code("false"),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}CupertinoDelegate"
        ..extend =
            const Reference("LocalizationsDelegate<CupertinoLocalizations>")
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
              ..returns = const Reference("Future<CupertinoLocalizations>")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "locale"
                    ..type = const Reference("Locale"),
                )
              ])
              ..body = const Code(
                "SynchronousFuture(DefaultCupertinoLocalizations())",
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
                    ..type = const Reference(
                      "LocalizationsDelegate<CupertinoLocalizations>",
                    ),
                )
              ])
              ..body = const Code("false"),
          ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}WidgetsDelegate"
        ..extend =
            const Reference("LocalizationsDelegate<WidgetsLocalizations>")
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
              ..returns = const Reference("Future<WidgetsLocalizations>")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "locale"
                    ..type = const Reference("Locale"),
                )
              ])
              ..body = const Code(
                "SynchronousFuture(DefaultWidgetsLocalizations())",
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
                    ..type = const Reference(
                      "LocalizationsDelegate<WidgetsLocalizations>",
                    ),
                )
              ])
              ..body = const Code("false"),
          ),
        ]),
    ),
  ];
}
