// Copyright (c) 2026 mathru. All rights reserved.

/// Plug-in for Masamune that remotely controls maintenance mode, announcements, feature flags and endpoint switching for application handover (buyout) scenarios.
///
/// To use, import `package:masamune_handover/masamune_handover.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:shared_preferences/shared_preferences.dart";

part "adapter/handover_masamune_adapter.dart";
part "src/handover_config.dart";
part "src/handover_repository.dart";
part "src/handover.dart";
part "src/handover_gate.dart";
