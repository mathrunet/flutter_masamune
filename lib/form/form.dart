// Copyright 2021 mathru. All rights reserved.

/// Masamune form plugin framework library.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.form;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:masamune/masamune.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:katana_routing/katana_routing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riverpod/riverpod.dart';

part 'form_item_label.dart';
part 'form_item_checkbox.dart';
part 'form_builder.dart';
part 'form_item.dart';
part 'form_item_chips_field.dart';
part 'form_item_avatar_image.dart';
part 'form_item_builder.dart';
part 'form_item_date_time_field.dart';
part 'form_item_dropdown_field.dart';
part 'form_item_dropdown_button.dart';
part 'form_item_simple_chips.dart';
part 'form_item_dynamic_labeled_dropdown_field.dart';
part 'form_item_headline.dart';
part 'form_item_image.dart';
part 'form_item_labeled_dropdown_field.dart';
part 'form_item_multi_media.dart';
part 'form_item_submit.dart';
part 'form_item_text_field.dart';
part 'form_item_password.dart';
part 'form_item_switch.dart';
part 'ui_page_form.dart';
part 'ui_form_dialog.dart';
part 'ui_page_reauth.dart';
part 'ui_page_change_email.dart';
part 'ui_page_change_password.dart';
part 'form_item_select_builder.dart';
part 'form_item_full_screen.dart';
part 'ui_simple_form_dialog.dart';
part 'suggestion_overlay_builder.dart';
part 'ui_page_form_mixin.dart';
