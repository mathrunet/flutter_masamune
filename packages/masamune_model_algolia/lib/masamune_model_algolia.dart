// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin package that includes a model adapter to retrieve data from Algolia.
///
/// To use, import `package:masamune_model_algolia/masamune_model_algolia.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_algolia;

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:masamune/masamune.dart';
import 'package:meta/meta.dart';

part 'adapter/algolia_model_adapter.dart';
