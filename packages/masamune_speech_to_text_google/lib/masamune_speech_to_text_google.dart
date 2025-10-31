// ignore_for_file: depend_on_referenced_packages

// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plug-in adapter for use with Speech-to-Text on Google. Provides a controller.
///
/// To use, import `package:masamune_speech_to_text_google/masamune_speech_to_text_google.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:typed_data";

// Flutter imports:
import "package:flutter/widgets.dart";
import "package:flutter_sound/flutter_sound.dart";
import "package:google_speech/endless_streaming_service_v2.dart";
import "package:google_speech/generated/google/cloud/speech/v2/cloud_speech.pb.dart";
import "package:google_speech/google_speech.dart";
import "package:masamune_google_cloud/masamune_google_cloud.dart";
import "package:permission_handler/permission_handler.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_speech_to_text/masamune_speech_to_text.dart";

part "adapter/google_speech_to_text_masamune_adapter.dart";
