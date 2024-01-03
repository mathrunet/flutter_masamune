// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin to provide calendar functionality. The masamune framework is assumed to be used.
///
/// To use, import `package:masamune_calendar/masamune_calendar.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_calendar;

// Dart imports:

// Dart imports:
import 'dart:math';

// Flutter imports:
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
part 'delegate/builder_calendar_delegate.dart';
