// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// This package is designed to interact with generative AI within the Masamune framework.
///
/// To use, import `package:masamune_ai/masamune_ai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai;

// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';

part 'adapter/ai_masamune_adapter.dart';
part 'src/ai_content.dart';
part 'src/ai_role.dart';
part 'src/ai_thread.dart';
part 'src/invalid_ai_role_exception.dart';
part 'src/ai_schema.dart';
part 'src/ai_schema_type.dart';
part 'src/ai_config.dart';
part 'src/ai_file_type.dart';
