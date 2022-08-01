// Copyright 2022 mathru. All rights reserved.

/// Masamune location framework library.
///
/// To use, import `package:masamune_location/masamune_location.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:masamune/masamune.dart';

export 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:masamune/masamune.dart';

part 'src/functions.dart';
part 'src/location_core.dart';
part 'src/location_model.dart';
part 'src/map_controller.dart';
part 'src/map_style.dart';
part 'src/ui_google_map.dart';
part 'adapter/mobile_location_adapter.dart';
