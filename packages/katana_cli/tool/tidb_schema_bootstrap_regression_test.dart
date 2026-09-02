import "dart:io";

import "package:katana_cli/action/cloudflare/tidb.dart";

void main() {
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
