// Copyright 2023 mathru. All rights reserved.

/// Masamune plug-in adapter for use with Speech-to-Text. Provides a controller.
///
/// To use, import `package:masamune_speech_to_text/masamune_speech_to_text.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_speech_to_text;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'adapter/speech_to_text_masamune_adapter.dart';
part 'src/speech_to_text_controller.dart';
