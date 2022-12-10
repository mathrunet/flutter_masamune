part of katana_cli;

class CodeCliCommand extends CliCommandGroup {
  const CodeCliCommand();

  @override
  String get groupDescription =>
      "Dart/Flutter code generation and editing. Dart/Flutterのコード生成や編集を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "create": CodeCreateCliCommand(),
        "format": CodeFormatCliCommand(),
        "generate": CodeGenerateCliCommand(),
        "watch": CodeWatchCliCommand(),
        "controller": CodeControllerCliCommand(),
        "group": CodeGroupCliCommand(),
        "page": CodePageCliCommand(),
        "collection": CodeCollectionCliCommand(),
        "document": CodeDocumentCliCommand(),
      };
}
