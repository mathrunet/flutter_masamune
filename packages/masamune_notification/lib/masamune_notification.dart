// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plugin to use base classes and stubs to implement PUSH notifications.
///
/// To use, import `package:masamune_notification/masamune_notification.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_scheduler/masamune_scheduler.dart";

// Project imports:
import "models/local_notification_schedule.dart";
import "models/remote_notification_schedule.dart";

export "models/local_notification_schedule.dart";
export "models/remote_notification_schedule.dart";
export "package:masamune_scheduler/masamune_scheduler.dart";

part "adapter/runtime_remote_notification_masamune_adapter.dart";
part "adapter/runtime_local_notification_masamune_adapter.dart";

part "functions/send_remote_notification_functions_action.dart";

part "src/local_notification.dart";
part "src/remote_notification.dart";
part "src/notification_target_query.dart";
part "src/local_notification_masamune_adapter.dart";
part "src/remote_notification_masamune_adapter.dart";
part "src/notification_value.dart";
part "src/notification_logger_event.dart";
part "src/notification_sound.dart";
part "src/local_notification_repeat_settings.dart";
