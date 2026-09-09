import "dart:io";

import "package:katana_cli/action/cloudflare/tidb.dart";

void main() {
  final actionSource = File(
    "lib/action/cloudflare/tidb.dart",
  ).readAsStringSync();
  final completedCutoverStart = actionSource.indexOf(
    'if (restrictMysql && state == "complete" && previousHash == manifestHash)',
  );
  final preparedCutoverStart = actionSource.indexOf(
    'if (restrictMysql && state == "prepared" && previousHash == manifestHash)',
    completedCutoverStart,
  );
  final completedCutoverBranch = actionSource.substring(
    completedCutoverStart,
    preparedCutoverStart,
  );
  final copyManifestAt = completedCutoverBranch.indexOf(
    "await _copyRuntimeManifest(manifestText);",
  );
  final updateWorkerAt = completedCutoverBranch.indexOf(
    "await _updateWorkersFunction(mode)",
  );
  final completedLabelAt = completedCutoverBranch.indexOf(
    'label("TiDB Data Service-only cutover is already complete.");',
  );
  _expect(
    completedCutoverStart >= 0 && preparedCutoverStart > completedCutoverStart,
    "the completed cutover branch must remain identifiable",
  );
  _expect(
    copyManifestAt >= 0 &&
        updateWorkerAt > copyManifestAt &&
        completedLabelAt > updateWorkerAt,
    "completed cutover must refresh the manifest and Worker registration before returning",
  );

  final dataServiceFunction = buildTidbWorkersFunctionDefinition(
    "data_service",
  );
  _expect(
    dataServiceFunction.contains('mode: "data-service"'),
    "Data Service generation must select the Data Service runtime mode",
  );
  _expect(
    !buildTidbWorkersFunctionDefinition("direct").contains("mode:"),
    "non-Data Service generation must not force the Data Service runtime mode",
  );

  const source = """
CREATE DATABASE IF NOT EXISTS `dev_app`;
USE `dev_app`;
CREATE TABLE IF NOT EXISTS `users` (`id` VARCHAR(255) PRIMARY KEY);
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `name` TEXT;

CREATE DATABASE IF NOT EXISTS `dev_app`;
USE `dev_app`;
CREATE TABLE IF NOT EXISTS `posts` (`id` VARCHAR(255) PRIMARY KEY);
ALTER TABLE `posts` ADD COLUMN IF NOT EXISTS `title` TEXT;
""";

  final migrations = splitTidbAdditiveSchemaMigrations(source);
  _expect(migrations.length == 2, "each table must use one bootstrap endpoint");
  _expect(
    migrations.first.contains("CREATE TABLE IF NOT EXISTS `users`") &&
        !migrations.first.contains("`posts`"),
    "the first migration must contain only the users table",
  );
  _expect(
    migrations.last.startsWith(
      "CREATE DATABASE IF NOT EXISTS `dev_app`;\nUSE `dev_app`;",
    ),
    "each migration must select its own database",
  );
  stdout.writeln("All TiDB schema bootstrap checks passed.");
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
