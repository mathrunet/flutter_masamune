// Copyright (c) 2025 mathru. All rights reserved.

/// The Masamune package, which will enable drawing with touch or a stylus pen.
///
/// To use, import `package:masamune_painter/masamune_painter.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:math" as math;
import "dart:ui" as ui;

// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:masamune/masamune.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:vector_math/vector_math_64.dart" hide Colors;

part "adapter/painter_masamune_adapter.dart";

part "src/painter_controller.dart";
part "src/form_painter_field.dart";
part "src/form_painter_toolbar.dart";
part "src/painting_value.dart";
part "src/painter_drag_mode.dart";
part "src/painter_resize_direction.dart";
part "src/painter_tools.dart";
part "src/color_picker_modal.dart";

part "tools/primary/select_painter_primary_tools.dart";
part "tools/primary/shape_painter_primary_tools.dart";
part "tools/primary/text_painter_primary_tools.dart";
part "tools/primary/image_painter_primary_tools.dart";
part "tools/primary/redo_painter_primary_tools.dart";
part "tools/primary/undo_painter_primary_tools.dart";

part "tools/secondary/copy_painter_secondary_tools.dart";
part "tools/secondary/copy_image_painter_secondary_tools.dart";
part "tools/secondary/cut_painter_secondary_tools.dart";
part "tools/secondary/delete_painter_secondary_tools.dart";
part "tools/secondary/paste_painter_secondary_tools.dart";

part "tools/inline/select/select_painter_inline_tools.dart";
part "tools/inline/select/background_color_painter_inline_tools.dart";
part "tools/inline/select/foreground_color_painter_inline_tools.dart";
part "tools/inline/select/line_painter_inline_tools.dart";
part "tools/inline/select/group_painter_inline_tools.dart";
part "tools/inline/select/filter_painter_inline_tools.dart";

part "tools/inline/shape/back_shape_painter_inline_tools.dart";
part "tools/inline/shape/rectangle_shape_painter_inline_tools.dart";

part "tools/block/filter/blur_filter_painter_block_tools.dart";

part "tools/block/group/grouping_group_painter_block_tools.dart";
part "tools/block/line/solid_1px_line_painter_block_tools.dart";
part "tools/block/line/solid_10px_line_painter_block_tools.dart";
