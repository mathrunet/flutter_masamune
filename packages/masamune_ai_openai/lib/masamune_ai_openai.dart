// Copyright 2023 mathru. All rights reserved.

/// Plug-in to make OpenAI API available on Masamune Framework. API key registration is required separately.
///
/// To use, import `package:masamune_ai_openai/masamune_ai_openai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai_openai;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:dart_openai/openai.dart';
import 'package:masamune/masamune.dart';

part 'adapter/openai_masamune_adapter.dart';
part 'src/openai_chat.dart';
part 'src/openai_media.dart';
