// Copyright 2021 mathru. All rights reserved.

/// Package that supports Flutter states and their transitions
/// using the Model Nofifier package and the Katana Routing package.
///
/// To use, import `package:masamune/masamune.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune;

import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:model_notifier/model_notifier.dart';
import 'package:katana_routing/katana_routing.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
export 'package:masamune/form/form.dart';
export 'package:masamune/list/list.dart';
export 'package:katana/katana.dart';
export 'package:katana_routing/katana_routing.dart';
export 'package:model_notifier/model_notifier.dart';
export 'package:riverpod/riverpod.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart';
export 'package:flutter/material.dart' hide Listener;

part "src/extensions.dart";
part "src/asset_type.dart";
part "src/functions.dart";

part "animation/ui_animator_scenario.dart";
part "animation/ui_animator_unit.dart";

part 'widget/dialog/ui_dialog.dart';
part 'widget/dialog/ui_confirm.dart';
part 'widget/dialog/ui_connect_dialog.dart';
part 'widget/dialog/ui_select_dialog.dart';
part 'widget/dialog/ui_future.dart';

part 'widget/component/empty.dart';
part 'widget/component/video.dart';
part 'widget/component/ui_markdown.dart';
part 'widget/component/space.dart';
part 'widget/component/divid.dart';
part 'widget/component/ui_bottom_navigation_bar.dart';

part 'widget/builder/full_screen_builder.dart';
part 'widget/builder/search_builder.dart';
part 'widget/builder/ui_animated_builder.dart';

part 'widget/property/default_box_decoration.dart';
part 'widget/property/network_or_asset.dart';

part 'widget/drawer/account_drawer_header.dart';

part 'widget/mixin/ui_page_scaffold_mixin.dart';
part 'widget/mixin/ui_page_uuid_mixin.dart';

part 'widget/scaffold/tab_scaffold.dart';

part 'template/ui_boot.dart';
