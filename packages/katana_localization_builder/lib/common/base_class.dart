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
              ..body = const Code(
                "final supportDelegates = <LocalizationsDelegate>[]; for (final d in delegates) { if (supportDelegates.any((element) => element.type == d.type)) { continue; } supportDelegates.add(d); } for (final d in AppLocalizationSettings.delegates) { if (supportDelegates.any((element) => element.type == d.type)) { continue; } supportDelegates.add(d); } return supportDelegates;",
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
  ];
}
