// Project imports:
// ignore_for_file: avoid_print

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

const _mainCommands = {
  "flutter":
      "The `flutter` command does not exist. Please install from the following:\nhttps://docs.flutter.dev/get-started/install\n\n`flutter`コマンドが存在しません。下記からインストールを行ってください。\nhttps://docs.flutter.dev/get-started/install",
  "dart":
      "The `dart` command does not exist. Please install from the following:\nhttps://dart.dev/get-dart\n\n`dart`コマンドが存在しません。下記からインストールを行ってください。\nhttps://dart.dev/get-dart",
  "npm":
      "The `npm` command does not exist. Please install NodeJS from the following:\nhttps://nodejs.org/en/download\n\n`npm`コマンドが存在しません。下記からNodeJSのインストールを行ってください。\nhttps://nodejs.org/en/download",
  "git":
      "The command `git` does not exist. Please refer to the following site to install and pass through the path:\nhttps://git-scm.com/book/en/v2/Getting-Started-Installing-Git\n\n`git`のコマンドが存在しません。下記のサイトを参考にインストールを行ってパスを通してください。\nhttps://git-scm.com/book/en/v2/Getting-Started-Installing-Git",
  "keytool":
      "The `keytool` command does not exist. Please install the JDK from the following and pass the path under the bin file of the installed JDK:\nhttps://jdk.java.net/\n\n`keytool`コマンドが存在しません。下記からJDKをインストールし、インストールしたJDKのbinファイル以下のパスを通してください。\nhttps://jdk.java.net/",
  "openssl":
      "The command `openssl` does not exist.\n[Windows] Please install from the following and pass through the path:\nhttps://slproweb.com/products/Win32OpenSSL.html\n[Mac] Please install from the following command and pass through the path:\n`brew install openssl`\n\n`openssl`のコマンドが存在しません。\n[Windows]下記からインストールを行ってパスを通してください。\nhttps://slproweb.com/products/Win32OpenSSL.html\n[Mac]下記のコマンドからインストールを行ってパスを通してください。。\n`brew install openssl`",
  "gsutil":
      "The `gsutil` command does not exist.\nPlease install from the following:\nhttps://cloud.google.com/storage/docs/gsutil_install\n\n`gsutil`コマンドが存在しません。\n下記からインストールを行ってください。\nhttps://cloud.google.com/storage/docs/gsutil_install",
};

final _macOSMainCommand = {
  "pod":
      "The `pod` command does not exist, please install XCode.\n\n`pod`コマンドが存在しません。XCodeのインストールを行ってください。",
};

final _npmCommand = {
  "eslint": "eslint",
  "firebase": "firebase-tools",
  "lefthook": "lefthook",
  "gh": "gh",
};

final _flutterCommand = {
  "flutterfire": "flutterfire_cli",
};

/// Check the installation status of the commands required for the `katana` command.
///
/// Installation is also performed, but may fail due to permissions. In that case, please execute the installation with administrator privileges.
///
/// `katana`コマンドに必要なコマンドのインストール状況を調べます。
///
/// インストールも行いますがパーミッションの関係で失敗する場合があります。その場合は管理者権限で実行してください。
class DoctorCliCommand extends CliCommand {
  /// Check the installation status of the commands required for the `katana` command.
  ///
  /// Installation is also performed, but may fail due to permissions. In that case, please execute the installation with administrator privileges.
  ///
  /// `katana`コマンドに必要なコマンドのインストール状況を調べます。
  ///
  /// インストールも行いますがパーミッションの関係で失敗する場合があります。その場合は管理者権限で実行してください。
  const DoctorCliCommand();

  @override
  String get description =>
      "Check the installation status of the commands required for the `katana` command. Installation is also performed, but may fail due to permissions. In that case, please execute the installation with administrator privileges. `katana`コマンドに必要なコマンドのインストール状況を調べます。インストールも行いますがパーミッションの関係で失敗する場合があります。その場合は管理者権限で実行してください。";

  @override
  Future<void> exec(ExecContext context) async {
    try {
      final bin = context.yaml.getAsMap("bin");
      final npm = bin.get("npm", "npm");
      final dart = bin.get("dart", "dart");
      final which =
          bin.get("which", Platform.isWindows ? "where.exe" : "which");
      label(
        "Check the installation status of the commands required for the `katana` command.",
      );
      for (final com in _mainCommands.entries) {
        final res = await Process.run(
          which,
          [com.key],
          runInShell: true,
        );
        final path = (res.stdout as String).trim();
        if (path.isEmpty) {
          print("[x] `${com.key}` not exists\n${com.value}\n\n");
        } else {
          print("[o] `${com.key}` exists at `$path`");
        }
      }
      if (Platform.isMacOS) {
        for (final com in _macOSMainCommand.entries) {
          final res = await Process.run(
            which,
            [com.key],
            runInShell: true,
          );
          final path = (res.stdout as String).trim();
          if (path.isEmpty) {
            print("[x] `${com.key}` not exists\n\n${com.value}\n\n");
          } else {
            print("[o] `${com.key}` exists at `$path`");
          }
        }
      }
      label(
          "Check the installation status of the npm commands required for the `katana` command.");
      for (final com in _npmCommand.entries) {
        final res = await Process.run(
          which,
          [com.key],
          runInShell: true,
        );
        final path = (res.stdout as String).trim();
        if (path.isEmpty) {
          print("[x] `${com.key}` not exists. Try to install.");
          await command(
            "Install `${com.value}`",
            [npm, "install", "-g", com.value],
            runInShell: true,
            catchError: true,
          );
        } else {
          print("[o] `${com.key}` exists at `$path`");
        }
      }
      label(
          "Check the installation status of the flutter commands required for the `katana` command.");
      for (final com in _flutterCommand.entries) {
        final res = await Process.run(
          which,
          [com.key],
          runInShell: true,
        );
        final path = (res.stdout as String).trim();
        if (path.isEmpty) {
          print("[x] `${com.key}` not exists. Try to install.");
          await command(
            "Install `${com.value}`",
            [dart, "pub", "global", "activate", com.value],
            runInShell: true,
            catchError: true,
          );
        } else {
          print("[o] `${com.key}` exists at `$path`");
        }
      }
      print("\n");
    } catch (e) {
      print(e);
      print(
        "\n\nIn case of a permission error, please run the following with administrator privileges.\n`sudo kata doctor`.\n\nパーミッションエラーの場合は、下記のように管理者権限で実行してください。\n`sudo kata doctor`\n\n",
      );
    }
  }
}
