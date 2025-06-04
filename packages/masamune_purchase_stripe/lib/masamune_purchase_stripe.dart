// Copyright (c) 2024 mathru. All rights reserved.

/// Masamune framework plugin for billing with Stripe; requires registration with Stripe.
///
/// To use, import `package:masamune_purchase_stripe/masamune_purchase_stripe.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_stripe;

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";

// Project imports:
import "models/stripe_payment.dart";
import "models/stripe_purchase.dart";
import "models/stripe_user.dart";

import "src/others/others.dart"
    if (dart.library.io) "src/others/others.dart"
    if (dart.library.js) "src/web/web.dart"
    if (dart.library.html) "src/web/web.dart";

part "actions/stripe_action_create_account.dart";
part "actions/stripe_action_delete_account.dart";
part "actions/stripe_action_dashboard_account.dart";
part "actions/stripe_action_create_customer_and_payment.dart";
part "actions/stripe_action_set_customer_default_payment.dart";
part "actions/stripe_action_delete_payment.dart";
part "actions/stripe_action_delete_customer.dart";
part "actions/stripe_action_authorization.dart";
part "actions/stripe_action_confirm_authorization.dart";
part "actions/stripe_action_create_purchase.dart";
part "actions/stripe_action_confirm_purchase.dart";
part "actions/stripe_action_capture_purchase.dart";
part "actions/stripe_action_refresh_purchase.dart";
part "actions/stripe_action_cancel_purchase.dart";
part "actions/stripe_action_refund_purchase.dart";
part "actions/stripe_action_create_subscription.dart";
part "actions/stripe_action_delete_subscription.dart";

part "adapter/stripe_purchase_masamune_adapter.dart";

part "src/stripe_account.dart";
part "src/stripe_functions_action.dart";
part "src/stripe_customer.dart";
part "src/stripe_payment.dart";
part "src/stripe_purchase.dart";
part "src/stripe_subscription.dart";
part "src/stripe_authorization.dart";
part "src/stripe_already_registered_exception.dart";
part "src/stripe_cancel_exception.dart";
part "src/stripe_currency.dart";
part "src/stripe_mail.dart";
part "src/stripe_three_d_secure_options.dart";
part "src/stripe_return_path_options.dart";
