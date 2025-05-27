// Copyright (c) 2024 mathru. All rights reserved.

/// Package to provide FormController to define the use of forms and FormStyle to unify the look and feel of forms.
///
/// To use, import `package:katana_form/katana_form.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_form;

// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:katana/katana.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:universal_platform/universal_platform.dart';

export 'package:katana/katana.dart';

part 'form/form_button.dart';
part 'form/form_date_field.dart';
part 'form/form_switch.dart';
part 'form/form_month_field.dart';
part 'form/form_text_field.dart';
part 'form/form_num_field.dart';
part 'form/form_label.dart';
part 'form/form_date_time_field.dart';
part 'form/form_date_time_range_field.dart';
part 'form/form_enum_modal_field.dart';
part 'form/form_map_modal_field.dart';
part 'form/form_media.dart';
part 'form/form_multi_media.dart';
part 'form/form_future_field.dart';
part 'form/form_chips_field.dart';
part 'form/form_checkbox.dart';
part 'form/form_enum_dropdown_field.dart';
part 'form/form_map_dropdown_field.dart';
part 'form/form_rating_bar.dart';
part 'form/form_pin_field.dart';
part 'form/form_list_builder.dart';
part 'form/form_builder.dart';
part 'form/form_duration_field.dart';
part 'form/form_password_builder.dart';
part 'form/form_editable_toggle_builder.dart';
part 'form/form_text_editing_controller_builder.dart';
part 'form/form_focus_node_builder.dart';
part 'form/form_style_container.dart';
part 'form/form_map_tag_dropdown_field.dart';

part 'src/form_controller.dart';
part 'src/form_media_value.dart';
part 'src/form_stye.dart';
part 'src/form_media_type.dart';
part 'src/suggestion_style.dart';
part 'src/picker/picker.dart';
part 'src/picker/picker_localizations.dart';
