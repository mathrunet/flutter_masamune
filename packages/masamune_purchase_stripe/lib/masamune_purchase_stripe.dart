// Copyright 2022 mathru. All rights reserved.

/// Masamune purchasing framework library with stripe.
///
/// To use, import `package:masamune_purchase_stripe/masamune_purchase_stripe.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_stripe;

import 'dart:async';
import 'dart:collection';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masamune_firebase/masamune_firebase.dart';

export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'adapter/stripe_market_place_adapter.dart';
part 'src/stripe_connect_payment_model.dart';
part 'src/stripe_connect_account_model.dart';
part 'src/stripe_connect_purchase_model.dart';
part 'src/stripe_connect_cancel_exception.dart';
part 'src/stripe_connect_already_registered_exception.dart';
part 'src/stripe_connect_core.dart';
part 'src/stripe_connect_mode.dart';
part 'src/stripe_currency.dart';
part 'src/stripe_connect_webview.dart';
