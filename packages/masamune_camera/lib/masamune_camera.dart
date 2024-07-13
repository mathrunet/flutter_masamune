// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plug-in package for simple use of the camera.
///
/// To use, import `package:masamune_camera/masamune_camera.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_camera;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:camera/camera.dart' as camera;
import 'package:masamune/masamune.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/camera_masamune_adapter.dart';
part 'src/camera.dart';
part 'src/resolution_preset.dart';
part 'src/image_format.dart';
part 'storage/storage.dart';
