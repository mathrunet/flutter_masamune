// Dart imports:
import "dart:convert";

/// Maintains Katana-managed Wrangler dev/prod environments in JSONC.
class WranglerEnvironmentSynchronizer {
  const WranglerEnvironmentSynchronizer._();

  /// Beginning of the managed JSONC section.
  static const beginMarker = "// KATANA ENVIRONMENTS BEGIN";

  /// End of the managed JSONC section.
  static const endMarker = "// KATANA ENVIRONMENTS END";

  /// Adds or updates one environment without discarding the other one.
  static String synchronize(
    String source, {
    required String flavor,
    required String workerName,
    String? rootWorkerName,
  }) {
    if (flavor != "dev" && flavor != "prod") {
      throw ArgumentError.value(
          flavor, "flavor", "Flavor must be dev or prod.");
    }
    if (workerName.trim().isEmpty) {
      throw ArgumentError.value(workerName, "workerName", "Must not be empty.");
    }
    var synchronizedSource = source;
    if (rootWorkerName != null) {
      if (rootWorkerName.trim().isEmpty) {
        throw ArgumentError.value(
          rootWorkerName,
          "rootWorkerName",
          "Must not be empty.",
        );
      }
      final rootSectionEnd = synchronizedSource.indexOf(beginMarker);
      final rootSection = synchronizedSource.substring(
        0,
        rootSectionEnd < 0 ? synchronizedSource.length : rootSectionEnd,
      );
      final rootName =
          RegExp(r'''"name"\s*:\s*"[^"]*"''').firstMatch(rootSection);
      if (rootName == null) {
        throw const FormatException(
          "Wrangler root configuration does not contain a Worker name.",
        );
      }
      synchronizedSource = synchronizedSource.replaceRange(
        rootName.start,
        rootName.end,
        '"name": ${jsonEncode(rootWorkerName.trim())}',
      );
    }
    final objects = <String, String>{};
    final managedPattern = RegExp(
      "${RegExp.escape(beginMarker)}([\\s\\S]*?)${RegExp.escape(endMarker)}",
    );
    final existing = managedPattern.firstMatch(synchronizedSource)?.group(1);
    if (existing != null) {
      for (final name in ["dev", "prod"]) {
        final object = _environmentObject(existing, name);
        if (object != null) {
          objects[name] = object;
        }
      }
    }
    final encodedName = jsonEncode(workerName.trim());
    final selected = objects[flavor];
    objects[flavor] = selected == null
        ? "{\n"
            '      "name": $encodedName,\n'
            '      "vars": { "FLAVOR": "$flavor" }\n'
            "    }"
        : selected
            .replaceFirst(
              RegExp(r'''"name"\s*:\s*"[^"]*"'''),
              '"name": $encodedName',
            )
            .replaceFirst(
              RegExp(r'''"FLAVOR"\s*:\s*"(?:dev|prod)"'''),
              '"FLAVOR": "$flavor"',
            );
    final entries = ["dev", "prod"]
        .where(objects.containsKey)
        .map(
          (name) => '    "$name": ${objects[name]}',
        )
        .join(",\n");
    final managed = "$beginMarker\n"
        '  "env": {\n'
        "$entries\n"
        "  },\n"
        "  $endMarker";
    if (existing != null) {
      return synchronizedSource.replaceFirst(managedPattern, managed);
    }
    final closingBrace = synchronizedSource.lastIndexOf("}");
    if (closingBrace < 0) {
      throw const FormatException("Wrangler JSONC root object was not found.");
    }
    final before = synchronizedSource.substring(0, closingBrace).trimRight();
    final comma = before.endsWith(",") ? "" : ",";
    return "$before$comma\n  $managed\n${synchronizedSource.substring(closingBrace)}";
  }

  /// Restores every Katana-managed environment from [from] into [source].
  ///
  /// This is used after regenerating the common Wrangler configuration so
  /// applying one flavor cannot discard the other flavor's bindings.
  static String restoreEnvironments(
    String source, {
    required String from,
  }) {
    final managed = RegExp(
      "${RegExp.escape(beginMarker)}([\\s\\S]*?)${RegExp.escape(endMarker)}",
    ).firstMatch(from);
    if (managed == null) {
      return source;
    }
    final managedSource = managed.group(1)!;
    var restored = source;
    for (final flavor in ["dev", "prod"]) {
      final environment = _environmentObject(managedSource, flavor);
      if (environment == null) {
        continue;
      }
      final workerName = RegExp(r'''"name"\s*:\s*"([^"]+)"''')
          .firstMatch(environment)
          ?.group(1);
      if (workerName == null || workerName.trim().isEmpty) {
        throw FormatException(
          "Wrangler environment does not contain a Worker name: $flavor",
        );
      }
      restored = synchronize(
        restored,
        flavor: flavor,
        workerName: workerName,
      );
      restored = transformEnvironment(
        restored,
        flavor: flavor,
        transform: (_) => environment,
      );
    }
    return restored;
  }

  /// Applies a JSONC transformation only to the selected environment object.
  static String transformEnvironment(
    String source, {
    required String flavor,
    required String Function(String environmentObject) transform,
  }) {
    final managed = RegExp(
      "${RegExp.escape(beginMarker)}([\\s\\S]*?)${RegExp.escape(endMarker)}",
    ).firstMatch(source);
    if (managed == null) {
      throw const FormatException(
          "Katana Wrangler environments were not found.");
    }
    final managedSource = managed.group(0)!;
    final entry = RegExp('"${RegExp.escape(flavor)}"\\s*:\\s*\\{')
        .firstMatch(managedSource);
    if (entry == null) {
      throw FormatException("Wrangler environment was not found: $flavor");
    }
    final open = managedSource.indexOf("{", entry.start);
    final close = _findClosingBrace(managedSource, open);
    if (close < 0) {
      throw FormatException("Wrangler environment is malformed: $flavor");
    }
    final originalObject = managedSource.substring(open, close + 1);
    final updatedObject = transform(originalObject);
    final updatedManaged = managedSource.replaceRange(
      open,
      close + 1,
      updatedObject,
    );
    return source.replaceRange(managed.start, managed.end, updatedManaged);
  }

  /// Ensures the selected environment exists using the configured root name.
  static String ensureEnvironment(
    String source, {
    required String flavor,
    String? workerName,
  }) {
    final resolvedName = (workerName?.trim().isNotEmpty ?? false)
        ? workerName!.trim()
        : RegExp(r'''"name"\s*:\s*"([^"]+)"''').firstMatch(source)?.group(1) ??
            "";
    return synchronize(
      source,
      flavor: flavor,
      workerName: resolvedName,
    );
  }

  /// Adds or removes Worker variables in one environment while preserving others.
  static String upsertVariables(
    String source, {
    required String flavor,
    required Map<String, String> values,
    Set<String> removeKeys = const {},
  }) {
    return transformEnvironment(
      source,
      flavor: flavor,
      transform: (environment) {
        final variables = <String, String>{"FLAVOR": flavor};
        final varsMatch =
            RegExp(r'''"vars"\s*:\s*\{''').firstMatch(environment);
        if (varsMatch != null) {
          final open = environment.indexOf("{", varsMatch.start);
          final close = _findClosingBrace(environment, open);
          if (close < 0) {
            throw const FormatException("Wrangler vars object is malformed.");
          }
          final current = environment.substring(open + 1, close);
          for (final entry in RegExp(
            r'''"((?:\\.|[^"\\])*)"\s*:\s*"((?:\\.|[^"\\])*)"''',
          ).allMatches(current)) {
            final key = jsonDecode('"${entry.group(1)!}"') as String;
            final value = jsonDecode('"${entry.group(2)!}"') as String;
            variables[key] = value;
          }
          variables.addAll(values);
          for (final key in removeKeys) {
            variables.remove(key);
          }
          final encoded = variables.entries
              .map((entry) =>
                  "${jsonEncode(entry.key)}: ${jsonEncode(entry.value)}")
              .join(", ");
          return environment.replaceRange(open, close + 1, "{ $encoded }");
        }
        variables.addAll(values);
        for (final key in removeKeys) {
          variables.remove(key);
        }
        final close = _findClosingBrace(environment, 0);
        final encoded = variables.entries
            .map((entry) =>
                "${jsonEncode(entry.key)}: ${jsonEncode(entry.value)}")
            .join(", ");
        return environment.replaceRange(
          close,
          close,
          ',\n      "vars": { $encoded }\n    ',
        );
      },
    );
  }

  /// Adds or updates `"placement": { "region": [region] }` only in the
  /// selected environment object, preserving the other environment.
  ///
  /// 選択した環境オブジェクトだけに`"placement": { "region": [region] }`を
  /// 追加・更新し、他の環境は保持します。
  static String upsertPlacementRegion(
    String source, {
    required String flavor,
    required String region,
  }) {
    final trimmed = region.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(region, "region", "Must not be empty.");
    }
    final placement = '{ "region": ${jsonEncode(trimmed)} }';
    return transformEnvironment(
      source,
      flavor: flavor,
      transform: (environment) {
        final match =
            RegExp(r'''"placement"\s*:\s*\{''').firstMatch(environment);
        if (match != null) {
          final open = environment.indexOf("{", match.start);
          final close = _findClosingBrace(environment, open);
          if (close < 0) {
            throw const FormatException(
                "Wrangler placement object is malformed.");
          }
          return environment.replaceRange(open, close + 1, placement);
        }
        final close = _findClosingBrace(environment, 0);
        if (close < 0) {
          throw FormatException("Wrangler environment is malformed: $flavor");
        }
        final before = environment.substring(0, close).trimRight();
        final comma = before.endsWith(",") || before.endsWith("{") ? "" : ",";
        return "$before$comma\n"
            '      "placement": $placement\n'
            "    ${environment.substring(close)}";
      },
    );
  }

  /// Replaces the custom-domain routes in `"routes": [...]` of the selected
  /// environment object with [customDomains], preserving zone routes
  /// (e.g. `{ "pattern": "https://example.com/s/*", "zone_name": "example.com" }`)
  /// and the other environment. The array is added when it does not exist.
  ///
  /// 選択した環境オブジェクトの`"routes": [...]`のカスタムドメインルートを
  /// [customDomains]で置き換えます。ゾーンルートと他の環境は保持します。
  /// 配列が存在しない場合は追加します。
  static String upsertRoutes(
    String source, {
    required String flavor,
    required List<String> customDomains,
  }) {
    final hosts = customDomains
        .map((domain) => domain.trim())
        .where((domain) => domain.isNotEmpty)
        .toList();
    if (hosts.isEmpty) {
      throw ArgumentError.value(
        customDomains,
        "customDomains",
        "Must not be empty.",
      );
    }
    final customRoutes = hosts
        .map((host) =>
            '{ "pattern": ${jsonEncode(host)}, "custom_domain": true }')
        .toList();
    return transformEnvironment(
      source,
      flavor: flavor,
      transform: (environment) {
        final match = RegExp(r'''"routes"\s*:\s*\[''').firstMatch(environment);
        if (match != null) {
          final open = environment.indexOf("[", match.start);
          final close = _findClosingBracket(environment, open);
          if (close < 0) {
            throw const FormatException("Wrangler routes array is malformed.");
          }
          final zoneRoutes =
              _routeEntries(environment.substring(open, close + 1))
                  .where((entry) => !_isCustomDomainRoute(entry))
                  .toList();
          return environment.replaceRange(
            open,
            close + 1,
            _routesArray([...customRoutes, ...zoneRoutes]),
          );
        }
        final routes = _routesArray(customRoutes);
        final close = _findClosingBrace(environment, 0);
        if (close < 0) {
          throw FormatException("Wrangler environment is malformed: $flavor");
        }
        final before = environment.substring(0, close).trimRight();
        final comma = before.endsWith(",") || before.endsWith("{") ? "" : ",";
        return "$before$comma\n"
            '      "routes": $routes\n'
            "    ${environment.substring(close)}";
      },
    );
  }

  /// Removes the custom-domain routes from the selected environment object,
  /// preserving zone routes and the other environment. `"routes"` itself is
  /// removed when no zone route remains. Nothing changes when the property
  /// does not exist.
  ///
  /// 選択した環境オブジェクトからカスタムドメインルートを削除し、ゾーンルートと
  /// 他の環境は保持します。ゾーンルートが残らない場合は`"routes"`自体を削除します。
  /// プロパティが存在しない場合は何も変更しません。
  static String removeRoutes(
    String source, {
    required String flavor,
  }) {
    return transformEnvironment(
      source,
      flavor: flavor,
      transform: (environment) {
        final match = RegExp(r'''"routes"\s*:\s*\[''').firstMatch(environment);
        if (match == null) {
          return environment;
        }
        final open = environment.indexOf("[", match.start);
        final close = _findClosingBracket(environment, open);
        if (close < 0) {
          throw const FormatException("Wrangler routes array is malformed.");
        }
        final zoneRoutes = _routeEntries(environment.substring(open, close + 1))
            .where((entry) => !_isCustomDomainRoute(entry))
            .toList();
        if (zoneRoutes.isNotEmpty) {
          return environment.replaceRange(
            open,
            close + 1,
            _routesArray(zoneRoutes),
          );
        }
        var start = match.start;
        var end = close + 1;
        // Remove the trailing comma, or the leading comma for the last entry.
        final trailing =
            RegExp(r"^\s*,").firstMatch(environment.substring(end));
        if (trailing != null) {
          end += trailing.end;
        } else {
          final leading =
              RegExp(r",\s*$").firstMatch(environment.substring(0, start));
          if (leading != null) {
            start = leading.start;
          }
        }
        // Drop whitespace left on the removed line.
        final lineStart = environment.lastIndexOf("\n", start - 1) + 1;
        if (environment.substring(lineStart, start).trim().isEmpty) {
          start = lineStart;
        }
        final lineEnd = environment.indexOf("\n", end);
        if (lineEnd >= 0 &&
            environment.substring(end, lineEnd).trim().isEmpty) {
          end = lineEnd + 1;
        }
        return environment.replaceRange(start, end, "");
      },
    );
  }

  /// Adds zone routes (`{ "pattern": ..., "zone_name": ... }`) for [patterns]
  /// to the selected environment object if they do not exist yet, preserving
  /// the existing routes and the other environment.
  ///
  /// 選択した環境オブジェクトに[patterns]のゾーンルート
  /// （`{ "pattern": ..., "zone_name": ... }`）が無い場合に追加します。
  /// 既存のルートと他の環境は保持します。
  static String addZoneRoutes(
    String source, {
    required String flavor,
    required Map<String, String> patterns,
  }) {
    if (patterns.isEmpty) {
      return source;
    }
    return transformEnvironment(
      source,
      flavor: flavor,
      transform: (environment) {
        final match = RegExp(r'''"routes"\s*:\s*\[''').firstMatch(environment);
        if (match == null) {
          final close = _findClosingBrace(environment, 0);
          if (close < 0) {
            throw FormatException("Wrangler environment is malformed: $flavor");
          }
          final before = environment.substring(0, close).trimRight();
          final comma = before.endsWith(",") || before.endsWith("{") ? "" : ",";
          return "$before$comma\n"
              '      "routes": ${_routesArray(patterns.entries.map(_zoneRoute).toList())}\n'
              "    ${environment.substring(close)}";
        }
        final open = environment.indexOf("[", match.start);
        final close = _findClosingBracket(environment, open);
        if (close < 0) {
          throw const FormatException("Wrangler routes array is malformed.");
        }
        final entries = _routeEntries(environment.substring(open, close + 1));
        final existing = entries.map(_routePattern).whereType<String>().toSet();
        final missing = patterns.entries
            .where((entry) => !existing.contains(entry.key))
            .map(_zoneRoute)
            .toList();
        if (missing.isEmpty) {
          return environment;
        }
        return environment.replaceRange(
          open,
          close + 1,
          _routesArray([...entries, ...missing]),
        );
      },
    );
  }

  static String _zoneRoute(MapEntry<String, String> entry) {
    return '{ "pattern": ${jsonEncode(entry.key)}, "zone_name": ${jsonEncode(entry.value)} }';
  }

  static String _routesArray(List<String> entries) {
    if (entries.isEmpty) {
      return "[]";
    }
    return "[\n${entries.map((entry) => "        $entry").join(",\n")}\n      ]";
  }

  static bool _isCustomDomainRoute(String entry) {
    return RegExp(r'''"custom_domain"\s*:\s*true''').hasMatch(entry);
  }

  static String? _routePattern(String entry) {
    if (!entry.trimLeft().startsWith("{")) {
      try {
        return jsonDecode(entry) as String;
      } catch (_) {
        return null;
      }
    }
    return RegExp(r'''"pattern"\s*:\s*"([^"]*)"''').firstMatch(entry)?.group(1);
  }

  /// Splits the top-level entries of a JSONC routes array (comments are dropped).
  static List<String> _routeEntries(String array) {
    final entries = <String>[];
    var depth = 0;
    var escaped = false;
    String? quote;
    var start = -1;
    for (var index = 1; index < array.length - 1; index++) {
      final character = array[index];
      if (quote != null) {
        if (escaped) {
          escaped = false;
        } else if (character == r"\") {
          escaped = true;
        } else if (character == quote) {
          quote = null;
          if (depth == 0) {
            entries.add(array.substring(start, index + 1));
            start = -1;
          }
        }
        continue;
      }
      if (depth == 0 &&
          character == "/" &&
          index + 1 < array.length &&
          array[index + 1] == "/") {
        final lineEnd = array.indexOf("\n", index);
        index = lineEnd < 0 ? array.length : lineEnd;
        continue;
      }
      if (character == '"') {
        quote = character;
        if (depth == 0) {
          start = index;
        }
      } else if (character == "{") {
        if (depth == 0) {
          start = index;
        }
        depth++;
      } else if (character == "}" && --depth == 0) {
        entries.add(array.substring(start, index + 1));
        start = -1;
      }
    }
    return entries;
  }

  static int _findClosingBracket(String source, int open) {
    var depth = 0;
    var escaped = false;
    String? quote;
    for (var index = open; index < source.length; index++) {
      final character = source[index];
      if (escaped) {
        escaped = false;
        continue;
      }
      if (character == r"\") {
        escaped = true;
        continue;
      }
      if (quote != null) {
        if (character == quote) {
          quote = null;
        }
        continue;
      }
      if (character == '"' || character == "'") {
        quote = character;
      } else if (character == "[") {
        depth++;
      } else if (character == "]" && --depth == 0) {
        return index;
      }
    }
    return -1;
  }

  static int _findClosingBrace(String source, int open) {
    var depth = 0;
    var escaped = false;
    String? quote;
    for (var index = open; index < source.length; index++) {
      final character = source[index];
      if (escaped) {
        escaped = false;
        continue;
      }
      if (character == r"\") {
        escaped = true;
        continue;
      }
      if (quote != null) {
        if (character == quote) {
          quote = null;
        }
        continue;
      }
      if (character == '"' || character == "'") {
        quote = character;
      } else if (character == "{") {
        depth++;
      } else if (character == "}" && --depth == 0) {
        return index;
      }
    }
    return -1;
  }

  static String? _environmentObject(String source, String flavor) {
    final entry =
        RegExp('"${RegExp.escape(flavor)}"\\s*:\\s*\\{').firstMatch(source);
    if (entry == null) {
      return null;
    }
    final open = source.indexOf("{", entry.start);
    final close = _findClosingBrace(source, open);
    return close < 0 ? null : source.substring(open, close + 1);
  }
}
