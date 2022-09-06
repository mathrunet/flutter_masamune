// Copyright 2022 mathru. All rights reserved.

/// Package to use [model_notifier] for Firebase.
///
/// To use, import `package:firebase_model_notifier/firebase_model_notifier.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library firebase_model_notifier;

import 'dart:async';
import "dart:collection";
import 'dart:math';

import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_functions/cloud_functions.dart";
import "package:flutter/material.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:katana_firebase/katana_firebase.dart" as katana show generateCode;
import "package:model_notifier/model_notifier.dart";

export "package:cloud_firestore/cloud_firestore.dart";
export "package:katana_firebase/katana_firebase.dart";
export "package:model_notifier/model_notifier.dart";

part 'firestore/extensions.dart';
part 'firestore/firestore_collection_model.dart';
part 'firestore/firestore_collection_query_mixin.dart';
part 'firestore/firestore_document_meta_mixin.dart';
part 'firestore/firestore_document_model.dart';
part 'firestore/firestore_dynamic_collection_model.dart';
part 'firestore/firestore_dynamic_document_model.dart';
part 'firestore/firestore_dynamic_searchable_collection_model.dart';
part 'firestore/firestore_localize_mixin.dart';
part 'firestore/firestore_query.dart';
part 'firestore/firestore_search_query_mixin.dart';
part 'firestore/firestore_search_updater_mixin.dart';
part 'firestore/firestore_transaction.dart';
part 'firestore/firestore_utility.dart';
part 'functions/firebase_functions_collection_model.dart';
part 'functions/firebase_functions_document_model.dart';
part 'functions/firebase_functions_dynamic_collection_model.dart';
part 'functions/firebase_functions_dynamic_document_model.dart';
part 'functions/firebase_functions_dynamic_model.dart';
part 'functions/firebase_functions_model.dart';
part 'geo/firebase_geo_data.dart';
part 'geo/geo_utility.dart';
part 'geo/point.dart';
part 'src/extensions.dart';
part 'src/functions.dart';
part 'widget/ui_email_and_password_form_dialog.dart';
part 'widget/ui_sms_form_dialog.dart';
