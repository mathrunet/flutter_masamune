// Copyright 2022 mathru. All rights reserved.

/// Masamune local messaging framework library.
///
/// To use, import `package:masamune_local_messaging/masamune_local_messaging.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_local_messaging;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masamune/masamune.dart';
import 'package:timezone/timezone.dart' as tz;

export 'package:masamune/masamune.dart';

part 'src/local_messaging_core.dart';
part 'src/local_messaging_model.dart';
part 'adapter/local_messaging_adapter.dart';
