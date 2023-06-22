// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to implement in-app purchases for GooglePlay and AppStore.
///
/// To use, import `package:masamune_purchase_mobile/masamune_purchase_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_mobile;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_wrapper.dart';
import 'package:masamune/masamune.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:masamune_purchase_mobile/models/purchase_user.dart';

// ignore: depend_on_referenced_packages, implementation_imports
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages

part 'adapter/mobile_purchase_masamune_adapter.dart';

part 'settings/android_consumable_purchase_settings.dart';
part 'settings/ios_consumable_purchase_settings.dart';
part 'settings/android_nonconsumable_purchase_settings.dart';
part 'settings/ios_nonconsumable_purchase_settings.dart';
part 'settings/android_subscription_purchase_settings.dart';
part 'settings/ios_subscription_purchase_settings.dart';

part 'src/purchase.dart';
part 'src/purchase_product.dart';
