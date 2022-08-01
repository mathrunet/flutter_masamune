// Copyright 2022 mathru. All rights reserved.

/// The module library of Masamune framework.
///
/// To use, import `package:masamune_module/masamune_module.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_module;

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

import 'masamune_module.dart';

export 'package:masamune/masamune.dart';

export 'component/deprecated/calendar/calendar.dart';
export 'component/deprecated/chat/chat.dart';
export 'component/deprecated/media/gallery.dart';
export 'component/deprecated/questionnaire/questionnaire.dart';
export 'component/detail/detail.dart';
export 'component/edit/edit.dart';
export 'component/home/bottom_tab_home.dart';
export 'component/home/sliver_home.dart';
export 'component/home/tile_menu_home.dart';
export 'component/list/list.dart';
export 'component/login/email_login_and_register.dart';
export 'component/login/sns_login.dart';
export 'component/media/single_media.dart';
export 'component/media/tile_gallery_media.dart';
export 'component/member/member.dart';
export 'component/menu/menu.dart';
export 'component/post/post.dart';
export 'component/tutorial/tutorial.dart';
export 'component/user/user.dart';

part 'src/group_config.dart';
part 'src/login_layout_type.dart';
part 'src/merge_collection_config.dart';
part 'src/post_editing_type.dart';
part 'variable/content_form_config.dart';
part 'variable/content_view_config.dart';
part 'variable/module_variable_config_definition.dart';
