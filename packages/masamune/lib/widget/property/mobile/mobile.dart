/// For mobile.
library masamune.property.mobile;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: implementation_imports
import 'package:cached_network_image/src/image_provider/cached_network_image_provider.dart'
    as provider;
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart'
    show ImageRenderMethodForWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    as cache_manager;
import 'package:masamune/masamune.dart';

part 'asset.dart';
part "local_file_storage.dart";
