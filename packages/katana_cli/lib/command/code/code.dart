library;

// Dart imports:
import "dart:io";

// Package imports:
import "package:archive/archive_io.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/snippet/snippet.dart";
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

const _tidbDataServiceBuilderKey =
    "masamune_model_tidb_builder:masamune_model_tidb_builder";

List<String> _tidbDataServiceBuilderArguments(ExecContext context) {
  final configuredPrefixes = context.yaml
      .getAsMap("cloudflare")
      .getAsMap("tidb")
      .getAsMap("data_service")
      .getAsList("prefixes");
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
        "cloudflare.tidb.data_service.prefixes",
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
        "exception": CodeExceptionCliCommand(),
        "modal": CodeModalCliCommand(),
        "log": CodeLogCliCommand(),
        "function": CodeFunctionCliCommand(),
        "localize": CodeLocalizeCliCommand(),
        "test": CodeTestCliCommand(),
        "debug": CodeDebugCliCommand(),
      };
}
