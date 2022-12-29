library katana_cli.app;

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:katana_cli/katana_cli.dart';
import 'package:xml/xml.dart';

part 'info.dart';
part 'csr.dart';
part 'keystore.dart';

class AppCliCommand extends CliCommandGroup {
  const AppCliCommand();

  @override
  String get groupDescription =>
      "Configure settings for the application. アプリケーション用の設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "info": AppInfoCliCommand(),
        "csr": AppCsrCliCommand(),
      };
}
