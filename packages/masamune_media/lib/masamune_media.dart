// Copyright 2022 mathru. All rights reserved.

/// Plug-in package for uploading Masamune media files. Select and upload images and videos from your library or camera.
///
/// To use, import `package:masamune_media/masamune_media.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_media;

import 'package:masamune/masamune.dart';
import 'package:masamune_media/dialog/others/others.dart';

export 'package:masamune/masamune.dart';

export 'dialog/others/others.dart'
    if (dart.library.io) 'dialog/mobile/mobile.dart'
    if (dart.library.js) 'dialog/others/others.dart'
    if (dart.library.html) 'dialog/others/others.dart';
export 'media/others/others.dart'
    if (dart.library.io) 'media/mobile/mobile.dart'
    if (dart.library.js) 'media/others/others.dart'
    if (dart.library.html) 'media/others/others.dart';

part 'adapter/media_platform_adapter.dart';
