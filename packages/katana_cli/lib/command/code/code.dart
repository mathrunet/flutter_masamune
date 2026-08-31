library;

// Dart imports:
import "dart:io";

// Package imports:
import "package:archive/archive_io.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/snippet/snippet.dart";
import "package:katana_cli/src/debuggable.dart";
import "server/server.dart";
import "test/test.dart";
import "view/view.dart";

part "collection.dart";
part "controller.dart";
part "document.dart";
part "format.dart";
part "generate.dart";
part "page.dart";
part "watch.dart";
part "value.dart";
part "function.dart";
part "redirect_query.dart";
part "boot.dart";
part "widget.dart";
part "stateless.dart";
part "stateful.dart";
part "query.dart";
part "cache.dart";
part "zip.dart";
part "enum.dart";
part "model_adapter.dart";
part "exception.dart";
part "modal.dart";
part "log.dart";
part "snippets.dart";
part "localize.dart";
part "debug.dart";
part "debuggable.dart";

const _tidbDataServiceBuilderKey =
    "masamune_model_tidb_builder:masamune_model_tidb_builder";

List<String> _tidbDataServiceBuilderArguments(ExecContext context) {
  final tidb = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
  final configuredPrefixes = tidb.getAsList("prefixes").isNotEmpty
      ? tidb.getAsList("prefixes")
      : tidb.getAsMap("data_service").getAsList("prefixes");
  final prefixes = <String>{};
  for (final value in configuredPrefixes) {
    var prefix = value.toString().trim();
    prefix = prefix.replaceFirst(RegExp(r"_+$"), "");
    if (prefix.isEmpty) {
      continue;
    }
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(prefix)) {
      throw ArgumentError.value(
        value,
        "cloudflare.tidb.prefixes",
        "TiDB Data Service prefixes must be valid identifiers.",
      );
    }
    prefixes.add(prefix);
  }
  if (prefixes.isEmpty) {
    return const [];
  }
  return [
    "--define",
    "$_tidbDataServiceBuilderKey=prefixes=${prefixes.join(",")}",
  ];
}

String _shellArguments(List<String> arguments) {
  return arguments.map((argument) => "'$argument'").join(" ");
}

/// Dart/Flutter code generation and editing.
///
/// Dart/Flutterのコード生成や編集を行います。
class CodeCliCommand extends CliCommandGroup {
  /// Dart/Flutter code generation and editing.
  ///
  /// Dart/Flutterのコード生成や編集を行います。
  const CodeCliCommand();

  @override
  String get groupDescription =>
      "Dart/Flutter code generation and editing. Dart/Flutterのコード生成や編集を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "view": CodeViewCliCommand(),
        "server": CodeServerCliCommand(),
        "boot": CodeBootCliCommand(),
        "snippets": CodeSnippetsCliCommand(),
        "format": CodeFormatCliCommand(),
        "generate": CodeGenerateCliCommand(),
        "watch": CodeWatchCliCommand(),
        "controller": CodeControllerCliCommand(),
        "page": CodePageCliCommand(),
        "collection": CodeCollectionCliCommand(),
        "document": CodeDocumentCliCommand(),
        "value": CodeValueCliCommand(),
        "redirect": CodeRedirectQueryCliCommand(),
        "widget": CodeWidgetCliCommand(),
        "stateless": CodeStatelessCliCommand(),
        "stateful": CodeStatefulCliCommand(),
        "query": CodeQueryCliCommand(),
        "cache": CodeCacheCliCommand(),
        "zip": CodeZipCliCommand(),
        "enum": CodeEnumCliCommand(),
        "model_adapter": CodeModelAdapterCliCommand(),
        "plugin": CodePluginCliCommand(),
        "exception": CodeExceptionCliCommand(),
        "modal": CodeModalCliCommand(),
        "log": CodeLogCliCommand(),
        "function": CodeFunctionCliCommand(),
        "localize": CodeLocalizeCliCommand(),
        "test": CodeTestCliCommand(),
        "debug": CodeDebugCliCommand(),
        "debuggable": CodeDebuggableCliCommand(),
      };
}

/// Create a plugin module.
///
/// プラグインモジュールを作成します。
class CodePluginCliCommand extends CliCodeCommand {
  /// Create a plugin module.
  ///
  /// プラグインモジュールを作成します。
  const CodePluginCliCommand();

  @override
  String get name => "plugin";

  @override
  String get prefix => "plugin";

  @override
  String get directory => "lib/plugins";

  @override
  String get description =>
      "Create a plugin module in `$directory/(filepath).dart`. プラグインモジュールを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code plugin [plugin_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code plugin [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code plugin [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a plugin module in `$directory/$path.dart`.");
    await generateDartCode("$directory/$path", path);
  }

  @override
  String import(String path, String baseName, String className) {
    return "// ignore_for_file: public_member_api_docs";
  }

  @override
  String header(String path, String baseName, String className) => "";

  @override
  String body(String path, String baseName, String className) {
    return """
/// Plugin contract for $className.
class ${className}Plugin {
  /// Creates the $className plugin contract.
  const ${className}Plugin();

  /// Stable plugin identifier.
  static const pluginId = "${className.toSnakeCase()}";
}
""";
  }
}
