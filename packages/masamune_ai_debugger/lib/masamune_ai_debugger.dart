// Copyright (c) 2025 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// AI debug overlay, incident reporting, and performance monitoring for
/// Masamune apps running in debug mode.
///
/// To use, import `package:masamune_ai_debugger/masamune_ai_debugger.dart`.
/// The default SamuraiAI integration reads its endpoint and API key from
/// `MASAMUNE_AI_DEBUGGER_ENDPOINT` and `MASAMUNE_AI_DEBUGGER_API_KEY`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

import "dart:async";
import "dart:convert";
import "dart:math" as math;
import "dart:ui" as ui;

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:masamune/masamune.dart";

part "adapter/ai_debugger_masamune_adapter.dart";
part "src/ai_debug_post.dart";
part "src/ai_debug_http_exception.dart";
part "src/ai_debug_controller.dart";
part "src/ai_debug_logger_adapter.dart";
part "src/ai_debug_overlay.dart";

const _modelLoadTracePrefix = "katana.model.load";
const _indicatorTracePrefix = "katana.indicator.show";
