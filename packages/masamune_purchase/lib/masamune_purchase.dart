// Copyright 2022 mathru. All rights reserved.

/// Masamune purchasing framework library.
///
/// To use, import `package:masamune_purchase/masamune_purchase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:masamune/masamune.dart';

export 'package:masamune/masamune.dart';

part 'src/android_verifier_options.dart';
part 'src/deliver_options.dart';
part 'src/ios_verifier_options.dart';
part 'src/client_purchase_delegate.dart';
part 'src/mobile_purchase_options.dart';
part 'src/none_purchase_delegate.dart';
part 'src/purchase_core.dart';
part 'src/purchase_model.dart';
part 'src/mobile_purchase_product.dart';
part 'src/subscribe_options.dart';
part 'src/purchase_delegate.dart';
part 'adapter/mobile_purchase_adapter.dart';
