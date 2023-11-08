// Copyright 2023 mathru. All rights reserved.

/// This library is designed to make Masamune's auto-generated models compatible with PlanetScale.
///
/// To use, import `package:masamune_model_planetscale/masamune_model_planetscale.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_planetscale;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:masamune/masamune.dart';

export 'package:masamune_model_planetscale_annotation/masamune_model_planetscale_annotation.dart';

part 'adapter/planetscale_model_adapter.dart';
part 'src/planetscale_query.dart';
part 'src/planetscale_functions_action.dart';
