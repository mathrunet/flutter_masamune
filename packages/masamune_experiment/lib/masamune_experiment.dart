// Copyright (c) 2025 mathru. All rights reserved.

/// Plug-in for Masamune that defines A/B tests and feature switches in a single synchronous function based on Firebase Remote Config values.
///
/// To use, import `package:masamune_experiment/masamune_experiment.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart";

export "package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart";

part "adapter/experiment_masamune_adapter.dart";
part "src/experiment.dart";
part "src/experiment_case.dart";
part "src/experiment_config.dart";
part "src/experiment_document.dart";
