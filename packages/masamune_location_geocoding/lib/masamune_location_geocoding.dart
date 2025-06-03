// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin for using Google Map Geocoding API with Firebase Functions.
///
/// To use, import `package:masamune_location_geocoding/masamune_location_geocoding.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_location_geocoding;

// Dart imports:

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:masamune/masamune.dart";

part "adapter/geocoding_masamune_adapter.dart";
part "functions/geocoding_functions_action.dart";
