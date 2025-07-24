// Copyright (c) 2025 mathru. All rights reserved.

/// Package for retrieving files such as images and videos from terminal storage, cameras, etc.
///
/// To use, import `package:masamune_picker/masamune_picker.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:file_picker/file_picker.dart";
import "package:image_picker/image_picker.dart";
import "package:masamune/masamune.dart";
import "package:mime/mime.dart";

export "storage/others/others.dart"
    if (dart.library.io) "storage/others/others.dart"
    if (dart.library.js) "storage/web/web.dart"
    if (dart.library.html) "storage/web/web.dart";

part "adapter/picker_masamune_adapter.dart";

part "src/picker.dart";
part "src/picker_file_type.dart";
part "src/picker_value.dart";
part "src/picker_interpolation.dart";
part "src/masamune_picker_permission_denied_exception.dart";
