// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune plugin library to implement in-app purchases for GooglePlay and AppStore.
///
/// To use, import `package:masamune_purchase_mobile/masamune_purchase_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_mobile;

export 'package:masamune_purchase/masamune_purchase.dart';

export 'adapter/others/others.dart'
    if (dart.library.io) 'adapter/others/others.dart'
    if (dart.library.js) 'adapter/web/web.dart'
    if (dart.library.html) 'adapter/web/web.dart';
