// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Masamune plugin package that contains the base implementation for implementing InAppPurchase and an adapter for mocking.
///
/// To use, import `package:masamune_purchase/masamune_purchase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase;

// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_purchase/models/purchase_subscription.dart";
import "package:masamune_purchase/models/purchase_user.dart";

part "adapter/runtime_purchase_masamune_adapter.dart";

part "actions/android_consumable_purchase_functions_action.dart";
part "actions/ios_consumable_purchase_functions_action.dart";
part "actions/android_nonconsumable_purchase_functions_action.dart";
part "actions/ios_nonconsumable_purchase_functions_action.dart";
part "actions/android_subscription_purchase_functions_action.dart";
part "actions/ios_subscription_purchase_functions_action.dart";

part "src/purchase.dart";
part "src/purchase_product.dart";
part "src/purchase_product_value.dart";
part "src/purchase_product_type.dart";
part "src/purchase_masamune_adapter.dart";
part "src/purchase_functions_action.dart";
part "src/purchase_delegate.dart";
part "src/purchase_subscription_period.dart";
