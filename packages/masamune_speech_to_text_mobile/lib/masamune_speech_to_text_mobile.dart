// ignore_for_file: depend_on_referenced_packages

// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plug-in adapter for use with Speech-to-Text on mobile. Provides a controller.
///
/// To use, import `package:masamune_speech_to_text_mobile/masamune_speech_to_text_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:math";

// Flutter imports:
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:clock/clock.dart";
import "package:masamune/masamune.dart";
import "package:masamune_speech_to_text/masamune_speech_to_text.dart";
import "package:speech_to_text/speech_recognition_error.dart";
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import "package:permission_handler/permission_handler.dart";

import "package:speech_to_text_platform_interface/speech_to_text_platform_interface.dart"
    hide ListenMode;

part "adapter/mobile_speech_to_text_masamune_adapter.dart";
part "src/speech_to_text.dart";
