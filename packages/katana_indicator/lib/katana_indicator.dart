// Copyright 2023 mathru. All rights reserved.

/// A package to make it easier to use Flutter's indicators (especially when waiting for processing in Future).
///
/// To use, import `package:katana_indicator/katana_indicator.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_indicator;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana/katana.dart';

export 'package:katana/katana.dart';

part 'src/future_indicator.dart';
part 'src/progress_indicator.dart';
