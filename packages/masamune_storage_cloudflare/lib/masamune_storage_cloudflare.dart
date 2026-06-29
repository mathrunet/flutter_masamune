// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plugin package that includes a storage adapter to retrieve data from Cloudflare R2.
///
/// To use, import `package:masamune_storage_cloudflare/masamune_storage_cloudflare.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

export "adapter/others/others.dart"
    if (dart.library.io) "adapter/others/others.dart"
    if (dart.library.js) "adapter/web/web.dart"
    if (dart.library.html) "adapter/web/web.dart";
