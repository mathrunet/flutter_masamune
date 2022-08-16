// // ignore_for_file: implementation_imports

// import 'dart:convert';

// import 'package:flutter_quill/src/models/documents/document.dart';
// import 'package:flutter_quill/src/widgets/controller.dart';
// import 'package:flutter_quill/src/widgets/default_styles.dart';
// import 'package:flutter_quill/src/widgets/editor.dart';
// import 'package:flutter_quill/src/widgets/toolbar.dart';
// import 'package:masamune_module/masamune_module.dart';
// import 'package:tuple/tuple.dart';

// const _kQuillToolbarHeight = 80;

// enum CalendarEditingType { planeText, wysiwyg }

// @immutable
// @deprecated
// class CalendarModule extends PageModule with VerifyAppReroutePageModuleMixin {
//   const CalendarModule({
//     bool enabled = true,
//     String? title = "",
//     this.routePath = "calendar",
//     this.queryPath = "event",
//     this.userPath = "user",
//     this.commentPath = "comment",
//     this.commentTemplatePath = "commentTemplate",
//     this.nameKey = Const.name,
//     this.userKey = Const.user,
//     this.textKey = Const.text,
//     this.typeKey = Const.type,
//     this.imageKey = Const.media,
//     this.createdTimeKey = Const.createdTime,
//     this.modifiedTimeKey = Const.modifiedTime,
//     this.startTimeKey = Const.startTime,
//     this.endTimeKey = Const.endTime,
//     this.allDayKey = "allDay",
//     this.detailLabel = "Detail",
//     this.noteLabel = "Note",
//     this.commentLabel = "Comment",
//     this.noteKey = "note",
//     this.enableNote = false,
//     this.editingType = CalendarEditingType.planeText,
//     this.markerType = UICalendarMarkerType.count,
//     this.sliverLayoutWhenModernDesignOnHome = true,
//     this.automaticallyImplyLeadingOnHome = true,
//     this.showAddingButton = true,
//     this.markerIcon,
//     this.initialCommentTemplate = const [],
//     List<RerouteConfig> rerouteConfigs = const [],
//     this.homePage = const CalendarModuleHome(),
//     this.dayViewPage = const CalendarModuleDayView(),
//     this.detailPage = const CalendarModuleDetail(),
//     this.templatePage = const CalendarModuleTemplate(),
//     this.editPage = const CalendarModuleEdit(),
//   }) : super(
//           enabled: enabled,
//           title: title,
//           rerouteConfigs: rerouteConfigs,
//         );

//   @override
//   Map<String, RouteConfig> get routeSettings {
//     if (!enabled) {
//       return const {};
//     }
//     final route = {
//       "/$routePath": RouteConfig((_) => homePage),
//       "/$routePath/templates": RouteConfig((_) => templatePage),
//       "/$routePath/edit": RouteConfig((_) => editPage),
//       "/$routePath/edit/{date_id}": RouteConfig((_) => editPage),
//       "/$routePath/empty": RouteConfig((_) => const EmptyPage()),
//       "/$routePath/{date_id}": RouteConfig((_) => dayViewPage),
//       "/$routePath/{event_id}/detail": RouteConfig((_) => detailPage),
//       "/$routePath/{event_id}/edit": RouteConfig((_) => editPage),
//     };
//     return route;
//   }

//   // ページ設定
//   final PageModuleWidget<CalendarModule> homePage;
//   final PageModuleWidget<CalendarModule> dayViewPage;
//   final PageModuleWidget<CalendarModule> templatePage;
//   final PageModuleWidget<CalendarModule> detailPage;
//   final PageModuleWidget<CalendarModule> editPage;

//   /// ホームをスライバーレイアウトにする場合True.
//   final bool sliverLayoutWhenModernDesignOnHome;

//   /// ホームのときのバックボタンを削除するかどうか。
//   final bool automaticallyImplyLeadingOnHome;

//   /// ルートのパス。
//   @override
//   // ignore: overridden_fields
//   final String routePath;

//   /// イベントデータのパス。
//   @override
//   // ignore: overridden_fields
//   final String queryPath;

//   /// ユーザーのデータパス。
//   final String userPath;

//   /// コメントデータへのパス。
//   final String commentPath;

//   /// コメントテンプレートへのパス。
//   final String commentTemplatePath;

//   /// タイトルのキー。
//   final String nameKey;

//   /// ユーザーのキー。
//   final String userKey;

//   /// テキストのキー。
//   final String textKey;

//   /// 画像のキー。
//   final String imageKey;

//   /// チャットタイプのキー。
//   final String typeKey;

//   /// 作成日のキー。
//   final String createdTimeKey;

//   /// 更新日のキー。
//   final String modifiedTimeKey;

//   /// 開始時間のキー。
//   final String startTimeKey;

//   /// 終了時間のキー。
//   final String endTimeKey;

//   /// 終日フラグのキー。
//   final String allDayKey;

//   /// 詳細のラベル。
//   final String detailLabel;

//   /// ノートのラベル。
//   final String noteLabel;

//   /// ノートのキー。
//   final String noteKey;

//   /// カレンダーのノートを記載する場合True.
//   final bool enableNote;

//   /// コメントのラベル。
//   final String commentLabel;

//   /// カレンダーのマーカータイプ。
//   final UICalendarMarkerType markerType;

//   /// マーカーアイコン。
//   final Widget? markerIcon;

//   /// エディターのタイプ。
//   final CalendarEditingType editingType;

//   /// コメントテンプレートの設定。
//   final List<String> initialCommentTemplate;

//   /// 追加ボタンを表示する場合True.
//   final bool showAddingButton;
// }

// class CalendarModuleHome extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleHome();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final selected = ref.state("selected", DateTime.now());
//     final events = ref.watchCollectionModel(module.queryPath);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Calendar".localize()),
//         sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
//         automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
//       ),
//       body: UICalendar(
//         markerType: module.markerType,
//         markerIcon: module.markerIcon ?? const Icon(Icons.access_alarm),
//         events: events,
//         expand: true,
//         onDaySelect: (day, events, holidays) {
//           selected.value = day;
//           context.rootNavigator.pushNamed(
//             "/${module.routePath}/${day.toDateID()}",
//             arguments: RouteQuery.fullscreenOrModal,
//           );
//         },
//       ),
//       floatingActionButton: module.showAddingButton
//           ? FloatingActionButton.extended(
//               label: Text("Add".localize()),
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 final dateId = selected.value
//                     .combine(TimeOfDay.now())
//                     .round(const Duration(minutes: 15))
//                     .toDateTimeID();
//                 context.navigator.pushNamed(
//                   "/${module.routePath}/edit/$dateId}",
//                   arguments: RouteQuery.fullscreen,
//                 );
//               },
//             )
//           : null,
//     );
//   }
// }

// class CalendarModuleDayView extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleDayView();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final now = ref.useNow();
//     final date = context.get("date_id", now.toDateID()).toDateTime();
//     final startTime = date;
//     final endTime = date.add(const Duration(days: 1));

//     final events = ref
//         .watchCollectionModel(module.queryPath)
//         .where(
//           (element) => _inEvent(
//             sourceStartTime: element.get(module.startTimeKey, 0),
//             sourceEndTime: element.get<int?>(module.endTimeKey, null),
//             targetStartTime: startTime.millisecondsSinceEpoch,
//             targetEndTime: endTime.millisecondsSinceEpoch,
//           ),
//         )
//         .toList();

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(date.format("yyyy/MM/dd")),
//       ),
//       body: UIDayCalendar(
//         day: date,
//         source: events,
//         builder: (context, item) {
//           return InkWell(
//             onTap: () {
//               context.navigator.pushNamed(
//                 "/${module.routePath}/${item.uid}/detail",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//               decoration: DefaultBoxDecoration(
//                 color: context.theme.dividerColor,
//                 width: 1,
//                 backgroundColor: context.theme.primaryColor,
//                 radius: 8.0,
//               ),
//               child: Text(
//                 item.get(module.nameKey, ""),
//                 style: TextStyle(color: context.theme.textColorOnPrimary),
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: module.showAddingButton
//           ? FloatingActionButton.extended(
//               label: Text("Add".localize()),
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 final dateId = date
//                     .combine(TimeOfDay.now())
//                     .round(const Duration(minutes: 15))
//                     .toDateTimeID();
//                 context.navigator.pushNamed(
//                   "/${module.routePath}/edit/$dateId",
//                   arguments: RouteQuery.fullscreen,
//                 );
//               },
//             )
//           : null,
//     );
//   }
// }

// class CalendarModuleDetail extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleDetail();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final event = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("event_id", "")}",
//     );
//     final author = ref.watchDocumentModel(
//       "${module.userPath}/${event.get(module.userKey, uuid)}",
//     );
//     final name = event.get(module.nameKey, "");
//     final text = event.get(module.textKey, "");
//     final noteValue = event.get(module.noteKey, "");
//     final note = noteValue.isEmpty
//         ? "No %s".localize().format([module.noteLabel.localize()])
//         : noteValue;
//     final allDay = event.get(module.allDayKey, false);
//     final startTime = event.getAsDateTime(module.startTimeKey);
//     final authorName = author.get(module.nameKey, "");
//     final endTimeValue = event.get<int?>(module.endTimeKey, null);
//     final endTime = endTimeValue != null
//         ? DateTime.fromMillisecondsSinceEpoch(endTimeValue)
//         : null;
//     final userId = context.model?.userId;
//     final commentController = ref.useTextEditingController("comment");

//     final _comments = ref.watchCollectionModel(
//       ModelQuery(
//         "${module.queryPath}/${context.get("event_id", "")}/${module.commentPath}",
//         order: ModelQueryOrder.desc,
//         orderBy: Const.time,
//       ).value,
//     );
//     final comments = _comments.mergeUserInformation(
//       ref,
//       userCollectionPath: module.userPath,
//       userKey: module.userKey,
//     );

//     final editingType = note.isNotEmpty && !note.startsWith(RegExp(r"^(\[|\{)"))
//         ? CalendarEditingType.planeText
//         : module.editingType;

//     final appBar = UIAppBar(
//       title: Text(name),
//       subtitle: Text(
//         _timeString(
//           startTime: startTime,
//           endTime: endTime,
//           allDay: allDay,
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () {
//             context.rootNavigator.pushNamed(
//               "/${module.routePath}/${context.get("event_id", "")}/edit",
//               arguments: RouteQuery.fullscreenOrModal,
//             );
//           },
//         )
//       ],
//     );

//     final header = [
//       const Space.height(16),
//       ListItem(
//         title: Text("DateTime".localize()),
//         text: Text(
//           _timeString(
//             startTime: startTime,
//             endTime: endTime,
//             allDay: allDay,
//           ),
//         ),
//       ),
//       if (authorName.isNotEmpty)
//         ListItem(
//           title: Text("Author".localize()),
//           text: Text(authorName),
//         ),
//       const Space.height(16),
//       DividHeadline(module.detailLabel.localize()),
//       const Space.height(16),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: UIMarkdown(
//           text,
//           fontSize: 16,
//           onTapLink: (url) {
//             ref.open(url);
//           },
//         ),
//       ),
//     ];

//     final footer = [
//       const Space.height(24),
//       DividHeadline(module.commentLabel.localize()),
//       FormItemCommentField(
//         maxLines: 4,
//         controller: commentController,
//         hintText: "Input %s".localize().format(["Comment".localize()]),
//         onSubmitted: (value) {
//           if (value.isEmpty) {
//             return;
//           }

//           final doc = context.model?.createDocument(_comments);
//           if (doc == null) {
//             return;
//           }
//           doc[Const.user] = userId;
//           doc[module.textKey] = value;
//           context.model?.saveDocument(doc);
//         },
//         onTapTemplateIcon: () async {
//           final res = await context.rootNavigator.pushNamed(
//             "/${module.routePath}/templates",
//             arguments: RouteQuery.fullscreenOrModal,
//           );
//           if (res is! String || res.isEmpty) {
//             return;
//           }
//           commentController.text = res;
//         },
//       ),
//       const Divid(),
//       const Space.height(16),
//     ];

//     if (!module.enableNote) {
//       return UIScaffold(
//         waitTransition: true,
//         appBar: appBar,
//         body: UIListView(
//           children: [
//             ...header,
//             ...footer,
//             ...comments.mapListenable((item) {
//               return CommentTile(
//                 avatar: Asset.image(
//                   item.get("${Const.user}${module.imageKey}", ""),
//                 ),
//                 name: item.get("${Const.user}${module.nameKey}", ""),
//                 date: item.getAsDateTime(Const.time),
//                 text: item.get(module.textKey, ""),
//               );
//             }),
//             const Space.height(24),
//           ],
//         ),
//       );
//     }

//     switch (editingType) {
//       case CalendarEditingType.wysiwyg:
//         final controller = ref.cache(
//           "controller",
//           () => note.isEmpty
//               ? QuillController.basic()
//               : QuillController(
//                   document: Document.fromJson(jsonDecode(note)),
//                   selection: const TextSelection.collapsed(offset: 0),
//                 ),
//           keys: [note],
//         );

//         return UIScaffold(
//           waitTransition: true,
//           appBar: appBar,
//           body: UIListView(
//             children: [
//               ...header,
//               const Space.height(16),
//               DividHeadline(module.noteLabel.localize()),
//               const Space.height(16),
//               QuillEditor(
//                 scrollController: ScrollController(),
//                 scrollable: false,
//                 focusNode: ref.useFocusNode("note", false),
//                 autoFocus: false,
//                 controller: controller,
//                 placeholder: module.noteLabel.localize(),
//                 readOnly: true,
//                 expands: false,
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 customStyles: DefaultStyles(
//                   placeHolder: DefaultTextBlockStyle(
//                     TextStyle(
//                       color: context.theme.disabledColor,
//                       fontSize: 16,
//                     ),
//                     const Tuple2(16, 0),
//                     const Tuple2(0, 0),
//                     null,
//                   ),
//                 ),
//               ),
//               ...footer,
//               ...comments.mapListenable((item) {
//                 return CommentTile(
//                   avatar: Asset.image(
//                     item.get("${Const.user}${module.imageKey}", ""),
//                   ),
//                   name: item.get("${Const.user}${module.nameKey}", ""),
//                   date: item.getAsDateTime(Const.time),
//                   text: item.get(module.textKey, ""),
//                 );
//               }),
//               const Space.height(24),
//             ],
//           ),
//         );
//       default:
//         return UIScaffold(
//           waitTransition: true,
//           appBar: appBar,
//           body: UIListView(
//             children: [
//               ...header,
//               const Space.height(16),
//               DividHeadline(module.noteLabel.localize()),
//               const Space.height(16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: UIMarkdown(
//                   note,
//                   fontSize: 16,
//                   onTapLink: (url) {
//                     ref.open(url);
//                   },
//                 ),
//               ),
//               ...footer,
//               ...comments.mapListenable((item) {
//                 return CommentTile(
//                   avatar: Asset.image(
//                     item.get("${Const.user}${module.imageKey}", ""),
//                   ),
//                   name: item.get("${Const.user}${module.nameKey}", ""),
//                   date: item.getAsDateTime(Const.time),
//                   text: item.get(module.textKey, ""),
//                 );
//               }),
//               const Space.height(24),
//             ],
//           ),
//         );
//     }
//   }
// }

// class CalendarModuleTemplate extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleTemplate();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final template = ref.watchCollectionModel(
//       "${module.userPath}/${context.model?.userId}/${module.commentTemplatePath}",
//     );

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(title: Text("Template".localize())),
//       body: UIListBuilder<String>(
//         source: [
//           ...module.initialCommentTemplate,
//           ...template.mapAndRemoveEmpty(
//             (item) => item.get<String?>(module.textKey, null),
//           )
//         ],
//         bottom: [
//           ListTextField(
//             label: "Add".localize(),
//             onSubmitted: (value) async {
//               if (value.isEmpty) {
//                 return;
//               }
//               try {
//                 final doc = context.model?.createDocument(template);
//                 if (doc == null) {
//                   return;
//                 }
//                 doc[module.textKey] = value;
//                 await context.model?.saveDocument(doc).showIndicator(context);
//               } catch (e) {
//                 UIDialog.show(
//                   context,
//                   title: "Error".localize(),
//                   text: "%s is not completed."
//                       .localize()
//                       .format(["Editing".localize()]),
//                 );
//               }
//             },
//           ),
//         ],
//         builder: (context, item, index) {
//           return [
//             ListItem(
//               title: Text(item),
//               trailing: module.initialCommentTemplate.contains(item)
//                   ? null
//                   : IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () async {
//                         try {
//                           final tmp = template.firstWhereOrNull(
//                             (e) => e.get(module.textKey, "") == item,
//                           );
//                           if (tmp == null) {
//                             return;
//                           }
//                           await context.model
//                               ?.deleteDocument(tmp)
//                               .showIndicator(context);
//                         } catch (e) {
//                           UIDialog.show(
//                             context,
//                             title: "Error".localize(),
//                             text: "%s is not completed."
//                                 .localize()
//                                 .format(["Editing".localize()]),
//                           );
//                         }
//                       },
//                     ),
//               onTap: () {
//                 context.navigator.pop(item);
//               },
//             ),
//           ];
//         },
//       ),
//     );
//   }
// }

// class CalendarModuleEdit extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleEdit();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final date = context.get<String?>("date_id", null)?.toDateTime();
//     final now = ref.useDateTime("now", date ?? DateTime.now());
//     final form = ref.useForm("event_id");
//     final user = ref.watchUserDocumentModel(module.userPath);
//     final item = ref.watchDocumentModel("${module.queryPath}/${form.uid}");
//     final name = item.get(module.nameKey, "");
//     final text = item.get(module.textKey, "");
//     final note = item.get(module.noteKey, "");
//     final startTime = item.getAsDateTime(module.startTimeKey, now);
//     final allDay = item.get(module.allDayKey, false);
//     final endTimeValue = item.get<int?>(module.endTimeKey, null);
//     final endTime = endTimeValue != null
//         ? DateTime.fromMillisecondsSinceEpoch(endTimeValue)
//         : null;
//     final allDayState = ref.state("allDay", allDay);
//     final allDayController =
//         ref.useTextEditingController("allDay", allDay.toString());
//     final startTimeController = ref.useTextEditingController(
//       "startTime",
//       allDayState.value
//           ? FormItemDateTimeField.formatDate(startTime.millisecondsSinceEpoch)
//           : FormItemDateTimeField.formatDateTime(
//               startTime.millisecondsSinceEpoch,
//             ),
//     );
//     final endTimeOrStartTime =
//         endTime ?? startTime.add(const Duration(hours: 1));
//     final endTimeController = ref.useTextEditingController(
//       "endTime",
//       allDayState.value
//           ? FormItemDateTimeField.formatDate(
//               endTimeOrStartTime.millisecondsSinceEpoch,
//             )
//           : FormItemDateTimeField.formatDateTime(
//               endTimeOrStartTime.millisecondsSinceEpoch,
//             ),
//     );
//     final titleController = ref.useTextEditingController("title", name);
//     final textController = ref.useTextEditingController("text", text);

//     final editingType = note.isNotEmpty && !note.startsWith(RegExp(r"^(\[|\{)"))
//         ? CalendarEditingType.planeText
//         : module.editingType;

//     final appBar = UIAppBar(
//       sliverLayoutWhenModernDesign: false,
//       title: Text(
//         form.select(
//           item.get(module.nameKey, ""),
//           "New Events".localize(),
//         ),
//       ),
//       subtitle: form.select(
//         Text(
//           _timeString(
//             startTime: startTime,
//             endTime: endTime,
//             allDay: allDay,
//           ),
//         ),
//         null,
//       ),
//       actions: [
//         if (form.exists)
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               UIConfirm.show(
//                 context,
//                 title: "Confirmation".localize(),
//                 text: "You can't undo it after deleting it. May I delete it?"
//                     .localize(),
//                 submitText: "Yes".localize(),
//                 cacnelText: "No".localize(),
//                 onSubmit: () async {
//                   await context.model
//                       ?.deleteDocument(item)
//                       .showIndicator(context);
//                   context.navigator.pop();
//                 },
//               );
//             },
//           ),
//       ],
//     );

//     final header = [
//       FormItemSwitch(
//         labelText: "All day".localize(),
//         type: FormItemSwitchType.list,
//         controller: allDayController,
//         onSaved: (value) {
//           context[module.allDayKey] = value ?? false;
//         },
//         onChanged: (value) {
//           allDayState.value = value ?? false;
//         },
//       ),
//       DividHeadline("Start date".localize()),
//       FormItemDateTimeField(
//         dense: true,
//         errorText: "No input %s".localize().format(["Start date".localize()]),
//         type: allDayState.value
//             ? FormItemDateTimeFieldPickerType.date
//             : FormItemDateTimeFieldPickerType.dateTime,
//         controller: startTimeController,
//         // format: allDayState.value ? "yyyy/MM/dd(E)" : "yyyy/MM/dd(E) HH:mm",
//         onSaved: (value) {
//           value ??= now;
//           context[module.startTimeKey] = value.millisecondsSinceEpoch;
//         },
//       ),
//       Collapse(
//         show: !allDayState.value,
//         children: [
//           DividHeadline("End date".localize()),
//           FormItemDateTimeField(
//             dense: true,
//             controller: endTimeController,
//             allowEmpty: true,
//             // format: "yyyy/MM/dd(E) HH:mm",
//             validator: (value) {
//               if (value == null || allDayState.value) {
//                 return null;
//               }
//               final start = allDayState.value
//                   ? FormItemDateTimeField.tryParseFromDate(
//                       startTimeController.text,
//                     )
//                   : FormItemDateTimeField.tryParseFromDateTime(
//                       startTimeController.text,
//                     );
//               if (start == null) {
//                 return "No input %s"
//                     .localize()
//                     .format(["Start date".localize()]);
//               }
//               if (start.millisecondsSinceEpoch >=
//                   value.millisecondsSinceEpoch) {
//                 return "The end date and time must be a time after the start date and time."
//                     .localize();
//               }
//               return null;
//             },
//             onSaved: (value) {
//               value ??= now.add(const Duration(hours: 1));
//               context[module.endTimeKey] = value.millisecondsSinceEpoch;
//             },
//           ),
//         ],
//       ),
//       DividHeadline("Title".localize()),
//       FormItemTextField(
//         dense: true,
//         errorText: "No input %s".localize().format(["Title".localize()]),
//         subColor: context.theme.disabledColor,
//         controller: titleController,
//         onSaved: (value) {
//           context[module.nameKey] = value ?? "";
//         },
//       ),
//       DividHeadline(module.detailLabel.localize()),
//       FormItemTextField(
//         dense: true,
//         allowEmpty: true,
//         keyboardType: TextInputType.multiline,
//         expands: !module.enableNote,
//         subColor: context.theme.disabledColor,
//         controller: textController,
//         onSaved: (value) {
//           context[module.textKey] = value ?? "";
//         },
//       ),
//     ];

//     if (!module.enableNote) {
//       return UIScaffold(
//         waitTransition: true,
//         appBar: appBar,
//         body: FormBuilder(
//           key: form.key,
//           padding: const EdgeInsets.all(0),
//           type: FormBuilderType.listView,
//           children: header,
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () async {
//             if (!form.validate()) {
//               return;
//             }
//             try {
//               final allDay = context.get(module.allDayKey, false);
//               item[module.nameKey] = context.get(module.nameKey, "");
//               item[module.textKey] = context.get(module.textKey, "");
//               item[module.allDayKey] = allDay;
//               item[module.userKey] = user.uid;
//               item[module.startTimeKey] =
//                   context.get(module.startTimeKey, now.millisecondsSinceEpoch);
//               item[module.endTimeKey] =
//                   allDay ? null : context.get<int?>(module.endTimeKey, null);
//               await context.model?.saveDocument(item).showIndicator(context);
//               context.navigator.pop();
//             } catch (e) {
//               UIDialog.show(
//                 context,
//                 title: "Error".localize(),
//                 text: "%s is not completed."
//                     .localize()
//                     .format(["Editing".localize()]),
//               );
//             }
//           },
//           label: Text("Submit".localize()),
//           icon: const Icon(Icons.check),
//         ),
//       );
//     }

//     switch (editingType) {
//       case CalendarEditingType.wysiwyg:
//         final controller = ref.cache(
//           "controller",
//           () => note.isEmpty
//               ? QuillController.basic()
//               : QuillController(
//                   document: Document.fromJson(jsonDecode(note)),
//                   selection: const TextSelection.collapsed(offset: 0),
//                 ),
//           keys: [note],
//         );

//         return UIScaffold(
//           waitTransition: true,
//           appBar: appBar,
//           body: FormBuilder(
//             key: form.key,
//             padding: const EdgeInsets.all(0),
//             type: FormBuilderType.listView,
//             children: [
//               ...header,
//               const Divid(),
//               Theme(
//                 data: context.theme.copyWith(
//                   canvasColor: context.theme.scaffoldBackgroundColor,
//                 ),
//                 child: QuillToolbar.basic(
//                   controller: controller,
//                   toolbarIconSize: 24,
//                   multiRowsDisplay: false,
//                   onImagePickCallback: (file) async {
//                     if (file.path.isEmpty || !file.existsSync()) {
//                       return "";
//                     }
//                     return await context.model!.uploadMedia(file.path);
//                   },
//                 ),
//               ),
//               Divid(color: context.theme.dividerColor.withOpacity(0.25)),
//               SizedBox(
//                 height: (context.mediaQuery.size.height -
//                         context.mediaQuery.viewInsets.bottom -
//                         kToolbarHeight -
//                         _kQuillToolbarHeight)
//                     .limitLow(0),
//                 child: QuillEditor(
//                   scrollController: ScrollController(),
//                   scrollable: true,
//                   focusNode: ref.useFocusNode("note"),
//                   autoFocus: false,
//                   controller: controller,
//                   placeholder: module.noteLabel.localize(),
//                   readOnly: false,
//                   expands: false,
//                   padding: const EdgeInsets.all(12),
//                   customStyles: DefaultStyles(
//                     placeHolder: DefaultTextBlockStyle(
//                       TextStyle(
//                         color: context.theme.disabledColor,
//                         fontSize: 16,
//                       ),
//                       const Tuple2(16, 0),
//                       const Tuple2(0, 0),
//                       null,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: () async {
//               if (!form.validate()) {
//                 return;
//               }
//               try {
//                 final allDay = context.get(module.allDayKey, false);
//                 item[module.nameKey] = context.get(module.nameKey, "");
//                 item[module.textKey] = context.get(module.textKey, "");
//                 item[module.noteKey] =
//                     jsonEncode(controller.document.toDelta().toJson());
//                 item[module.allDayKey] = allDay;
//                 item[module.userKey] = user.uid;
//                 item[module.startTimeKey] = context.get(
//                   module.startTimeKey,
//                   now.millisecondsSinceEpoch,
//                 );
//                 item[module.endTimeKey] =
//                     allDay ? null : context.get<int?>(module.endTimeKey, null);
//                 await context.model?.saveDocument(item).showIndicator(context);
//                 context.navigator.pop();
//               } catch (e) {
//                 UIDialog.show(
//                   context,
//                   title: "Error".localize(),
//                   text: "%s is not completed."
//                       .localize()
//                       .format(["Editing".localize()]),
//                 );
//               }
//             },
//             label: Text("Submit".localize()),
//             icon: const Icon(Icons.check),
//           ),
//         );
//       default:
//         return UIScaffold(
//           waitTransition: true,
//           appBar: appBar,
//           body: FormBuilder(
//             key: form.key,
//             padding: const EdgeInsets.all(0),
//             type: FormBuilderType.listView,
//             children: [
//               ...header,
//               const Divid(),
//               SizedBox(
//                 height: (context.mediaQuery.size.height -
//                         context.mediaQuery.viewInsets.bottom -
//                         kToolbarHeight)
//                     .limitLow(0),
//                 child: FormItemTextField(
//                   dense: true,
//                   expands: true,
//                   textAlignVertical: TextAlignVertical.top,
//                   keyboardType: TextInputType.multiline,
//                   hintText: module.noteLabel.localize(),
//                   subColor: context.theme.disabledColor,
//                   controller: ref.useTextEditingController("note", note),
//                   onSaved: (value) {
//                     context[module.noteKey] = value;
//                   },
//                 ),
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: () async {
//               if (!form.validate()) {
//                 return;
//               }
//               try {
//                 final allDay = context.get(module.allDayKey, false);
//                 item[module.nameKey] = context.get(module.nameKey, "");
//                 item[module.textKey] = context.get(module.textKey, "");
//                 item[module.noteKey] = context.get(module.noteKey, "");
//                 item[module.allDayKey] = allDay;
//                 item[module.userKey] = user.uid;
//                 item[module.startTimeKey] = context.get(
//                   module.startTimeKey,
//                   now.millisecondsSinceEpoch,
//                 );
//                 item[module.endTimeKey] =
//                     allDay ? null : context.get<int?>(module.endTimeKey, null);
//                 await context.model?.saveDocument(item).showIndicator(context);
//                 context.navigator.pop();
//               } catch (e) {
//                 UIDialog.show(
//                   context,
//                   title: "Error".localize(),
//                   text: "%s is not completed."
//                       .localize()
//                       .format(["Editing".localize()]),
//                 );
//               }
//             },
//             label: Text("Submit".localize()),
//             icon: const Icon(Icons.check),
//           ),
//         );
//     }
//   }
// }

// String _timeString({
//   required DateTime startTime,
//   DateTime? endTime,
//   bool allDay = false,
// }) {
//   if (endTime == null) {
//     allDay = true;
//   }
//   if (allDay) {
//     return "${startTime.format("yyyy/MM/dd")} ${"All day".localize()}";
//   } else {
//     return "${startTime.format("yyyy/MM/dd HH:mm")} - ${endTime?.format("yyyy/MM/dd HH:mm")}";
//   }
// }

// bool _inEvent({
//   required num sourceStartTime,
//   num? sourceEndTime,
//   required num targetStartTime,
//   num? targetEndTime,
// }) {
//   sourceEndTime ??= sourceStartTime;
//   targetEndTime ??= targetStartTime;
//   if (sourceStartTime <= targetStartTime && targetStartTime < sourceEndTime) {
//     if (sourceStartTime <= targetEndTime && targetEndTime < sourceEndTime) {
//       return true;
//     }
//   }
//   if (targetStartTime <= sourceStartTime && sourceStartTime < targetEndTime) {
//     return true;
//   }
//   if (targetStartTime <= sourceEndTime && sourceEndTime < targetEndTime) {
//     return true;
//   }
//   return false;
// }
