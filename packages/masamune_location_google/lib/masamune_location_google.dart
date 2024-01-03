// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library for displaying GoogleMap including location information.
///
/// To use, import `package:masamune_location_google/masamune_location_google.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location_google;

// Dart imports:
import 'dart:math';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_location/masamune_location.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide
        Marker,
        Polygon,
        Polyline,
        Circle,
        TileOverlay,
        CameraPosition,
        CameraPositionCallback;
import 'package:google_maps_flutter/google_maps_flutter.dart' as map
    show Marker, Polygon, Polyline, Circle, TileOverlay, CameraPosition;

export 'package:masamune_location/masamune_location.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        MapCreatedCallback,
        CameraTargetBounds,
        MapType,
        MinMaxZoomPreference,
        ArgumentCallback,
        BitmapDescriptor;

part 'adapter/google_location_masamune_adapter.dart';

part 'src/map_style.dart';
part 'src/map_controller.dart';
part 'src/map_view.dart';
part 'src/marker.dart';
part 'src/polygon.dart';
part 'src/extensions.dart';
part 'src/polyline.dart';
part 'src/circle.dart';
part 'src/tile_overlay.dart';
part 'src/camera_position.dart';
