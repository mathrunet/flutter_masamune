// Copyright 2023 mathru. All rights reserved.

/// Package to provide FormController to define the use of forms and FormStyle to unify the look and feel of forms.
///
/// To use, import `package:katana_form/katana_form.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_form;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:katana/katana.dart';

export 'package:katana/katana.dart';

part 'form/form_button.dart';
part 'form/form_date_field.dart';
part 'form/form_text_field.dart';
part 'form/form_num_field.dart';
part 'form/form_label.dart';
part 'form/form_date_time_field.dart';
part 'form/form_enum_field.dart';
part 'form/form_map_field.dart';
part 'src/form_controller.dart';
part 'src/form_stye.dart';
