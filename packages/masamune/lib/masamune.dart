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

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
export 'package:katana_model/katana_model.dart';
export 'package:katana_model_local/katana_model_local.dart';
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
part 'model/extension.dart';
part 'prefs/prefs.dart';
part 'scoped/controller.dart';
part 'scoped/global.dart';
part 'router/router.dart';
part 'src/masamune_app.dart';
part 'src/masamune_adapter.dart';
part 'src/masamune_controller.dart';

part 'ui/grid_builder.dart';
part 'ui/list_builder.dart';
part 'ui/reorderable_list_builder.dart';
