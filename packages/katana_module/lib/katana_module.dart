// Copyright 2022 mathru. All rights reserved.

/// Package that defines a base class for modularization.
///
/// To use, import `package:katana_module/katana_module.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_module;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katana_routing/katana_routing.dart';
import 'package:model_notifier/model_notifier.dart';

export 'package:katana_routing/katana_routing.dart';
export 'package:model_notifier/model_notifier.dart';

part 'src/adapter/ads_adapter.dart';
part 'src/adapter/analytics_adapter.dart';
part 'src/adapter/dynamic_links_adapter.dart';
part 'src/adapter/function_adapter.dart';
part 'src/adapter/location_adapter.dart';
part 'src/adapter/market_place_adapter.dart';
part 'src/adapter/messaging_adapter.dart';
part 'src/page_config.dart';
part 'src/adapter/model_adapter.dart';
part "src/adapter/platform_adapter.dart";
part "src/adapter/purchase_adapter.dart";
part 'src/adapter/sign_in_adapter.dart';
part 'src/adapter/streaming_adapter.dart';
part 'src/adapter_module.dart';
part "src/app_module.dart";
part "src/boot_config.dart";
part 'src/condition_module.dart';
part "src/extensions.dart";
part 'src/filter_query.dart';
part "src/group_module.dart";
part "src/local_media.dart";
part 'src/market_place_product.dart';
part 'src/menu_config.dart';
part 'src/messaging_value.dart';
part "src/module.dart";
part 'src/module_hook.dart';
part 'src/module_value_widget.dart';
part 'src/module_widget.dart';
part "src/page_module.dart";
part 'src/page_module_widget.dart';
part 'src/purchase_product.dart';
part 'src/reroute/login_required_reroute_config.dart';
part 'src/reroute/registration_required_reroute_config.dart';
part 'src/reroute/role_reroute_config.dart';
part 'src/reroute/user_document_query_reroute_config.dart';
part 'src/reroute_config.dart';
part 'src/page_reroute_widget.dart';
part 'src/reroute_module.dart';
part 'src/route_module.dart';
part 'src/tags/collection_module_tag.dart';
part 'src/tags/context_module_tag.dart';
part 'src/tags/document_module_tag.dart';
part 'src/tags/extensions.dart';
part 'src/tags/module_tag.dart';
part 'src/tags/user_module_tag.dart';
part 'src/template_module.dart';
part 'src/text_input_formatter_config.dart';
part "src/ui_module_material_app.dart";
part 'src/value_widget.dart';
part 'src/variable/extensions.dart';
part 'src/variable/variable_config.dart';
part 'src/variable/variable_form_config.dart';
part 'src/variable/variable_view_config.dart';
