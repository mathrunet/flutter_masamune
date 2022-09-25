// Copyright 2022 mathru. All rights reserved.

/// Package that supports Flutter states and their transitions
/// using the Model Notifier package and the Katana Routing package.
///
/// To use, import `package:masamune/masamune.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune;

import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart'
    hide NumDurationExtensions;
import 'package:katana_module/katana_module.dart';
import 'package:loading_indicator/loading_indicator.dart' as loading_indicator;

import 'property/others/others.dart'
    if (dart.library.io) 'property/mobile/mobile.dart'
    if (dart.library.js) 'property/others/others.dart'
    if (dart.library.html) 'property/others/others.dart';

export 'package:flutter_animate/flutter_animate.dart'
    hide NumDurationExtensions;
export 'package:katana_module/katana_module.dart';
export 'package:url_strategy/url_strategy.dart' show setPathUrlStrategy;

export 'property/others/others.dart'
    if (dart.library.io) 'property/mobile/mobile.dart'
    if (dart.library.js) 'property/others/others.dart'
    if (dart.library.html) 'property/others/others.dart';

part 'adapter/inherited_model_adapter.dart';
part 'adapter/local_model_adapter.dart';
part 'adapter/mock_model_adapter.dart';
part "adapter/mock_sign_in_adapter.dart";
part 'adapter/multi_platform_adapter.dart';
part 'animation/animation_scenario.dart';
part 'animation/animation_scope.dart';
part 'animation/animation_unit.dart';
part 'animation/sequence_animation_builder.dart';
part 'animation/typedef.dart';
part 'animation/animate_repeat.dart';
part 'animation/color_effect.dart';
part 'component/divid.dart';
part 'component/empty.dart';
part 'component/full_screen_builder.dart';
part 'component/indent.dart';
part 'component/loading_builder.dart';
part 'component/space.dart';
part 'component/timer_builder.dart';
part 'component/loading_indicator.dart';
part 'dialog/ui_confirm.dart';
part 'dialog/ui_connect_dialog.dart';
part 'dialog/ui_dialog.dart';
part 'dialog/ui_future.dart';
part 'dialog/ui_modal.dart';
part 'dialog/ui_select_dialog.dart';
part 'inline/inline_app_preview.dart';
part 'inline/inline_page_builder.dart';
part "inline/navigator_controller.dart";
part 'inline/ui_bottom_navigation_bar.dart';
part 'inline/ui_top_navigation_bar.dart';
part 'page/boot_page.dart';
part 'page/empty_page.dart';
part 'page/not_found_page.dart';
part 'property/default_box_decoration.dart';
part 'property/default_button_style.dart';
part 'provider/api_collection_provider.dart';
part 'provider/api_document_provider.dart';
part 'provider/date_time_provider.dart';
part 'provider/focus_node_provider.dart';
part 'provider/global_key_provider.dart';
part 'provider/local_collection_provider.dart';
part 'provider/local_document_provider.dart';
part 'provider/local_searchable_collection_model.dart';
part 'provider/navigator_controller_provider.dart';
part 'provider/page_controller_provider.dart';
part 'provider/runtime_collection_provider.dart';
part 'provider/runtime_document_provider.dart';
part 'provider/runtime_searchable_collection_model.dart';
part 'provider/scroll_controller_provider.dart';
part 'provider/text_editing_controller_provider.dart';
part 'provider/value_notifier_provider.dart';
part 'ref/cache.dart';
part "ref/date_time.dart";
part 'ref/focus_node.dart';
part 'ref/future.dart';
part "ref/global_key.dart";
part "ref/navigator_controller.dart";
part 'ref/on.dart';
part "ref/page_controller.dart";
part "ref/scroll_controller.dart";
part 'ref/state.dart';
part 'ref/text_editing_controller.dart';
part "ref/timer.dart";
part "ref/uuid.dart";
part 'ref/validator.dart';
part "src/extensions.dart";
