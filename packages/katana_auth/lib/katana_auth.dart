// Copyright (c) 2025 mathru. All rights reserved.

/// Base package to facilitate switching between Local and Firebase authentication implementations.
///
/// To use, import `package:katana_auth/katana_auth.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_logger/katana_logger.dart";

import "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

export "package:katana/katana.dart";
export "package:katana_logger/katana_logger.dart";
export "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

part "adapter/runtime_auth_adapter.dart";
part "adapter/local_auth_adapter.dart";

part "provider/direct_auth_query.dart";
part "provider/anonymously_auth_query.dart";
part "provider/email_and_password_auth_query.dart";
part "provider/email_link_auth_query.dart";
part "provider/sms_auth_query.dart";
part "provider/sns_sign_in_auth_provider.dart";

part "src/auth_adapter.dart";
part "src/authentication.dart";
part "src/auth_provider.dart";
part "src/auth_database.dart";
part "src/auth_credential.dart";
part "src/auth_logger_event.dart";
part "src/auth_action.dart";
