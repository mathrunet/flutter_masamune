// Copyright (c) 2024 mathru. All rights reserved.

/// The package provide a universal UI that aims to be written in one code on any platform.
///
/// To use, import `package:masamune_universal_ui/masamune_universal_ui.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_universal_ui;

// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:url_launcher/url_launcher_string.dart' show LaunchMode;

part 'adapter/universal_masamune_adapter.dart';
part 'adapter/precache_image_masamune_adapter.dart';

part 'extension/text.dart';
part 'extension/icon.dart';
part 'extension/structure.dart';
part 'extension/decoration.dart';
part 'extension/padding.dart';
part 'extension/gesture_detector.dart';
part 'extension/clip.dart';

part 'src/functions.dart';
part 'src/breakpoint_settings.dart';
part 'src/breakpoint.dart';
part 'src/extensions.dart';
part 'src/responsive.dart';
part 'src/universal_app_bar.dart';
part 'src/universal_column.dart';
part 'src/universal_container.dart';
part 'src/universal_list_view.dart';
part 'src/refresh_indicator_scroll_physics.dart';
part 'src/universal_scaffold.dart';
part 'src/universal_side_bar.dart';
part 'src/responsive_edge_insets.dart';
part 'src/universal_padding.dart';
part 'src/universal_widget_scope.dart';
part 'src/universal_search_bar.dart';
part 'src/universal_header_tile.dart';
part 'src/universal_grid_view.dart';
