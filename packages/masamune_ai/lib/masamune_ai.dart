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
import 'package:mcp_dart/mcp_dart.dart' as mcp;
import 'package:mcp_dart/src/shared/transport.dart' show Transport;
import 'package:mcp_dart/src/types.dart' show Content;

export 'package:mcp_dart/src/shared/transport.dart' show Transport;
export 'package:mcp_dart/mcp_dart.dart'
    show SseServerTransport, StdioServerTransport, StdioClientTransport;

part 'adapter/ai_masamune_adapter.dart';
part 'adapter/runtime_ai_masamune_adapter.dart';
part 'src/ai_content.dart';
part 'src/ai_role.dart';
part 'src/ai_thread.dart';
part 'src/ai_single.dart';
part 'src/invalid_ai_role_exception.dart';
part 'src/ai_schema.dart';
part 'src/ai_schema_type.dart';
part 'src/ai_config.dart';
part 'src/ai_file_type.dart';
part 'src/mcp_server.dart';
part 'src/mcp_function.dart';
part 'src/mcp_client.dart';
part 'src/ai_tool.dart';
part 'src/local_transport.dart';
part 'src/ai_function_call_config.dart';
