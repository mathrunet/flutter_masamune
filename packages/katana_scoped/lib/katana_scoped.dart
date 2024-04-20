// Copyright (c) 2024 mathru. All rights reserved.

/// A state management package to allow for retention and management while specifying the scope of the state.
///
/// To use, import `package:katana_scoped/katana_scoped.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_scoped;

import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_logger/katana_logger.dart';

export 'package:katana/katana.dart';
export 'package:katana_logger/katana_logger.dart';
export 'value/value.dart';

part 'src/app_scoped.dart';
part 'src/extensions.dart';
part 'src/ref.dart';
part 'src/scoped.dart';
part 'src/scoped_ref.dart';
part 'src/scoped_scope.dart';
part 'src/scoped_value.dart';
part 'src/scoped_value_container.dart';
part 'src/scoped_value_listener.dart';
part 'src/scoped_value_ref.dart';
part 'src/scoped_query.dart';
part 'src/scoped_logger_event.dart';
