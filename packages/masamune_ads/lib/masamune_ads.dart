// Copyright 2022 mathru. All rights reserved.

/// Masamune advertisement framework library.
///
/// To use, import `package:masamune_ads/masamune_ads.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ads;

import 'package:masamune/masamune.dart';

import 'others/others.dart'
    if (dart.library.io) 'mobile/mobile.dart'
    if (dart.library.js) 'others/others.dart'
    if (dart.library.html) 'others/others.dart';

export 'package:masamune/masamune.dart';

export 'others/others.dart'
    if (dart.library.io) 'mobile/mobile.dart'
    if (dart.library.js) 'others/others.dart'
    if (dart.library.html) 'others/others.dart';

part 'src/ads_size.dart';
part 'src/ui_bottom_banner.dart';

part 'adapter/admob_ads_adapter.dart';
