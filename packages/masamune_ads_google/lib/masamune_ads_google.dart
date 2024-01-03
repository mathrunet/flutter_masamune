// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin package for GoogleAd. Plug-in package for displaying interstitial, native, and reward ads.
///
/// To use, import `package:masamune_ads_google/masamune_ads_google.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ads_google;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:masamune/masamune.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/google_ads_masamune_adapter.dart';
