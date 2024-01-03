// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

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
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_purchase_mobile/models/purchase_subscription.dart';
import 'package:masamune_purchase_mobile/models/purchase_user.dart';

export 'adapter/others/others.dart'
    if (dart.library.io) 'adapter/others/others.dart'
    if (dart.library.js) 'adapter/web/web.dart'
    if (dart.library.html) 'adapter/web/web.dart';

part 'adapter/runtime_purchase_masamune_adapter.dart';

part 'actions/android_consumable_purchase_functions_action.dart';
part 'actions/ios_consumable_purchase_functions_action.dart';
part 'actions/android_nonconsumable_purchase_functions_action.dart';
part 'actions/ios_nonconsumable_purchase_functions_action.dart';
part 'actions/android_subscription_purchase_functions_action.dart';
part 'actions/ios_subscription_purchase_functions_action.dart';

part 'src/purchase.dart';
part 'src/purchase_product.dart';
part 'src/purchase_product_value.dart';
part 'src/purchase_product_type.dart';
part 'src/purchase_masamune_adapter.dart';
part 'src/purchase_functions_action.dart';
