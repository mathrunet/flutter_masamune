library katana_cli.code;

import 'dart:io';

import 'package:katana_cli/katana_cli.dart';
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

class CodeCliCommand extends CliCommandGroup {
  const CodeCliCommand();

  @override
  String get groupDescription =>
      "Dart/Flutter code generation and editing. Dart/Flutterのコード生成や編集を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "tmp": CodeTmpCliCommand(),
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
      };
}
