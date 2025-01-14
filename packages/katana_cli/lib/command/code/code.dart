library katana_cli.code;

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:archive/archive_io.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'server/server.dart';
import 'tmp/tmp.dart';

part 'collection.dart';
part 'controller.dart';
part 'document.dart';
part 'format.dart';
part 'generate.dart';
part 'group.dart';
part 'page.dart';
part 'watch.dart';
part 'value.dart';
part 'redirect_query.dart';
part 'boot.dart';
part 'prefs.dart';
part 'widget.dart';
part 'stateless.dart';
part 'stateful.dart';
part 'query.dart';
part 'cache.dart';
part 'zip.dart';
part 'enum.dart';
part 'model_adapter.dart';
part 'exception.dart';
part 'modal.dart';

class CodeCliCommand extends CliCommandGroup {
  const CodeCliCommand();

  @override
  String get groupDescription =>
      "Dart/Flutter code generation and editing. Dart/Flutterのコード生成や編集を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "tmp": CodeTmpCliCommand(),
        "server": CodeServerCliCommand(),
        "boot": CodeBootCliCommand(),
        "format": CodeFormatCliCommand(),
        "generate": CodeGenerateCliCommand(),
        "watch": CodeWatchCliCommand(),
        "controller": CodeControllerCliCommand(),
        "group": CodeGroupCliCommand(),
        "page": CodePageCliCommand(),
        "collection": CodeCollectionCliCommand(),
        "document": CodeDocumentCliCommand(),
        "value": CodeValueCliCommand(),
        "redirect": CodeRedirectQueryCliCommand(),
        "prefs": CodePrefsCliCommand(),
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
      };
}
