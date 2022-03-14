// Copyright 2022 mathru. All rights reserved.

/// Masamune form plugin framework library.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.form;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:masamune/masamune.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

export 'others/others.dart'
    if (dart.library.io) 'mobile/mobile.dart'
    if (dart.library.js) 'others/others.dart'
    if (dart.library.html) 'others/others.dart';

part 'change_email_form.dart';
part 'change_password_form.dart';
part 'extensions.dart';
part 'form_builder.dart';
part 'form_context.dart';
part 'form_item.dart';
part 'form_item_avatar_image.dart';
part 'form_item_builder.dart';
part 'form_item_checkbox.dart';
part 'form_item_chips_field.dart';
part 'form_item_comment_field.dart';
part 'form_item_date_time_field.dart';
part 'form_item_dropdown_button.dart';
part 'form_item_dropdown_field.dart';
part 'form_item_duration_field.dart';
part 'form_item_dynamic_labeled_dropdown_field.dart';
part 'form_item_full_screen.dart';
part 'form_item_headline.dart';
part 'form_item_label.dart';
part 'form_item_labeled_dropdown_field.dart';
part 'form_item_multiple_checkbox.dart';
part 'form_item_multiple_dropdown_field.dart';
part 'form_item_multiple_full_screen.dart';
part 'form_item_multiple_text_field.dart';
part 'form_item_password.dart';
part 'form_item_rating.dart';
part 'form_item_select_builder.dart';
part 'form_item_simple_chips.dart';
part 'form_item_slider.dart';
part 'form_item_submit.dart';
part 'form_item_switch.dart';
part 'form_item_text_field.dart';
part 'reauth_form.dart';
part 'suggestion_overlay_builder.dart';
part 'ui_form_dialog.dart';
part 'ui_page_change_email.dart';
part 'ui_page_change_password.dart';
part 'ui_page_change_reauth.dart';
part 'ui_simple_form_dialog.dart';
