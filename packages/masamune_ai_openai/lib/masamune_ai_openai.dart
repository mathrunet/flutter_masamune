// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Plug-in to make OpenAI API available on Masamune Framework. API key registration is required separately.
///
/// To use, import `package:masamune_ai_openai/masamune_ai_openai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai_openai;

// Flutter imports:
import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_ai/masamune_ai.dart';

part 'adapter/openai_ai_masamune_adapter.dart';
part 'functions/openai_chat_gpt_functions_action.dart';
part 'src/extensions.dart';
part 'src/openai_ai_model.dart';
