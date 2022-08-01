// import 'package:masamune_module/masamune_module.dart';
// import 'package:photo_view/photo_view.dart';

// enum ChatType { direct, group }

// extension ChatTypeExtensions on ChatType {
//   String get text {
//     switch (this) {
//       case ChatType.group:
//         return "group";
//       default:
//         return "direct";
//     }
//   }
// }

// @immutable
// @deprecated
// class ChatModule extends PageModule with VerifyAppReroutePageModuleMixin {
//   const ChatModule({
//     bool enabled = true,
//     String? title = "",
//     this.routePath = "chat",
//     this.queryPath = "chat",
//     this.userPath = "user",
//     this.availableMemberPath = "user",
//     this.mediaType = PlatformMediaType.all,
//     this.nameKey = Const.name,
//     this.textKey = Const.text,
//     this.typeKey = Const.type,
//     this.memberKey = Const.member,
//     this.mediaKey = Const.media,
//     this.createdTimeKey = Const.createdTime,
//     this.modifiedTimeKey = Const.modifiedTime,
//     this.chatRoomQuery,
//     this.sliverLayoutWhenModernDesignOnHome = true,
//     this.automaticallyImplyLeadingOnHome = true,
//     this.availableMemberQuery,
//     this.allowEditRoomName = true,
//     List<RerouteConfig> rerouteConfigs = const [],
//     this.homePage = const ChatModuleHome(),
//     this.timelinePage = const ChatModuleTimeline(),
//     this.mediaViewPage = const ChatModuleMediaView(),
//     this.editPage = const ChatModuleEdit(),
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
//       "/$routePath/{chat_id}": RouteConfig((_) => timelinePage),
//       "/$routePath/{chat_id}/media/{timeline_id}":
//           RouteConfig((_) => mediaViewPage),
//       "/$routePath/{chat_id}/edit": RouteConfig((_) => editPage),
//     };
//     return route;
//   }

//   // ページ設定
//   final PageModuleWidget<ChatModule> homePage;
//   final PageModuleWidget<ChatModule> timelinePage;
//   final PageModuleWidget<ChatModule> mediaViewPage;
//   final PageModuleWidget<ChatModule> editPage;

//   /// ホームをスライバーレイアウトにする場合True.
//   final bool sliverLayoutWhenModernDesignOnHome;

//   /// ホームのときのバックボタンを削除するかどうか。
//   final bool automaticallyImplyLeadingOnHome;

//   /// チャットルームの名前を変更可能な場合True.
//   final bool allowEditRoomName;

//   /// ルートのパス。
//   @override
//   // ignore: overridden_fields
//   final String routePath;

//   /// チャットデータのパス。
//   @override
//   // ignore: overridden_fields
//   final String queryPath;

//   /// メンバーデータのキー。
//   final String memberKey;

//   /// ルームを作成可能なメンバーのリスト。
//   final String? availableMemberPath;

//   /// ユーザーのデータパス。
//   final String userPath;

//   /// タイトルのキー。
//   final String nameKey;

//   /// テキストのキー。
//   final String textKey;

//   /// チャットタイプのキー。
//   final String typeKey;

//   /// 作成日のキー。
//   final String createdTimeKey;

//   /// 更新日のキー。
//   final String modifiedTimeKey;

//   /// メディアのキー。
//   final String mediaKey;

//   /// 対応するメディアタイプ。
//   final PlatformMediaType mediaType;

//   /// チャットルームのクエリ。
//   final ModelQuery? chatRoomQuery;

//   /// ルームを作成可能なメンバーのリスト。
//   final ModelQuery? availableMemberQuery;
// }

// class ChatModuleHome extends PageModuleWidget<ChatModule> {
//   const ChatModuleHome();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, ChatModule module) {
//     final now = ref.useNow();
//     final user = ref.watchUserDocumentModel(module.userPath);
//     final chat = ref.watchCollectionModel(
//       module.chatRoomQuery?.value ??
//           ModelQuery(
//             module.queryPath,
//             key: module.memberKey,
//             arrayContains: user.get(Const.uid, ""),
//           ).value,
//     );
//     final membersPath =
//         module.availableMemberQuery?.value ?? module.availableMemberPath;
//     final members =
//         membersPath == null ? null : ref.watchCollectionModel(membersPath);
//     final filteredMembers = members?.where((m) {
//       if (context.model?.userId == m.uid) {
//         return false;
//       }
//       return !chat.any((e) {
//         final members = e.get(module.memberKey, []);
//         if (members.length > 2) {
//           return false;
//         }
//         return members.any((member) => member.toString() == m.uid);
//       });
//     }).toList();
//     final users = ref.watchCollectionModel(
//       ModelQuery(
//         module.userPath,
//         key: Const.uid,
//         order: ModelQueryOrder.desc,
//         orderBy: module.modifiedTimeKey,
//         whereIn: chat.map((e) {
//           final member = e.get(module.memberKey, []);
//           final u = member.firstWhereOrNull(
//             (item) => item.toString() != user.get(Const.uid, ""),
//           );
//           return u.toString();
//         }).distinct(),
//       ).value,
//     );
//     final chatWithUser = chat.setWhereListenable(
//       users,
//       test: (o, a) {
//         final member = o.get(module.memberKey, []);
//         final u = member.firstWhereOrNull(
//           (item) => item.toString() == a.get(Const.uid, ""),
//         );
//         return u != null;
//       },
//       apply: (o, a) =>
//           o.mergeListenable(a, convertKeys: (key) => "${Const.user}$key"),
//       orElse: (o) => o,
//     );
//     final controller = ref.useNavigatorController(
//       "/${module.routePath}/${chatWithUser.firstOrNull.get(Const.uid, "")}",
//       (route) => chatWithUser.isEmpty,
//     );

//     return UIScaffold(
//       waitTransition: true,
//       loadingFutures: [
//         chat.loading,
//         users.loading,
//       ],
//       inlineNavigatorControllerOnWeb: controller,
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Chat".localize()),
//         sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
//         automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
//       ),
//       body: UIListView(
//         children: [
//           ...chatWithUser.mapListenable(
//             (item) {
//               final name = item.get(module.nameKey, "");
//               return ListItem(
//                 selected: !context.isMobileOrModal &&
//                     controller.route?.name.last() == item.get(Const.uid, ""),
//                 selectedColor: context.theme.textColorOnPrimary,
//                 selectedTileColor: context.theme.primaryColor.withOpacity(0.8),
//                 disabledTapOnSelected: true,
//                 trailing: Icon(
//                   Icons.check_circle,
//                   color: context.theme.primaryColor,
//                 ),
//                 title: Text(
//                   name.isNotEmpty
//                       ? name
//                       : item.get("${Const.user}${module.nameKey}", ""),
//                 ),
//                 subtitle: Text(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     item.get(module.createdTimeKey, now.millisecondsSinceEpoch),
//                   ).format("yyyy/MM/dd HH:mm"),
//                 ),
//                 onTap: () {
//                   if (context.isMobile) {
//                     context.rootNavigator.pushNamed(
//                       "/${module.routePath}/${item.get(Const.uid, "")}",
//                       arguments: RouteQuery.fullscreen,
//                     );
//                   } else {
//                     controller.navigator.pushNamed(
//                       "/${module.routePath}/${item.get(Const.uid, "")}",
//                     );
//                   }
//                 },
//               );
//             },
//           ),
//           if (filteredMembers != null)
//             ...filteredMembers.mapListenable(
//               (item) {
//                 final name = item.get(module.nameKey, "");
//                 return ListItem(
//                   selected: !context.isMobileOrModal &&
//                       controller.route?.name.last() == item.get(Const.uid, ""),
//                   selectedColor: context.theme.textColorOnPrimary,
//                   selectedTileColor:
//                       context.theme.primaryColor.withOpacity(0.8),
//                   disabledTapOnSelected: true,
//                   title: Text(
//                     name.isNotEmpty
//                         ? name
//                         : item.get("${Const.user}${module.nameKey}", ""),
//                   ),
//                   subtitle: Text(
//                     DateTime.fromMillisecondsSinceEpoch(
//                       item.get(
//                         module.createdTimeKey,
//                         now.millisecondsSinceEpoch,
//                       ),
//                     ).format("yyyy/MM/dd HH:mm"),
//                   ),
//                   onTap: () async {
//                     final uid = uuid;
//                     final memberId = item.uid;
//                     final userId = context.model?.userId;
//                     final doc = context.model?.createDocument(chat, uid);
//                     if (doc == null || userId.isEmpty) {
//                       return;
//                     }
//                     doc[module.memberKey] = [
//                       userId,
//                       memberId,
//                     ];
//                     await context.model
//                         ?.saveDocument(doc)
//                         .showIndicator(context);
//                     if (context.isMobile) {
//                       context.rootNavigator.pushNamed(
//                         "/${module.routePath}/$uid",
//                         arguments: RouteQuery.fullscreen,
//                       );
//                     } else {
//                       controller.navigator.pushNamed(
//                         "/${module.routePath}/$uid",
//                       );
//                     }
//                   },
//                 );
//               },
//             )
//         ],
//       ),
//     );
//   }
// }

// class ChatModuleTimeline extends PageModuleWidget<ChatModule> {
//   const ChatModuleTimeline();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, ChatModule module) {
//     final now = ref.useNow();
//     final userId = context.model?.userId;
//     final chat = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("chat_id", "")}",
//     );
//     final timeline = ref.watchCollectionModel(
//       ModelQuery(
//         "${module.queryPath}/${context.get("chat_id", "")}/${module.queryPath}",
//         order: ModelQueryOrder.desc,
//         orderBy: module.createdTimeKey,
//         limit: 500,
//       ).value,
//     );
//     timeline.sort(
//       (a, b) =>
//           b.get(module.createdTimeKey, 0) - a.get(module.createdTimeKey, 0),
//     );
//     final timlineWithUser = timeline.mergeUserInformation(
//       ref,
//       userCollectionPath: module.userPath,
//     );
//     final members = ref.watchCollectionModel(
//       ModelQuery(
//         module.userPath,
//         key: Const.uid,
//         whereIn:
//             chat.get(module.memberKey, []).map((e) => e.toString()).distinct(),
//       ).value,
//     );
//     final title = members.fold<List<String>>(
//       <String>[],
//       (previousValue, element) => element.get(Const.uid, "") == userId
//           ? previousValue
//           : (previousValue..add(element.get(module.nameKey, ""))),
//     ).join(", ");
//     final name = chat.get(module.nameKey, "");

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(name.isEmpty ? title : name),
//         sliverLayoutWhenModernDesign: false,
//         actions: [
//           if (chat.get(module.typeKey, "") == ChatType.group.text)
//             IconButton(
//               onPressed: () {
//                 context.rootNavigator.pushNamed(
//                   "/${module.routePath}/${context.get("chat_id", "")}/member",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//               icon: const Icon(Icons.people_alt),
//             ),
//           if (module.allowEditRoomName)
//             IconButton(
//               onPressed: () {
//                 context.rootNavigator.pushNamed(
//                   "/${module.routePath}/${context.get("chat_id", "")}/edit",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//               icon: const Icon(Icons.settings),
//             ),
//         ],
//       ),
//       body: UIListBuilder<DynamicMap>(
//         padding: const EdgeInsets.fromLTRB(8, 12, 8, 64),
//         reverse: true,
//         source: timlineWithUser,
//         builder: (context, item, index) {
//           final date = DateTime.fromMillisecondsSinceEpoch(
//             item.get(module.createdTimeKey, now.millisecondsSinceEpoch),
//           );
//           return [
//             if (item.get(Const.user, "") == userId)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     DefaultTextStyle(
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: context.theme.disabledColor,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(date.format("HH:mm")),
//                           Text(date.format("yyyy/MM/dd")),
//                         ],
//                       ),
//                     ),
//                     const Space.width(4),
//                     Flexible(
//                       child: ChatModuleTimelineItem(
//                         data: item,
//                         color: context.theme.colorScheme.onPrimary,
//                         backgroundColor: context.theme.primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 48,
//                       child: CircleAvatar(
//                         backgroundImage: NetworkOrAsset.image(
//                           item.get("${Const.user}${module.mediaKey}", ""),
//                           ImageSize.thumbnail,
//                         ),
//                       ),
//                     ),
//                     const Space.width(4),
//                     Flexible(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Flexible(
//                             child: ChatModuleTimelineItem(
//                               data: item,
//                               color: context.theme.colorScheme.onSecondary,
//                               backgroundColor:
//                                   context.theme.colorScheme.secondary,
//                             ),
//                           ),
//                           const Space.width(4),
//                           DefaultTextStyle(
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: context.theme.disabledColor,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(date.format("HH:mm")),
//                                 Text(date.format("yyyy/MM/dd")),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ];
//         },
//       ),
//       bottomSheet: FormItemCommentField(
//         maxLines: 4,
//         backgroundColor: context.theme.scaffoldBackgroundColor,
//         borderColor: context.theme.dividerColor,
//         hintText: "Input %s".localize().format(["Text".localize()]),
//         onSubmitted: (value) {
//           if (value.isEmpty) {
//             return;
//           }

//           final doc = context.model?.createDocument(timeline);
//           if (doc == null) {
//             return;
//           }
//           doc[Const.user] = userId;
//           doc[module.textKey] = value;
//           chat[module.modifiedTimeKey] = doc[module.createdTimeKey] =
//               DateTime.now().millisecondsSinceEpoch;
//           context.model?.saveDocument(doc);
//           context.model?.saveDocument(chat);
//         },
//         onTapMediaIcon: () async {
//           final media = await context.platform?.mediaDialog(
//             context,
//             title: "Please select your %s"
//                 .localize()
//                 .format(["Media".localize().toLowerCase()]),
//             type: module.mediaType,
//           );
//           if (media?.path == null) {
//             return;
//           }

//           final url = await context.model
//               ?.uploadMedia(media!.path!)
//               .showIndicator(context);
//           if (url.isEmpty) {
//             return;
//           }

//           final doc = context.model?.createDocument(timeline);
//           if (doc == null) {
//             return;
//           }
//           doc[Const.user] = userId;
//           doc[module.mediaKey] = url;
//           chat[module.modifiedTimeKey] = doc[module.createdTimeKey] =
//               DateTime.now().millisecondsSinceEpoch;
//           context.model?.saveDocument(doc);
//           context.model?.saveDocument(chat);
//         },
//       ),
//     );
//   }
// }

// class ChatModuleTimelineItem extends ModuleWidget<ChatModule> {
//   const ChatModuleTimelineItem({
//     required this.data,
//     this.color,
//     this.backgroundColor,
//   });

//   final DynamicMap data;
//   final Color? color;
//   final Color? backgroundColor;

//   @override
//   Widget build(BuildContext context, WidgetRef ref, ChatModule module) {
//     final media = data.get(module.mediaKey, "");
//     if (media.isNotEmpty) {
//       final type = getPlatformMediaType(media);
//       switch (type) {
//         case PlatformMediaType.video:
//           return ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 150),
//             child: InkWell(
//               onTap: () {
//                 context.rootNavigator.pushNamed(
//                   "/${module.routePath}/${context.get("chat_id", "")}/media/${data.get(Const.uid, "")}",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Video(NetworkOrAsset.video(media)),
//               ),
//             ),
//           );
//         default:
//           return ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 150),
//             child: InkWell(
//               onTap: () {
//                 context.rootNavigator.pushNamed(
//                   "/${module.routePath}/${context.get("chat_id", "")}/media/${data.get(Const.uid, "")}",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image(image: NetworkOrAsset.image(media)),
//               ),
//             ),
//           );
//       }
//     } else {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: DefaultBoxDecoration(
//           width: 0,
//           backgroundColor: backgroundColor,
//         ),
//         child: Text(
//           data.get(module.textKey, ""),
//           style: TextStyle(
//             fontSize: 16,
//             color: color,
//           ),
//         ),
//       );
//     }
//   }
// }

// class ChatModuleMediaView extends PageModuleWidget<ChatModule> {
//   const ChatModuleMediaView();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, ChatModule module) {
//     final item = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("chat_id", "")}/${module.queryPath}/${context.get("timeline_id", "")}",
//     );
//     final media = item.get(module.mediaKey, "");
//     final type = getPlatformMediaType(media);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: const UIAppBar(
//         sliverLayoutWhenModernDesign: false,
//       ),
//       backgroundColor: Colors.black,
//       body: media.isEmpty
//           ? Center(
//               child: Text(
//                 "No data.".localize(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//             )
//           : () {
//               switch (type) {
//                 case PlatformMediaType.video:
//                   return Center(
//                     child: Video(
//                       NetworkOrAsset.video(media),
//                       fit: BoxFit.contain,
//                       controllable: true,
//                       mixWithOthers: true,
//                     ),
//                   );
//                 default:
//                   return PhotoView(
//                     imageProvider: NetworkOrAsset.image(media),
//                   );
//               }
//             }(),
//     );
//   }
// }

// class ChatModuleEdit extends PageModuleWidget<ChatModule> {
//   const ChatModuleEdit();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, ChatModule module) {
//     final form = ref.useForm();
//     final chat = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("chat_id", "")}",
//     );
//     final name = chat.get(module.nameKey, "");

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         sliverLayoutWhenModernDesign: false,
//         title: Text("Editing %s".localize().format(["Chat".localize()])),
//       ),
//       body: FormBuilder(
//         padding: const EdgeInsets.all(0),
//         key: form.key,
//         children: [
//           const Space.height(16),
//           DividHeadline("Title".localize()),
//           FormItemTextField(
//             dense: true,
//             allowEmpty: true,
//             hintText: "Input %s".localize().format(["Title".localize()]),
//             controller: ref.useTextEditingController(module.nameKey, name),
//             onSaved: (value) {
//               context[module.nameKey] = value;
//             },
//           ),
//           const Divid(),
//           const Space.height(100),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           if (!form.validate()) {
//             return;
//           }

//           chat[module.nameKey] = context.get(module.nameKey, "");
//           await context.model?.saveDocument(chat).showIndicator(context);
//           context.navigator.pop();
//         },
//         label: Text("Submit".localize()),
//         icon: const Icon(Icons.check),
//       ),
//     );
//   }
// }
