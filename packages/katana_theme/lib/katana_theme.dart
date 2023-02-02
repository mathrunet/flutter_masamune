// Copyright 2023 mathru. All rights reserved.

/// Base package for providing simple and straightforward theme definitions on Flutter.
///
/// To use, import `package:katana_theme/katana_theme.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_theme;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:katana/katana.dart';
export 'package:katana_theme_annotation/katana_theme_annotation.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'src/app_theme_data.dart';
part 'src/theme_scope.dart';
part 'src/extensions.dart';
part 'src/gradient_color.dart';
part 'src/video_provider.dart';
part 'src/text_provider.dart';
