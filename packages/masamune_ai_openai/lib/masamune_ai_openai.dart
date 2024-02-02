// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Plug-in to make OpenAI API available on Masamune Framework. API key registration is required separately.
///
/// To use, import `package:masamune_ai_openai/masamune_ai_openai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai_openai;

// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/openai_masamune_adapter.dart';
part 'functions/openai_chat_gpt_functions_action.dart';

part 'src/openai_assistant.dart';
part 'src/openai_file.dart';
part 'src/openai_model.dart';
part 'src/openai_tools.dart';
part 'src/openai_thread.dart';
part 'src/openai_message.dart';
