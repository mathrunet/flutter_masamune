// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library to implement in-app purchases for GooglePlay and AppStore.
///
/// To use, import `package:masamune_purchase_mobile/masamune_purchase_mobile.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_mobile;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_wrapper.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_purchase_mobile/models/purchase_user.dart';
import 'package:universal_platform/universal_platform.dart';

part 'adapter/mobile_purchase_masamune_adapter.dart';

part 'settings/android_consumable_purchase_settings.dart';
part 'settings/ios_consumable_purchase_settings.dart';
part 'settings/android_nonconsumable_purchase_settings.dart';
part 'settings/ios_nonconsumable_purchase_settings.dart';
part 'settings/android_subscription_purchase_settings.dart';
part 'settings/ios_subscription_purchase_settings.dart';

part 'src/purchase.dart';
part 'src/purchase_product.dart';
