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

  /// Adds public Worker variables to one environment while preserving others.
  static String upsertVariables(
    String source, {
    required String flavor,
    required Map<String, String> values,
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
            r'''"([^"]+)"\s*:\s*"([^"]*)"''',
          ).allMatches(current)) {
            variables[entry.group(1)!] = entry.group(2)!;
          }
          variables.addAll(values);
          final encoded = variables.entries
              .map((entry) =>
                  "${jsonEncode(entry.key)}: ${jsonEncode(entry.value)}")
              .join(", ");
          return environment.replaceRange(open, close + 1, "{ $encoded }");
        }
        variables.addAll(values);
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
