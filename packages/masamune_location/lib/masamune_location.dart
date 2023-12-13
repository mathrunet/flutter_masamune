// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library for handling location information in apps.
///
/// To use, import `package:masamune_location/masamune_location.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:location/location.dart' as location;
import 'package:masamune/masamune.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:masamune_location_platform_interface/masamune_location_platform_interface.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';
export 'package:masamune_location_platform_interface/masamune_location_platform_interface.dart';

part 'adapter/location_masamune_adapter.dart';
part 'src/location.dart';
