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

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/speech_to_text_masamune_adapter.dart';
