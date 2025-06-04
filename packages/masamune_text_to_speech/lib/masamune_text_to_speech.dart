// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plug-in adapter for use with Text-to-Speech. Provides a controller.
///
/// To use, import `package:masamune_text_to_speech/masamune_text_to_speech.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:flutter_tts/flutter_tts.dart";
import "package:masamune/masamune.dart";
import "package:universal_platform/universal_platform.dart";

part "adapter/text_to_speech_masamune_adapter.dart";
part "src/text_to_speech_controller.dart";
part "src/text_to_speech_ios_audio_category.dart";
