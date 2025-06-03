// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library for handling background location information in apps.
///
/// To use, import `package:masamune_location_background/masamune_location_background.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location_background;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_location_platform_interface/masamune_location_platform_interface.dart";

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';
export "package:masamune_location_platform_interface/masamune_location_platform_interface.dart";

part "adapter/background_location_masamune_adapter.dart";
part "src/background_location_android_notification_settings.dart";
