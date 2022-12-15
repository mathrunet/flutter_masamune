library katana_cli.pub;

import 'dart:convert';
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';

part 'get.dart';
part 'version.dart';
part 'upgrade.dart';
part 'publish.dart';

class PubCliCommand extends CliCommandGroup {
  const PubCliCommand();

  @override
  String get groupDescription =>
      "Version and deployment management for pub. pub上のバージョンやデプロイの管理を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "get": PubGetCliCommand(),
        "version": PubVersionCliCommand(),
        "upgrade": PubUpgradeCliCommand(),
        "publish": PubPublishCliCommand(),
      };
}
