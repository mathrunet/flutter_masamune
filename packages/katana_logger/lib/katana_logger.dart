// Copyright (c) 2024 mathru. All rights reserved.

/// Base package for logging app performance and access status. Additional packages can be installed to use Firebase Analytics, etc.
///
/// To use, import `package:katana_logger/katana_logger.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_logger;

// Dart imports:
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:katana/katana.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'package:katana/katana.dart';
export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/console_logger_adapter.dart';
part 'adapter/local_logger_adapter.dart';
part 'adapter/runtime_logger_adapter.dart';

part 'src/log_value.dart';
part 'src/loggable.dart';
part 'src/logger.dart';
part 'src/logger_adapter.dart';
part 'src/logger_database.dart';
part 'src/logger_tracer.dart';
