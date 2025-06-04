// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plug-in package for simple use of the camera.
///
/// To use, import `package:masamune_camera/masamune_camera.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Package imports:
import "package:camera/camera.dart" as camera;
import "package:masamune/masamune.dart";
import "package:permission_handler/permission_handler.dart";

import "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

export "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

part "adapter/mobile_camera_masamune_adapter.dart";
part "adapter/mock_camera_masamune_adapter.dart";
part "src/camera.dart";
part "src/resolution_preset.dart";
part "src/image_format.dart";
part "src/camera_masamune_adapter.dart";
part "storage/storage.dart";
