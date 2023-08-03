// Copyright 2023 mathru. All rights reserved.

/// This Masamune plugin module provides a point-based monetization structure for your app.
///
/// To use, import `package:masamune_point_ecosystem/masamune_point_ecosystem.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_point_ecosystem;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_ads_google/masamune_ads_google.dart';
import 'package:masamune_purchase_mobile/masamune_purchase_mobile.dart';
import 'package:masamune_purchase_mobile/models/purchase_user.dart';

// Project imports:
import 'package:masamune_point_ecosystem/models/point_ecosystem_user.dart';

part 'adapter/point_ecosystem_masamune_adapter.dart';
part 'src/point_ecosystem.dart';
