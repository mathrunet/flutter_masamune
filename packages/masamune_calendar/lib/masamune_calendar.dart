// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin to provide calendar functionality.
///
/// To use, import `package:masamune_calendar/masamune_ai_openai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_calendar;

// Dart imports:

// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';

part 'adapter/calendar_masamune_adapter.dart';
part 'src/calendar_controller.dart';
part 'src/calendar_item.dart';
part 'src/calendar_format.dart';
part 'src/day_of_week.dart';
part 'src/calendar.dart';
part 'src/calendar_style.dart';
part 'src/calendar_delegate.dart';
part 'src/calendar_header.dart';
part 'delegate/marker_calendar_delegate.dart';
