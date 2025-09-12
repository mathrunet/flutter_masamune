// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune package for uploading files to storage using Functions.
///
/// To use, import `package:masamune_storage_functions/masamune_storage_functions.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:convert";
import "dart:typed_data";

// Package imports:
import "package:masamune/masamune.dart";

export "adapter/others/others.dart"
    if (dart.library.io) "adapter/others/others.dart"
    if (dart.library.js) "adapter/web/web.dart"
    if (dart.library.html) "adapter/web/web.dart";

part "actions/storage_functions_action.dart";
part "src/functions_storage_database.dart";
