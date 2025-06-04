// Copyright (c) 2025 mathru. All rights reserved.

/// Plug-in for sending emails via Sendgrid, Gmail, etc. from servers, etc. using Functions.
///
/// To use, import `package:masamune_mail/masamune_mail.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:masamune/masamune.dart";

part "adapter/mail_masamune_adapter.dart";
part "functions/send_gmail_functions_action.dart";
part "functions/send_grid_functions_action.dart";
