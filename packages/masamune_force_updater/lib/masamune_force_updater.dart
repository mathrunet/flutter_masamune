// Copyright (c) 2024 mathru. All rights reserved.

/// Plug-in for Masamune that provides a forced update function and displays dialogs according to conditions.
///
/// To use, import `package:masamune_force_updater/masamune_force_updater.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_force_updater;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';

part 'adapter/force_updater_masamune_adapter.dart';
part 'src/force_updater.dart';
part 'src/force_updater_item.dart';
