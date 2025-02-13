// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library for local PUSH notification. Only mobile can handle.
///
/// To use, import `package:masamune_notification_local/masamune_notification_local.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_notification_local;

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide UILocalNotificationDateInterpretation, AndroidScheduleMode;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as local_notifications;
import 'package:masamune/masamune.dart';
import 'package:masamune_notification/masamune_notification.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:universal_platform/universal_platform.dart';

export 'package:masamune_notification/masamune_notification.dart';

// Project imports:
part 'adapter/mobile_local_notification_masamune_adapter.dart';
part 'src/ui_local_notification_date_interpretation.dart';
part 'src/android_schedule_mode.dart';
