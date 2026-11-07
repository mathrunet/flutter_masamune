import "dart:io";

import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

bool _isDevNullLink(String path) {
  return FileSystemEntity.typeSync(path, followLinks: false) ==
          FileSystemEntityType.link &&
      Link(path).targetSync() == "/dev/null";
}

Future<void> main() async {
  final temp = Directory.systemTemp.createTempSync("katana_debug_log_link_");
  try {
    final path = "${temp.path}/firebase-debug.log";

    // Creates the link when nothing exists.
    _check(
      await ensureFirebaseDebugLogLink(path: path),
      "A missing path must succeed.",
    );
    _check(_isDevNullLink(path), "A link to /dev/null must be created.");

    // Keeps an existing link to /dev/null (re-running compose).
    _check(
      await ensureFirebaseDebugLogLink(path: path),
      "An existing link to /dev/null must succeed.",
    );
    _check(_isDevNullLink(path), "The existing link must be kept.");

    // Replaces a regular file.
    Link(path).deleteSync();
    File(path).writeAsStringSync("log");
    _check(
      await ensureFirebaseDebugLogLink(path: path),
      "A regular file must be replaced.",
    );
    _check(_isDevNullLink(path), "A regular file must become a link.");

    // Replaces a link to another target.
    final other = File("${temp.path}/other.log")..writeAsStringSync("log");
    Link(path).deleteSync();
    Link(path).createSync(other.path);
    _check(
      await ensureFirebaseDebugLogLink(path: path),
      "A link to another target must be replaced.",
    );
    _check(_isDevNullLink(path), "The link must point to /dev/null.");
    _check(other.existsSync(), "The previous link target must be kept.");

    // Leaves a directory untouched.
    Link(path).deleteSync();
    Directory(path).createSync();
    _check(
      !await ensureFirebaseDebugLogLink(path: path),
      "A directory must be skipped.",
    );
    _check(Directory(path).existsSync(), "The directory must be kept.");
  } finally {
    temp.deleteSync(recursive: true);
  }
}
