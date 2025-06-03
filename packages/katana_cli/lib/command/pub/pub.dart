library katana_cli.pub;

// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'get.dart';
part 'add.dart';
part 'version.dart';
part 'upgrade.dart';
part 'publish.dart';

/// Version and deployment management for pub.
///
/// pub上のバージョンやデプロイの管理を行います。
class PubCliCommand extends CliCommandGroup {
  /// Version and deployment management for pub.
  ///
  /// pub上のバージョンやデプロイの管理を行います。
  const PubCliCommand();

  @override
  String get groupDescription =>
      "Version and deployment management for pub. pub上のバージョンやデプロイの管理を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "get": PubGetCliCommand(),
        "add": PubAddCliCommand(),
        "version": PubVersionCliCommand(),
        "upgrade": PubUpgradeCliCommand(),
        "publish": PubPublishCliCommand(),
      };
}
