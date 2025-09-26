// Copyright (c) 2025 mathru. All rights reserved.

/// The Masamune package, which will enable drawing with touch or a stylus pen.
///
/// To use, import `package:masamune_painter/masamune_painter.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:convert";
import "dart:math" as math;
import "dart:ui" as ui;

// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:masamune/masamune.dart";
import "package:vector_math/vector_math_64.dart" hide Colors;

part "adapter/painter_masamune_adapter.dart";

part "src/painter_controller.dart";
part "src/form_painter_field.dart";
part "src/form_painter_toolbar.dart";
part "src/painting_value.dart";
part "src/painter_drag_mode.dart";
part "src/painter_resize_direction.dart";
part "src/painter_tools.dart";

part "tools/primary/select_painter_primary_tools.dart";
part "tools/primary/shape_painter_primary_tools.dart";
part "tools/primary/redo_painter_primary_tools.dart";
part "tools/primary/undo_painter_primary_tools.dart";
part "tools/primary/foreground_color_painter_primary_tools.dart";
part "tools/primary/background_color_painter_primary_tools.dart";
part "tools/primary/line_painter_primary_tools.dart";

part "tools/secondary/copy_painter_secondary_tools.dart";
part "tools/secondary/copy_image_painter_secondary_tools.dart";
part "tools/secondary/cut_painter_secondary_tools.dart";
part "tools/secondary/delete_painter_secondary_tools.dart";
part "tools/secondary/paste_painter_secondary_tools.dart";

part "tools/inline/shape/back_shape_painter_inline_tools.dart";
part "tools/inline/shape/rectangle_shape_painter_inline_tools.dart";
