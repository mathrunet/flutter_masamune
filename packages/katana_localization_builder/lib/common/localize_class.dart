part of '/katana_localization_builder.dart';

/// Create translated classes.
///
/// Pass the value for the query in [model] and the path created from the annotation in [paths]. Pass a parsed [LocalizeValue] in [localized] and a list of locales in [locales].
///
/// 翻訳されたクラスを作成します。
///
/// [model]にクエリー用の値を[paths]にアノテーションから作成されたパスを渡します。[localized]に解析済みの[LocalizeValue]を渡し、[locales]にロケールのリストを渡します。
List<Spec> localizeClass(
  ClassValue model,
  List<PathValue> paths,
  List<LocalizeValue> localized,
  List<String> locales,
) {
  return [
    Field(
      (m) => m
        ..name = "_\$${model.name.toCamelCase()}Localizations"
        ..modifier = FieldModifier.final$
        ..assignment = Code("{${locales.map((e) {
          final locale = e.split("_");
          if (locale.length > 1) {
            return "Locale(\"${locale.first}\", \"${locale.last}\"): _\$${model.name}${e.toCamelCase().capitalize()}()";
          } else {
            return "Locale(\"${locale.first}\"): _\$${model.name}${e.toCamelCase().capitalize()}()";
          }
        }).join(",")}}"),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}$_kBaseName"
        ..abstract = true
        ..constructors.addAll([
          Constructor(
            (c) => c..constant = true,
          )
        ])
        ..methods.addAll(
          localized.map((e) => e._toBaseParam()),
        ),
    ),
    for (final locale in locales)
      Class(
        (c) => c
          ..name = "_\$${model.name}${locale.toCamelCase().capitalize()}"
          ..extend = Reference("_\$${model.name}$_kBaseName")
          ..constructors.addAll([
            Constructor(
              (c) => c..constant = true,
            )
          ])
          ..methods.addAll(
            localized.map((e) => e._toParam(locale)),
          ),
      ),
    ...localized.expand((e) => e.toClass(locales)),
  ];
}
