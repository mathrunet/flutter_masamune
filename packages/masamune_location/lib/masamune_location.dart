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
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:masamune/masamune.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';
export 'package:geolocator/geolocator.dart' show LocationAccuracy;

part 'adapter/location_masamune_adapter.dart';
part 'src/location.dart';
