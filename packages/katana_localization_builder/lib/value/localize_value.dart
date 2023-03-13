part of katana_localization_builder;

String _replaceText(String text) {
  text = text
      .replaceAll('"', r'\"')
      .replaceAll("\n", r"\n")
      .replaceAll(r"$", r"\$")
      .replaceAllMapped(_variableRegExp, (m) => "\${_${m.group(1)}}");
  return "\"$text\"";
}

/// Value to create a class for translation.
///
/// Data is stored in a tree structure.
///
/// Put the starting point [LocalizeWord] in [node].
///
/// 翻訳のクラスを作るための値。
///
/// ツリー構造でデータが保存されます。
///
/// [node]に起点となる[LocalizeWord]を入れます。
class LocalizeValue {
  LocalizeValue(this.id, this.node);

  /// Starting point [LocalizeWord].
  ///
  /// 起点となる[LocalizeWord]。
  final LocalizeWord node;

  /// ID of this node, automatically assigned in UUID format.
  ///
  /// このノードのID。UUID形式で自動で付与されます。
  final String id;

  /// List of children's [LocalizeValue].
  ///
  /// 子供の[LocalizeValue]のリスト。
  final List<LocalizeValue> children = [];

  /// `true` for the terminating case.
  ///
  /// 終端の場合`true`.
  bool get last {
    return node.localize.isNotEmpty;
  }

  /// Create translated classes according to [locales].
  ///
  /// [locales]に応じた翻訳済みクラスを作成します。
  List<Class> toClass(List<String> locales) {
    if (last) {
      return [];
    }
    final res = <Class>[];
    res.add(
      Class(
        (c) => c
          ..name = "_\$$id$_kBaseName"
          ..abstract = true
          ..constructors.addAll(
            [
              Constructor(
                (c) => c
                  ..constant = true
                  ..optionalParameters.addAll(
                    node.parameters.map(
                      (e) => Parameter(
                        (p) => p
                          ..name = e
                          ..named = true
                          ..type = const Reference("Object?"),
                      ),
                    ),
                  )
                  ..initializers.addAll([
                    ...node.parameters.map(
                      (e) => Code("_$e = $e"),
                    ),
                  ]),
              )
            ],
          )
          ..fields.addAll([
            ...node.parameters.map(
              (e) => Field(
                (p) => p
                  ..name = "_$e"
                  ..type = const Reference("Object?")
                  ..modifier = FieldModifier.final$,
              ),
            ),
          ])
          ..methods.addAll(
            children.map((child) => child._toBaseParam()),
          ),
      ),
    );
    for (final locale in locales) {
      res.add(
        Class(
          (c) => c
            ..name = "_\$$id${locale.toCamelCase().capitalize()}"
            ..extend = Reference("_\$$id$_kBaseName")
            ..constructors.addAll(
              [
                Constructor(
                  (c) => c
                    ..constant = true
                    ..optionalParameters.addAll(
                      node.parameters.map(
                        (e) => Parameter(
                          (p) => p
                            ..name = e
                            ..named = true
                            ..toSuper = true,
                        ),
                      ),
                    ),
                )
              ],
            )
            ..methods.addAll(
              children.map((child) => child._toParam(locale)),
            ),
        ),
      );
    }
    res.addAll(children.expand((e) => e.toClass(locales)));
    return res;
  }

  Method _toBaseParam() {
    if (last) {
      if (node.variable) {
        return Method(
          (m) => m
            ..name = r"$"
            ..returns = const Reference("String")
            ..requiredParameters.addAll([
              Parameter(
                (p) => p
                  ..name = "_${node.name}"
                  ..type = const Reference("Object?"),
              ),
            ])
            ..lambda = true
            ..body = const Code("throw UnimplementedError()"),
        );
      } else {
        return Method(
          (m) => m
            ..name = node.name
            ..returns = const Reference("String")
            ..type = MethodType.getter
            ..lambda = true
            ..body = const Code("throw UnimplementedError()"),
        );
      }
    } else {
      final className = "_\$$id$_kBaseName";
      if (node.variable) {
        return Method(
          (m) => m
            ..name = r"$"
            ..returns = Reference(className)
            ..requiredParameters.addAll([
              Parameter(
                (p) => p
                  ..name = "_${node.name}"
                  ..type = const Reference("Object?"),
              ),
            ])
            ..lambda = true
            ..body = const Code("throw UnimplementedError()"),
        );
      } else {
        return Method(
          (m) => m
            ..name = node.name
            ..returns = Reference(className)
            ..type = MethodType.getter
            ..lambda = true
            ..body = const Code("throw UnimplementedError()"),
        );
      }
    }
  }

  Method _toParam(String locale) {
    if (last) {
      if (node.variable) {
        return Method(
          (m) => m
            ..name = r"$"
            ..returns = const Reference("String")
            ..requiredParameters.addAll([
              Parameter(
                (p) => p
                  ..name = "_${node.name}"
                  ..type = const Reference("Object?"),
              ),
            ])
            ..annotations.addAll([
              const Reference("override"),
            ])
            ..lambda = true
            ..body = Code(_replaceText(node.localize[locale] ?? "")),
        );
      } else {
        return Method(
          (m) => m
            ..name = node.name
            ..returns = const Reference("String")
            ..annotations.addAll([
              const Reference("override"),
            ])
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code(_replaceText(node.localize[locale] ?? "")),
        );
      }
    } else {
      final className = "_\$$id${locale.toCamelCase().capitalize()}";
      if (node.variable) {
        return Method(
          (m) => m
            ..name = r"$"
            ..returns = Reference(className)
            ..requiredParameters.addAll([
              Parameter(
                (p) => p
                  ..name = "_${node.name}"
                  ..type = const Reference("Object?"),
              ),
            ])
            ..annotations.addAll([
              const Reference("override"),
            ])
            ..lambda = true
            ..body = Code(
              "$className(${node.parameters.map((e) => "$e: _$e").join(",\n")})",
            ),
        );
      } else {
        return Method(
          (m) => m
            ..name = node.name
            ..returns = Reference(className)
            ..annotations.addAll([
              const Reference("override"),
            ])
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code(
              "$className(${node.parameters.map((e) => "$e: _$e").join(",\n")})",
            ),
        );
      }
    }
  }

  static void add(
    List<LocalizeValue> current,
    List<LocalizeWord> words,
    int index,
  ) {
    if (words.length <= index) {
      return;
    }
    final word = words[index];
    final found = current.firstWhereOrNull((item) => item.node == word);
    if (found != null) {
      return add(found.children, words, index + 1);
    } else {
      final id =
          "${index}_${words.map((e) => e.name).join("")}_${word.name}".toSHA1();
      final container = LocalizeValue(id, word);
      current.add(container);
      return add(container.children, words, index + 1);
    }
  }

  @override
  String toString() {
    return "$node: {${children.map((e) => e.toString()).join(",")}}";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => node.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Original value to create the translation class.
///
/// Pass the key for the translation to [key].
///
/// 翻訳クラスを作成するための元の値。
///
/// 翻訳のキーを[key]に渡します。
class LocalizeSourceValue {
  /// Original value to create the translation class.
  ///
  /// Pass the key for the translation to [key].
  ///
  /// 翻訳クラスを作成するための元の値。
  ///
  /// 翻訳のキーを[key]に渡します。
  LocalizeSourceValue({
    required String key,
  }) : words = split(key, true);

  /// The given [key] is decomposed and converted into an array of [LocalizeWord].
  ///
  /// If [forVariableName] is set to `true`, spaces and symbols in each [LocalizeWord] will be removed and converted to CamelCase.
  ///
  /// 与えられた[key]を分解して[LocalizeWord]の配列に変換します。
  ///
  /// [forVariableName]を`true`にすると各[LocalizeWord]のスペースや記号が削除され、キャメルケースに変換されます。
  static List<LocalizeWord> split(String key, bool forVariableName) {
    final step1 = <LocalizeWord>[];
    final step2 = <LocalizeWord>[];
    final duplicate = <String, int>{};
    final splitted = _keyRegExp.allMatches(key).map((e) {
      if (forVariableName) {
        return LocalizeWord(
          e
                  .group(0)
                  ?.replaceAll(RegExp(r"[^a-zA-Z0-9_\{\}]"), "_")
                  .toCamelCase() ??
              "",
        );
      } else {
        return LocalizeWord(
          e.group(0) ?? "",
        );
      }
    });
    for (final word in splitted) {
      if (!word.variable) {
        step1.add(word);
        continue;
      }
      if (duplicate.containsKey(word.name)) {
        final n = duplicate.get(word.name, 1) + 1;
        duplicate[word.name] = n;
        step1.add(LocalizeWord("{${word.name}$n}"));
      } else {
        duplicate[word.name] = 1;
        step1.add(word);
      }
    }
    for (final word in step1) {
      if (!word.variable) {
        step2.add(word);
        continue;
      }
      if (duplicate.get(word.name, 1) > 1) {
        step2.add(LocalizeWord("{${word.name}1}"));
      } else {
        step2.add(word);
      }
    }
    return step2;
  }

  /// A list of [LocalizeWord] decomposed from the given key.
  ///
  /// 与えられたキーから分解された[LocalizeWord]のリスト。
  final List<LocalizeWord> words;

  /// <locale,after translation> value.
  ///
  /// <ロケール,翻訳後>の値。
  final Map<String, String> localize = {};

  /// Set translations and parameters to [LocalizeWord] and build.
  ///
  /// 翻訳やパラメーターを[LocalizeWord]にセットしてビルドします。
  void build() {
    if (words.isEmpty) {
      return;
    }
    final convert = <String, String>{};
    final copied = <LocalizeWord>[];
    int p = 0;
    for (final word in words) {
      if (word.name.isEmpty) {
        continue;
      }
      if (word.variable) {
        final name = word.name;
        p += 1;
        final newName = "p$p";
        convert[name] = newName;
        copied.add(LocalizeWord("{$newName}"));
      } else {
        copied.add(word);
      }
    }
    for (final key in localize.keys) {
      final val = localize[key]!;
      localize[key] = val.replaceAllMapped(_variableRegExp, (match) {
        final key = match.group(1);
        if (key == null || !convert.containsKey(key)) {
          return match.group(0)!;
        }
        return "{${convert[key]!}}";
      });
    }
    words.clear();
    words.addAll(copied);
    final params = <String>[];
    for (final word in words) {
      if (word.variable) {
        params.add(word.name);
      }
      word.setParameter(List.from(params));
    }
    final last = words.last;
    last.localize.clear();
    last.localize.addAll(Map.from(localize));
  }

  /// Add translation [val].
  ///
  /// 翻訳[val]を追加します。
  void addLocalize(Map<String, String> val) {
    localize.addAll(
      val.map(
        (key, value) => MapEntry(
          key,
          split(value, false).map((e) => e.toString()).join(),
        ),
      ),
    );
  }

  @override
  String toString() {
    return "Words: ${words.map((e) => e.toString()).join(", ")} Value: $localize";
  }
}

/// Word class for translation.
///
/// 翻訳を行うためのワードクラス。
class LocalizeWord {
  /// Word class for translation.
  ///
  /// Put the divided value in [raw].
  ///
  /// 翻訳を行うためのワードクラス。
  ///
  /// [raw]に分割された値を入れます。
  LocalizeWord(
    this.raw,
  )   : variable = raw.startsWith("{") && raw.endsWith("}"),
        name = _avoidConflict(raw.trimStringLeft("{").trimStringRight("}"));

  /// Original text.
  ///
  /// 元のテキスト。
  final String raw;

  /// For variables `true`.
  ///
  /// 変数の場合`true`.
  final bool variable;

  /// Parsed Name.
  ///
  /// パースされた名前。
  final String name;

  /// <locale,after translation> value.
  ///
  /// <ロケール,翻訳後>の値。
  final Map<String, String> localize = {};

  /// Parameters required to generate the class.
  ///
  /// クラスを生成する際に必要なパラメーター。
  final List<String> parameters = [];

  /// Add translation [val].
  ///
  /// 翻訳[val]を追加します。
  void addLocalize(Map<String, String> val) {
    localize.addAll(val);
  }

  /// Sets the parameter [param] needed to generate the class.
  ///
  /// クラスを生成する際に必要なパラメーター[param]をセットします。
  void setParameter(List<String> param) {
    parameters.addAll(param);
  }

  @override
  String toString() {
    if (variable) {
      return "{$name}";
    } else {
      return name;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => variable.hashCode ^ name.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  static String _avoidConflict(String value) {
    if (_ignoreWords.contains(value)) {
      return "${value}_";
    }
    return value;
  }
}
