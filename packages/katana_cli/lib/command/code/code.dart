library;

// Dart imports:
import "dart:io";

// Package imports:
import "package:archive/archive_io.dart";
import "package:katana_cli/action/git/claude_code.dart";
import "package:katana_cli/action/git/cursor.dart";

// Project imports:
import "package:katana_cli/ai/designs/designs.dart";
import "package:katana_cli/ai/docs/docs.dart";
import "package:katana_cli/ai/impls/impls.dart";
import "package:katana_cli/ai/tests/tests.dart";
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/snippet/snippet.dart";
import "server/server.dart";
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
part "docs.dart";
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
        "docs": CodeDocsCliCommand(),
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
      };
}
