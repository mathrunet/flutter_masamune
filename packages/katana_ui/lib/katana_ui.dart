// Copyright (c) 2025 mathru. All rights reserved.

/// A package that provides widgets for UI to facilitate design and implementation.
///
/// To use, import `package:katana_ui/katana_ui.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart" hide Scaffold;

// Package imports:
import "package:katana/katana.dart";
import "package:katana_platform_info/katana_platform_info.dart";
import "package:shimmer/shimmer.dart" as sm;

export "package:katana/katana.dart";

export "ui/others/others.dart"
    if (dart.library.io) "ui/others/others.dart"
    if (dart.library.js) "ui/web/web.dart"
    if (dart.library.html) "ui/web/web.dart";

part "modal/modal.dart";
part "src/extensions.dart";
part "ui/loading_builder.dart";
part "ui/scroll_builder.dart";
part "ui/indent.dart";
part "ui/card_tile.dart";
part "ui/label.dart";
part "ui/line_tile.dart";
part "ui/periodic_scope.dart";
part "ui/chat_tile.dart";
part "ui/shimmer.dart";
part "ui/avatar_tile.dart";
part "ui/message_box.dart";
part "ui/square_avatar.dart";
part "ui/sns_content_tile.dart";
part "ui/list_tile_group.dart";
part "ui/sns_image.dart";
