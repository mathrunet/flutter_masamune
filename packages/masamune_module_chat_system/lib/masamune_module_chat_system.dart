// Copyright (c) 2024 mathru. All rights reserved.

/// Plug-in module for Masamune that allows voice interaction with ChatGPT.
///
/// To use, import `package:masamune_module_chat_system/masamune_module_chat_system.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_module_chat_system;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_ai_openai/masamune_ai_openai.dart';
import 'package:masamune_module/masamune_module.dart';
import 'package:masamune_speech_to_text/masamune_speech_to_text.dart';
import 'package:masamune_text_to_speech/masamune_text_to_speech.dart';

part 'adapter/chat_system_module_masamune_adapter.dart';
part 'src/chat_system_module.dart';
part 'src/chat_system_module_options.dart';
part 'src/chat_system_status.dart';
part 'src/chat_system_options.dart';
part 'src/chat_system_role.dart';
part 'src/chat_system_value.dart';
part 'ui/chat_system_list_view.dart';
part 'ui/chat_system_bottom_bar.dart';
