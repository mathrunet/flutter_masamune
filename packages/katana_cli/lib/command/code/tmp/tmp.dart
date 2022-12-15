library katana_cli.code.tmp;

import 'package:katana_cli/katana_cli.dart';

part 'form.dart';
part 'basic.dart';

class CodeTmpCliCommand extends CliCommandGroup {
  const CodeTmpCliCommand();

  @override
  String get groupDescription =>
      "Create a Dart/Flutter code template. Dart/Flutterのコードテンプレートを作成します。";

  @override
  Map<String, CliCommand> get commands => const {
        "form": CodeTmpFormCliCommand(),
        "basic": CodeTmpBasicCliCommand(),
      };
}
