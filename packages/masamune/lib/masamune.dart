// Copyright 2023 mathru. All rights reserved.

/// An application development framework centered on automatic code generation using build_runner.
///
/// To use, import `package:masamune/masamune.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune;

// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:masamune/masamune.dart';

export 'package:katana/katana.dart';
export 'package:katana_auth/katana_auth.dart';
export 'package:katana_form/katana_form.dart';
export 'package:katana_functions/katana_functions.dart';
export 'package:katana_indicator/katana_indicator.dart';
export 'package:katana_listenables/katana_listenables.dart';
export 'package:katana_localization/katana_localization.dart';
export 'package:katana_logger/katana_logger.dart';
export 'package:katana_responsive/katana_responsive.dart';
export 'package:katana_model/katana_model.dart';
export 'package:katana_prefs/katana_prefs.dart';
export 'package:katana_router/katana_router.dart';
export 'package:katana_scoped/katana_scoped.dart';
export 'package:katana_shorten/katana_shorten.dart';
export 'package:katana_storage/katana_storage.dart';
export 'package:katana_theme/katana_theme.dart';
export 'package:katana_ui/katana_ui.dart';
export 'package:masamune_annotation/masamune_annotation.dart';
export 'package:meta/meta.dart' show useResult;

part 'form/form_scoped_widget.dart';
part 'model/model.dart';
part 'prefs/prefs.dart';
part 'scoped/controller.dart';
part 'scoped/global.dart';
part 'src/masamune_app.dart';
part 'src/masamune_adapter.dart';
part 'src/masamune_controller.dart';

part 'ui/grid_builder.dart';
part 'ui/list_builder.dart';
part 'ui/reorderable_list_builder.dart';

part 'universal/universal_scope.dart';
part 'universal/universal_scaffold.dart';
part 'universal/universal_app_bar.dart';
part 'universal/universal_list_view.dart';
part 'universal/universal_grid_view.dart';
part 'universal/universal_list_builder.dart';
part 'universal/universal_grid_builder.dart';
part 'universal/universal_container.dart';
