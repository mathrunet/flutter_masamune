// Copyright 2023 mathru. All rights reserved.

/// Plug-in package to easily add Firebase Analytics and Crashlytics on Masamune Framework. The functionality is available by simply adding an Adapter.
///
/// To use, import `package:masamune_logger_firebase/masamune_logger_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_logger_firebase;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:masamune/masamune.dart';

export 'package:masamune/masamune.dart';
export 'package:katana_firebase/katana_firebase.dart';

part 'adapter/firebase_logger_masamune_adapter.dart';
part 'src/firebase_logger_adapter_scope.dart';
part 'src/firebase_logger.dart';
