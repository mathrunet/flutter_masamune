// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library for handling location information in apps.
///
/// To use, import `package:masamune_location/masamune_location.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart' show LocationData;
import 'package:location/location.dart' as location;
import 'package:masamune/masamune.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';
export 'package:location/location.dart'
    show LocationData, LocationAccuracy, PermissionStatus;

part 'adapter/location_masamune_adapter.dart';
part 'src/location.dart';
