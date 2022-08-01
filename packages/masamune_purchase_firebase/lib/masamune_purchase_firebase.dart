// Copyright 2022 mathru. All rights reserved.

/// Masamune purchasing framework library with firebase.
///
/// To use, import `package:masamune_purchase_firebase/masamune_purchase_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_purchase_firebase;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
import 'package:masamune_purchase/masamune_purchase.dart';

export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';
export 'package:masamune_purchase/masamune_purchase.dart';

part 'firebase_purchase_delegate.dart';
part 'adapter/firebase_mobile_purchase_adapter.dart';
