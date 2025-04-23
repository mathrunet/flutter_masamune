// Copyright (c) 2024 mathru. All rights reserved.

/// Provides an interface to execute server-side processing in a type-safe manner. Actual processing on the server side is done by importing a separate adapter.
///
/// To use, import `package:katana_functions/katana_functions.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_functions;

// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:katana/katana.dart';

export 'package:katana/katana.dart';

part 'adapter/runtime_functions_adapter.dart';
part 'adapter/rest_api_functions_adapter.dart';

part 'src/functions.dart';
part 'src/functions_adapter.dart';
part 'src/functions_action.dart';
part 'src/functions_stub.dart';
