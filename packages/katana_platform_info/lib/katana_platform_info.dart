// Copyright (c) 2025 mathru. All rights reserved.

/// This allows platform-specific information, such as folder paths and package details, to be retrieved in a testable format.
///
/// To use, import `package:katana_platform_info/katana_platform_info.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Flutter imports:
import "package:flutter/widgets.dart";

// Project imports:
import "package:katana_platform_info/katana_platform_info.dart";

export "adapter/others/others.dart"
    if (dart.library.io) "adapter/others/others.dart"
    if (dart.library.js) "adapter/web/web.dart"
    if (dart.library.html) "adapter/web/web.dart";

part "src/platform_info.dart";
part "src/platform_info_adapter.dart";
part "src/platform_type.dart";

part "adapter/runtime_platform_info_adapter.dart";
