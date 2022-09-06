// Copyright 2022 mathru. All rights reserved.

/// UI library using Masamune. Please be careful when using it normally, as it uses multiple external packages.
///
/// To use, import `package:masamune_ui/masamune_ui.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ui;

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:masamune/masamune.dart';
import 'package:wakelock/wakelock.dart';

import 'component/others/others.dart'
    if (dart.library.io) 'component/mobile/mobile.dart'
    if (dart.library.js) 'component/others/others.dart'
    if (dart.library.html) 'component/others/others.dart';
import 'form/form.dart';
import 'list/list.dart';

export 'package:badges/badges.dart' show Badge, BadgeAnimationType;
export 'package:flutter_breadcrumb/flutter_breadcrumb.dart'
    show BreadCrumb, BreadCrumbItem, WrapOverflow, ScrollableOverflow;
export 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
export 'package:holding_gesture/holding_gesture.dart'
    show HoldDetector, HoldTimeoutDetector;
export 'package:masamune/masamune.dart';
export 'package:responsive_grid/responsive_grid.dart'
    show ResponsiveGridRow, ResponsiveGridCol, ResponsiveGridList;

export 'calendar/ui_calendar.dart';
export 'component/others/others.dart'
    if (dart.library.io) 'component/mobile/mobile.dart'
    if (dart.library.js) 'component/others/others.dart'
    if (dart.library.html) 'component/others/others.dart';
export 'form/form.dart';
export 'list/list.dart';
export 'ui/ui.dart';
export 'variable/variable.dart';

part 'component/account_drawer_header.dart';
part "component/bread_crumb_builder.dart";
part 'component/clickable_box.dart';
part 'component/cms_layout.dart';
part 'component/search_bar.dart';
part 'component/search_builder.dart';
part 'component/ui_bottom_call_action.dart';
part "component/ui_carousel.dart";
part 'component/ui_markdown.dart';
part 'ref/wakelock.dart';
