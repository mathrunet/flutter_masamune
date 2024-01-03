// Copyright (c) 2024 mathru. All rights reserved.

/// Firebase plugin for katana_storage. A package to facilitate switching between Local and Firebase storage implementations.
///
/// To use, import `package:katana_storage_firebase/katana_storage_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_storage_firebase;

export 'package:katana_storage/katana_storage.dart';

export 'adapter/others/others.dart'
    if (dart.library.io) 'adapter/others/others.dart'
    if (dart.library.js) 'adapter/web/web.dart'
    if (dart.library.html) 'adapter/web/web.dart';
