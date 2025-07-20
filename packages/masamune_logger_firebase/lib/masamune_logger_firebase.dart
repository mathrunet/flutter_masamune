// Copyright (c) 2025 mathru. All rights reserved.

/// Plug-in package to easily add Firebase Analytics, Performance and Crashlytics on Masamune Framework. The functionality is available by simply adding an Adapter.
///
/// To use, import `package:masamune_logger_firebase/masamune_logger_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:firebase_performance/firebase_performance.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:masamune/masamune.dart";

export "package:katana_firebase/katana_firebase.dart";

part "adapters/firebase_logger_adapter.dart";
part "adapters/firebase_logger_masamune_adapter.dart";
part "src/firebase_analytics_logger_event.dart";

part "loggable/firebase_analytics_register_loggable.dart";
part "loggable/firebase_analytics_register_or_signin_loggable.dart";
part "loggable/firebase_analytics_signin_loggable.dart";

part "loggable/firebase_analytics_adshown_loggable.dart";
part "loggable/firebase_analytics_purchased_loggable.dart";
part "loggable/firebase_analytics_refund_loggable.dart";
part "loggable/firebase_analytics_tutorial_end_loggable.dart";
part "loggable/firebase_analytics_tutorial_start_loggable.dart";
