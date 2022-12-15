part of masamune_builder;

final _regExpModelRef = RegExp(r"ModelRef<([^>]+)>");
final _regExpRef = RegExp(r"(.+)Ref");

List<Spec> modelClass(
  ClassValue model,
  PathValue path,
) {
  final searchable = model.parameters.where((e) => e.isSearchable).toList();
  final referencable = model.parameters.where((e) => e.isReference).toList();
  return [
    Code("typedef ${model.name}Ref = ModelRef<${model.name}>?;"),
    Class(
      (c) => c
        ..name = "\$${model.name}Document"
        ..extend = Reference("DocumentBase<${model.name}>")
        ..mixins.addAll([
          Reference("ModelRefMixin<${model.name}>"),
          if (searchable.isNotEmpty)
            Reference("SearchableDocumentMixin<${model.name}>"),
          if (referencable.isNotEmpty)
            Reference("ModelRefLoaderMixin<${model.name}>")
        ])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "modelQuery"
                    ..toSuper = true,
                )
              ]),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "fromMap"
              ..lambda = true
              ..returns = Reference(model.name)
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "map"
                    ..type = const Reference("DynamicMap"),
                )
              ])
              ..body = Code("${model.name}.fromJson(map)"),
          ),
          Method(
            (m) => m
              ..name = "toMap"
              ..lambda = true
              ..returns = const Reference("DynamicMap")
              ..annotations.addAll([const Reference("override")])
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = Reference(model.name),
                )
              ])
              ..body = const Code("value.toJson()"),
          ),
          if (searchable.isNotEmpty)
            Method(
              (m) => m
                ..name = "buildSearchText"
                ..lambda = true
                ..returns = const Reference("String")
                ..annotations.addAll([const Reference("override")])
                ..requiredParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = "value"
                      ..type = Reference(model.name),
                  )
                ])
                ..body = Code(
                  searchable.map((e) {
                    if (e.type.toString().endsWith("?")) {
                      return "(value.${e.name}?.toString() ?? \"\")";
                    } else {
                      return "value.${e.name}.toString()";
                    }
                  }).join(" + "),
                ),
            ),
          if (referencable.isNotEmpty)
            Method(
              (m) => m
                ..name = "builder"
                ..lambda = true
                ..type = MethodType.getter
                ..returns = Reference("List<ModelRefBuilder<${model.name}>>")
                ..annotations.addAll([const Reference("override")])
                ..body = Code("[${referencable.map((e) {
                  if (e.type.toString().endsWith("Ref")) {
                    final match = _regExpRef.firstMatch(e.type.toString());
                    if (match == null) {
                      throw Exception(
                        "@refParam can only be given to ModelRef<T> types. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final doc = "\$${match.group(1)}Document";
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc as ${match.group(1)}Ref ),)";
                  } else {
                    if (!e.type.toString().endsWith("?")) {
                      throw Exception(
                        "ModelRef<T> must be nullable. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final match = _regExpModelRef.firstMatch(e.type.toString());
                    if (match == null) {
                      throw Exception(
                        "@refParam can only be given to ModelRef<T> types. \r\n\r\n${e.type} ${e.name}",
                      );
                    }
                    final doc = "\$${match.group(1)}Document";
                    return "ModelRefBuilder( modelRef: (value) => value.${e.name}, document: (modelQuery) => $doc(modelQuery), value: (value, doc) => value.copyWith( ${e.name}: doc as ${match.group(1)}Ref ),)";
                  }
                }).join(",")}]"),
            ),
        ]),
    ),
    Class(
      (c) => c
        ..name = "_\$${model.name}Collection"
        ..extend = Reference("CollectionBase<\$${model.name}Document>")
        ..mixins.addAll([
          if (searchable.isNotEmpty)
            Reference("SearchableCollectionMixin<\$${model.name}Document>")
        ])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "modelQuery"
                    ..toSuper = true,
                )
              ]),
          )
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "create"
              ..annotations.addAll([const Reference("override")])
              ..lambda = true
              ..returns = Reference("\$${model.name}Document")
              ..optionalParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "id"
                    ..type = const Reference("String?"),
                )
              ])
              ..body = Code("\$${model.name}Document(modelQuery.create(id))"),
          ),
        ]),
    ),
  ];
}
