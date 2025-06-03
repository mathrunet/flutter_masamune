part of "/katana_prefs_builder.dart";

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
        ..name = "_\$_${model.name}"
        ..types.addAll([const Reference("T")])
        ..constructors.addAll([
          Constructor(
            (c) => c
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "_key"
                    ..toThis = true,
                ),
                Parameter(
                  (p) => p
                    ..name = "_def"
                    ..toThis = true,
                ),
                Parameter(
                  (p) => p
                    ..name = "_ref"
                    ..toThis = true,
                )
              ]),
          )
        ])
        ..fields.addAll([
          Field(
            (f) => f
              ..name = "_key"
              ..type = const Reference("String")
              ..modifier = FieldModifier.final$,
          ),
          Field(
            (f) => f
              ..name = "_ref"
              ..type = Reference("_${model.name}")
              ..modifier = FieldModifier.final$,
          ),
          Field(
            (f) => f
              ..name = "_def"
              ..type = const Reference("T")
              ..modifier = FieldModifier.final$,
          ),
        ])
        ..methods.addAll([
          Method(
            (m) => m
              ..name = "get"
              ..returns = const Reference("T")
              ..body = const Code(
                "if(_ref._prefs == null) { return _def; } final o = _ref._prefs?.get(_key); if (o is List && T == List<String>) { return o.map((e) => e.toString()).toList() as T; } else if (o is! T) { return _def; } return o;",
              ),
          ),
          Method(
            (m) => m
              ..name = "set"
              ..returns = const Reference("Future<void>")
              ..modifier = MethodModifier.async
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "value"
                    ..type = const Reference("T"),
                ),
              ])
              ..body = const Code(
                "if(_ref._prefs == null) { return; }if (value is bool) { await _ref._prefs?.setBool(_key, value); } else if (value is int) { await _ref._prefs?.setInt(_key, value); } else if (value is double) { await _ref._prefs?.setDouble(_key, value); } else if (value is String) { await _ref._prefs?.setString(_key, value); } else if (value is List<String>) { await _ref._prefs?.setStringList(_key, value); } _ref.notifyListeners();",
              ),
          ),
          Method(
            (m) => m
              ..name = "delete"
              ..returns = const Reference("Future<bool>")
              ..modifier = MethodModifier.async
              ..body = const Code(
                "if (_ref._prefs == null) { return false; } return await _ref._prefs?.remove(_key) ?? false;",
              ),
          ),
          Method(
            (m) => m
              ..name = "toString"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = const Code(
                "return get().toString();",
              ),
          ),
        ]),
    ),
    Mixin(
      (c) => c
        ..name = "_\$${model.name}"
        ..implements.addAll([
          const Reference("PrefsBase"),
        ])
        ..methods.addAll([
          ...model.parameters.map((param) {
            return Method(
              (m) => m
                ..name = param.name
                ..type = MethodType.getter
                ..lambda = true
                ..returns = Reference(
                  "_\$_${model.name}<${param.type.aliasName}>",
                )
                ..body = const Code("throw UnimplementedError()"),
            );
          }),
          Method(
            (m) => m
              ..name = "addListener"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                )
              ])
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "removeListener"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (p) => p
                    ..name = "listener"
                    ..type = const Reference("VoidCallback"),
                )
              ])
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "notifyListeners"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "dispose"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("void")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "hasListeners"
              ..type = MethodType.getter
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("bool")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "toString"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("String")
              ..body = Code(
                "return \"\$runtimeType(${model.parameters.map((e) => "${e.name}: \$${e.name}").join(", ")})\";",
              ),
          ),
          Method(
            (m) => m
              ..name = "load"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("Future<void>")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "loading"
              ..annotations.addAll([const Reference("override")])
              ..type = MethodType.getter
              ..returns = const Reference("Future<void>?")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
          Method(
            (m) => m
              ..name = "clear"
              ..annotations.addAll([const Reference("override")])
              ..returns = const Reference("Future<bool>")
              ..lambda = true
              ..body = const Code("throw UnimplementedError()"),
          ),
        ]),
    ),
    if (model.existUnderbarConstructor) ...[
      Class(
        (c) => c
          ..name = "_${model.name}"
          ..extend = Reference(model.name)
          ..mixins.addAll([
            if (!model.existChangeNotifierMixin)
              const Reference("ChangeNotifier"),
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  ...model.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.name
                        ..type = Reference(param.type.aliasName)
                        ..named = true
                        ..required = param.required
                        ..defaultTo = param.defaultValueCode.isEmpty
                            ? null
                            : Code(param.defaultValueCode!),
                    );
                  }),
                ])
                ..initializers.addAll([
                  ...model.parameters.map((param) {
                    return Code("_${param.name} = ${param.name}");
                  }),
                  const Code("super._()"),
                ]),
            ),
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "load"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..annotations.addAll([const Reference("override")])
                ..body = const Code(
                  "if (_completer != null) { return _completer?.future; } if (_prefs != null) { return; } try { _completer = Completer(); _prefs = await SharedPreferences.getInstance(); notifyListeners(); _completer?.complete(); _completer = null; } catch (e) { _completer?.completeError(e); _completer = null; } finally { _completer?.complete(); }",
                ),
            ),
            Method(
              (m) => m
                ..name = "loading"
                ..type = MethodType.getter
                ..returns = const Reference("Future<void>?")
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..body = const Code("_completer?.future"),
            ),
            Method(
              (m) => m
                ..name = "clear"
                ..returns = const Reference("Future<bool>")
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..body = const Code("_prefs?.clear() ?? Future.value(false)"),
            ),
            ...model.parameters.map((param) {
              return Method(
                (m) => m
                  ..name = param.name
                  ..returns = Reference(
                    "_\$_${model.name}<${param.type.aliasName}>",
                  )
                  ..lambda = true
                  ..type = MethodType.getter
                  ..annotations.addAll([const Reference("override")])
                  ..body = Code(
                    "_\$_${model.name}(\"_#${param.name}\".toSHA1(), _${param.name}, this)",
                  ),
              );
            })
          ])
          ..fields.addAll([
            Field(
              (f) => f
                ..name = "_prefs"
                ..type = const Reference("SharedPreferences?"),
            ),
            Field(
              (f) => f
                ..name = "_completer"
                ..type = const Reference("Completer<void>?"),
            ),
            ...model.parameters.map((param) {
              return Field(
                (f) => f
                  ..name = "_${param.name}"
                  ..modifier = FieldModifier.final$
                  ..type = Reference(param.type.aliasName),
              );
            })
          ]),
      ),
    ] else ...[
      Class(
        (c) => c
          ..name = "_${model.name}"
          ..mixins.addAll([
            const Reference("ChangeNotifier"),
          ])
          ..implements.addAll([
            Reference(model.name),
          ])
          ..constructors.addAll([
            Constructor(
              (c) => c
                ..optionalParameters.addAll([
                  ...model.parameters.map((param) {
                    return Parameter(
                      (p) => p
                        ..name = param.name
                        ..type = Reference(param.type.aliasName)
                        ..named = true
                        ..required = param.required
                        ..defaultTo = param.defaultValueCode.isEmpty
                            ? null
                            : Code(param.defaultValueCode!),
                    );
                  }),
                ])
                ..initializers.addAll([
                  ...model.parameters.map((param) {
                    return Code("_${param.name} = ${param.name}");
                  }),
                ]),
            ),
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = "load"
                ..returns = const Reference("Future<void>")
                ..modifier = MethodModifier.async
                ..annotations.addAll([const Reference("override")])
                ..body = const Code(
                  "if (_completer != null) { return _completer?.future; } if (_prefs != null) { return; } try { _completer = Completer(); _prefs = await SharedPreferences.getInstance(); notifyListeners(); _completer?.complete(); _completer = null; } catch (e) { _completer?.completeError(e); _completer = null; } finally { _completer?.complete(); }",
                ),
            ),
            Method(
              (m) => m
                ..name = "loading"
                ..type = MethodType.getter
                ..returns = const Reference("Future<void>?")
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..body = const Code("_completer?.future"),
            ),
            Method(
              (m) => m
                ..name = "clear"
                ..returns = const Reference("Future<bool>")
                ..annotations.addAll([const Reference("override")])
                ..lambda = true
                ..body = const Code("_prefs?.clear() ?? Future.value(false)"),
            ),
            ...model.parameters.map((param) {
              return Method(
                (m) => m
                  ..name = param.name
                  ..returns = Reference(
                    "_\$_${model.name}<${param.type.aliasName}>",
                  )
                  ..lambda = true
                  ..type = MethodType.getter
                  ..annotations.addAll([const Reference("override")])
                  ..body = Code(
                    "_\$_${model.name}(\"_#${param.name}\".toSHA1(), _${param.name}, this)",
                  ),
              );
            })
          ])
          ..fields.addAll([
            Field(
              (f) => f
                ..name = "_prefs"
                ..type = const Reference("SharedPreferences?"),
            ),
            Field(
              (f) => f
                ..name = "_completer"
                ..type = const Reference("Completer<void>?"),
            ),
            ...model.parameters.map((param) {
              return Field(
                (f) => f
                  ..name = "_${param.name}"
                  ..modifier = FieldModifier.final$
                  ..type = Reference(param.type.aliasName),
              );
            })
          ]),
      ),
    ],
  ];
}
