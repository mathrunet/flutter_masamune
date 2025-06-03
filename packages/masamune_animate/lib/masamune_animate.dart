// Copyright (c) 2024 mathru. All rights reserved.

/// A package for animation that runs on the Masamune framework.
///
/// To use, import `package:masamune_animate/masamune_animate.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_animate;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/scheduler.dart";
import "package:flutter/widgets.dart";

export "query/query.dart";

part "src/animate_scope.dart";
part "src/animate_query.dart";
part "src/animate_controller.dart";
part "src/wait_query.dart";
part "src/animate_runner.dart";
