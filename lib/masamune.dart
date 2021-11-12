// Copyright 2021 mathru. All rights reserved.

/// Package that supports Flutter states and their transitions
/// using the Model Notifier package and the Katana Routing package.
///
/// To use, import `package:masamune/masamune.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune;

import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:katana_module/katana_module.dart';
import 'package:katana_routing/katana_routing.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:masamune/list/list.dart';
import 'package:model_notifier/model_notifier.dart';
// ignore: library_prefixes
import 'package:wordpress_api/wordpress_api.dart' as WordPress;

import 'widget/component/others/others.dart'
    if (dart.library.io) 'widget/component/mobile/mobile.dart'
    if (dart.library.js) 'widget/component/others/others.dart'
    if (dart.library.html) 'widget/component/others/others.dart';
import 'widget/dialog/others/others.dart'
    if (dart.library.io) 'widget/dialog/mobile/mobile.dart'
    if (dart.library.js) 'widget/dialog/others/others.dart'
    if (dart.library.html) 'widget/dialog/others/others.dart';
import 'widget/property/others/others.dart'
    if (dart.library.io) 'widget/property/mobile/mobile.dart'
    if (dart.library.js) 'widget/property/others/others.dart'
    if (dart.library.html) 'widget/property/others/others.dart';

export 'package:flutter/material.dart' hide Listener;
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:katana/katana.dart';
export 'package:katana_module/katana_module.dart';
export 'package:katana_routing/katana_routing.dart';
export 'package:masamune/form/form.dart';
export 'package:masamune/list/list.dart';
export 'package:masamune/ui/ui.dart';
export 'package:model_notifier/model_notifier.dart';
export 'package:responsive_grid/responsive_grid.dart';
export 'package:riverpod/riverpod.dart';
export 'package:url_strategy/url_strategy.dart';

export 'calendar/ui_calendar.dart';
export 'media/others/others.dart'
    if (dart.library.io) 'media/mobile/mobile.dart'
    if (dart.library.js) 'media/others/others.dart'
    if (dart.library.html) 'media/others/others.dart';
export 'widget/component/others/others.dart'
    if (dart.library.io) 'widget/component/mobile/mobile.dart'
    if (dart.library.js) 'widget/component/others/others.dart'
    if (dart.library.html) 'widget/component/others/others.dart';
export 'widget/dialog/others/others.dart'
    if (dart.library.io) 'widget/dialog/mobile/mobile.dart'
    if (dart.library.js) 'widget/dialog/others/others.dart'
    if (dart.library.html) 'widget/dialog/others/others.dart';
export 'widget/property/others/others.dart'
    if (dart.library.io) 'widget/property/mobile/mobile.dart'
    if (dart.library.js) 'widget/property/others/others.dart'
    if (dart.library.html) 'widget/property/others/others.dart';

part 'adapter/inherited_model_adapter.dart';
part 'adapter/local_model_adapter.dart';
part 'adapter/mock_model_adapter.dart';
part "adapter/multi_platform_adapter.dart";
part 'animation/animation_scenario.dart';
part 'animation/animation_unit.dart';
part 'animation/typedef.dart';
part 'hooks/focus_node.dart';
part "hooks/date_time.dart";
part "hooks/global_key.dart";
part "hooks/navigator_controller.dart";
part 'hooks/text_editing_controller.dart';
part "hooks/uuid.dart";
part 'hooks/memoized.dart';
part "hooks/value_notifier.dart";
part "hooks/effect.dart";
part "hooks/scroll_controller.dart";
part "model/wordpress_collection_model.dart";
part "provider/date_time.dart";
part "provider/global_key.dart";
part "src/asset_type.dart";
part "src/extensions.dart";
part "src/functions.dart";
part 'template/ui_boot.dart';
part 'widget/builder/animation_scope.dart';
part 'widget/builder/full_screen_builder.dart';
part 'widget/builder/inline_page_builder.dart';
part 'widget/builder/loading_builder.dart';
part 'widget/builder/search_builder.dart';
part 'widget/component/clickable_box.dart';
part 'widget/component/cms_layout.dart';
part 'widget/component/divid.dart';
part 'widget/component/empty.dart';
part 'widget/component/inline_app_preview.dart';
part 'widget/component/space.dart';
part 'widget/component/ui_bottom_navigation_bar.dart';
part 'widget/component/ui_markdown.dart';
part 'widget/component/ui_top_navigation_bar.dart';
part 'widget/component/search_bar.dart';
part 'widget/dialog/ui_confirm.dart';
part 'widget/dialog/ui_modal.dart';
part 'widget/dialog/ui_connect_dialog.dart';
part 'widget/dialog/ui_dialog.dart';
part 'widget/dialog/ui_future.dart';
part 'widget/dialog/ui_select_dialog.dart';
part 'widget/drawer/account_drawer_header.dart';
part 'widget/page/empty_page.dart';
part "widget/platform/platform_app_bar.dart";
part "widget/platform/platform_app_layout.dart";
part "widget/platform/platform_builder.dart";
part "widget/platform/platform_inline_app_bar.dart";
part "widget/platform/platform_modal_view.dart";
part "widget/platform/platform_scrollbar.dart";
part 'widget/property/default_box_decoration.dart';
part 'widget/property/default_text_button_style.dart';
part 'widget/scaffold/tab_scaffold.dart';
