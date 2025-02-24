// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Plug-in to make Firebase App Check available on Masamune Framework.
///
/// To use, import `package:masamune_firebase_app_check/masamune_firebase_app_check.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_firebase_app_check;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:masamune/masamune.dart';
import 'package:universal_platform/universal_platform.dart';

part 'adapter/firebase_app_check_masamune_adapter.dart';

part 'src/firebase_app_check_android_provider.dart';
part 'src/firebase_app_check_ios_provider.dart';
