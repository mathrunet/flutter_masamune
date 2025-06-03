// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library for handling location information in apps.
///
/// To use, import `package:masamune_location/masamune_location.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

// Package imports:
import 'package:geolocator/geolocator.dart' as location;
import "package:masamune/masamune.dart";
import "package:masamune_location_platform_interface/masamune_location_platform_interface.dart";
import "package:permission_handler/permission_handler.dart";

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';
export "package:masamune_location_platform_interface/masamune_location_platform_interface.dart";

export 'package:permission_handler/permission_handler.dart'
    show openAppSettings;

part "adapter/mobile_location_masamune_adapter.dart";
part "adapter/mock_location_masamune_adapter.dart";
part "src/location_masamune_adapter.dart";
part "src/location.dart";
part "src/location_service_not_available_exception.dart";
