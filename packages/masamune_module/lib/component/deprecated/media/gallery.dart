// import 'package:masamune_module/masamune_module.dart';
// import 'package:photo_view/photo_view.dart' as phto_view;

// enum GalleryType {
//   detail,
//   tile,
//   tileWithTab,
//   tileWithList,
// }

// @immutable
// @deprecated
// class GalleryModule extends PageModule with VerifyAppReroutePageModuleMixin {
//   const GalleryModule({
//     bool enabled = true,
//     String title = "",
//     this.galleryType = GalleryType.tile,
//     this.routePath = "gallery",
//     this.queryPath = "gallery",
//     this.userPath = "user",
//     this.mediaKey = Const.media,
//     this.nameKey = Const.name,
//     this.textKey = Const.text,
//     this.categoryKey = Const.category,
//     this.createdTimeKey = Const.createdTime,
//     this.maxCrossAxisExtentForMobile = 200,
//     this.maxCrossAxisExtentForDesktop = 200,
//     this.childAspectRatioForMobile = 0.5625,
//     this.childAspectRatioForDesktop = 1,
//     this.heightOnDetailView = 200,
//     this.tileSpacing = 1,
//     this.categoryConfig = const [],
//     this.mediaType = AdapterMediaType.all,
//     this.skipDetailPage = false,
//     this.sliverLayoutWhenModernDesignOnHome = true,
//     this.automaticallyImplyLeadingOnHome = true,
//     List<RerouteConfig> rerouteConfigs = const [],
//     this.contentQuery,
//     this.categoryQuery,
//     this.homePage = const GalleryModuleHome(),
//     this.gridViewPage = const GalleryModuleGridView(),
//     this.editPage = const GalleryModuleEdit(),
//     this.tileViewPage = const GalleryModuleTileView(),
//     this.tileViewWithTabPage = const GalleryModuleTileViewWithTab(),
//     this.tileViewWithListPage = const GalleryModuleTileViewWithList(),
//     this.mediaViewPage = const GalleryModuleMediaView(),
//     this.mediaDetailPage = const GalleryModuleMediaDetail(),
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
//       "/$routePath/edit": RouteConfig((_) => editPage),
//       "/$routePath/{category_id}": RouteConfig((context) => gridViewPage),
//       "/$routePath/media/{media_id}": RouteConfig((_) => mediaDetailPage),
//       "/$routePath/media/{media_id}/view": RouteConfig((_) => mediaViewPage),
//       "/$routePath/media/{media_id}/edit": RouteConfig((_) => editPage),
//     };
//     return route;
//   }

//   // ページ設定。
//   final PageModuleWidget<GalleryModule> homePage;
//   final PageModuleWidget<GalleryModule> gridViewPage;
//   final PageModuleWidget<GalleryModule> editPage;
//   final PageModuleWidget<GalleryModule> mediaDetailPage;
//   final PageModuleWidget<GalleryModule> mediaViewPage;
//   final PageModuleWidget<GalleryModule> tileViewPage;
//   final PageModuleWidget<GalleryModule> tileViewWithTabPage;
//   final PageModuleWidget<GalleryModule> tileViewWithListPage;

//   /// ホームをスライバーレイアウトにする場合True.
//   final bool sliverLayoutWhenModernDesignOnHome;

//   /// ホームのときのバックボタンを削除するかどうか。
//   final bool automaticallyImplyLeadingOnHome;

//   /// ルートのパス。
//   @override
//   // ignore: overridden_fields
//   final String routePath;

//   /// ギャラリーのタイプ。
//   final GalleryType galleryType;

//   /// ギャラリーデータのパス。
//   @override
//   // ignore: overridden_fields
//   final String queryPath;

//   /// ユーザーのデータパス。
//   final String userPath;

//   /// 画像・映像のキー。
//   final String mediaKey;

//   /// タイトルのキー。
//   final String nameKey;

//   /// テキストのキー。
//   final String textKey;

//   /// カテゴリーのキー。
//   final String categoryKey;

//   /// 作成日のキー。
//   final String createdTimeKey;

//   /// コンテンツ用のクエリ。
//   final ModelQuery? contentQuery;

//   /// カテゴリー用のクエリ。
//   final ModelQuery? categoryQuery;

//   /// タイルの横方向のサイズ。
//   final double maxCrossAxisExtentForMobile;
//   final double maxCrossAxisExtentForDesktop;

//   /// タイルのアスペクト比。
//   final double childAspectRatioForMobile;
//   final double childAspectRatioForDesktop;

//   /// タイルのスペース。
//   final double tileSpacing;

//   /// 詳細画面の画像の高さ。
//   final double heightOnDetailView;

//   /// 対応するメディアタイプ。
//   final AdapterMediaType mediaType;

//   /// カテゴリーの設定。
//   final List<GroupConfig> categoryConfig;

//   /// 詳細のページは出さずに直接画像を表示する場合は`true`。
//   final bool skipDetailPage;
// }

// class GalleryModuleHome extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleHome();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     switch (module.galleryType) {
//       case GalleryType.tile:
//         return module.tileViewPage;
//       case GalleryType.tileWithTab:
//         return module.tileViewWithTabPage;
//       case GalleryType.tileWithList:
//         return module.tileViewWithListPage;
//       default:
//         return const Empty();
//     }
//   }
// }

// class GalleryModuleTileViewWithList extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleTileViewWithList();

//   List<GroupConfig> _categories(
//     BuildContext context,
//     WidgetRef ref,
//     GalleryModule module,
//   ) {
//     if (module.categoryQuery != null) {
//       final categories = ref.watchCollectionModel(module.categoryQuery!.value);
//       return categories.mapAndRemoveEmpty(
//         (item) =>
//             GroupConfig(id: item.uid, label: item.get(module.nameKey, "")),
//       )..addAll(module.categoryConfig);
//     }
//     return module.categoryConfig;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final list = _categories(context, ref, module);
//     final controller = ref.useNavigatorController(
//       "/${module.routePath}/${list.firstOrNull?.id}",
//     );

//     return UIScaffold(
//       waitTransition: true,
//       inlineNavigatorControllerOnWeb: controller,
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Gallery".localize()),
//         sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
//         automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
//       ),
//       body: UIListBuilder<GroupConfig>(
//         source: list,
//         builder: (context, item, index) {
//           return [
//             ListItem(
//               title: Text(item.label),
//               onTap: () {
//                 context.navigator.pushNamed("/${module.routePath}/${item.id}");
//               },
//             )
//           ];
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         label: Text("Add".localize()),
//         icon: const Icon(Icons.add),
//         onPressed: () {
//           context.navigator.pushNamed(
//             "/${module.routePath}/edit",
//             arguments: RouteQuery.fullscreenOrModal,
//           );
//         },
//       ),
//     );
//   }
// }

// class GalleryModuleTileViewWithTab extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleTileViewWithTab();

//   List<GroupConfig> _categories(
//     BuildContext context,
//     WidgetRef ref,
//     GalleryModule module,
//   ) {
//     if (module.categoryQuery != null) {
//       final categories = ref.watchCollectionModel(module.categoryQuery!.value);
//       return categories.mapAndRemoveEmpty(
//         (item) =>
//             GroupConfig(id: item.uid, label: item.get(module.nameKey, "")),
//       )..addAll(module.categoryConfig);
//     }
//     return module.categoryConfig;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final list = _categories(context, ref, module);
//     final tab = ref.useTab(list);
//     final controller = ref.useNavigatorController(
//       "/${module.routePath}/${module.categoryConfig.firstOrNull?.id}",
//     );

//     return UIScaffold(
//       waitTransition: true,
//       inlineNavigatorControllerOnWeb: controller,
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Gallery".localize()),
//         bottom: UITabBar<GroupConfig>(tab),
//       ),
//       body: UITabView<GroupConfig>(
//         tab,
//         builder: (context, item, key) {
//           return GalleryModuleGrid(category: item);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         label: Text("Add".localize()),
//         icon: const Icon(Icons.add),
//         onPressed: () {
//           context.navigator.pushNamed(
//             "/${module.routePath}/edit",
//             arguments: RouteQuery.fullscreenOrModal,
//           );
//         },
//       ),
//     );
//   }
// }

// class GalleryModuleTileView extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleTileView();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final controller = ref.useNavigatorController(
//       "/${module.routePath}/${module.categoryConfig.firstOrNull?.id}",
//     );

//     return UIScaffold(
//       waitTransition: true,
//       inlineNavigatorControllerOnWeb: controller,
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Gallery".localize()),
//       ),
//       body: const GalleryModuleGrid(),
//       floatingActionButton: FloatingActionButton.extended(
//         label: Text("Add".localize()),
//         icon: const Icon(Icons.add),
//         onPressed: () {
//           context.navigator.pushNamed(
//             "/${module.routePath}/edit",
//             arguments: RouteQuery.fullscreen,
//           );
//         },
//       ),
//     );
//   }
// }

// class GalleryModuleGridView extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleGridView();

//   List<GroupConfig> _categories(
//     BuildContext context,
//     WidgetRef ref,
//     GalleryModule module,
//   ) {
//     if (module.categoryQuery != null) {
//       final categories = ref.watchCollectionModel(module.categoryQuery!.value);
//       return categories.mapAndRemoveEmpty(
//         (item) =>
//             GroupConfig(id: item.uid, label: item.get(module.nameKey, "")),
//       )..addAll(module.categoryConfig);
//     }
//     return module.categoryConfig;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final list = _categories(context, ref, module);
//     final category = list
//         .firstWhereOrNull((item) => item.id == context.get("category_id", ""));

//     if (category == null) {
//       return UIScaffold(
//         appBar: UIAppBar(
//           title: Text(module.title ?? "Gallery".localize()),
//         ),
//         body: Center(
//           child: Text("No data.".localize()),
//         ),
//       );
//     }

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(category.label.localize()),
//       ),
//       body: GalleryModuleGrid(category: category),
//     );
//   }
// }

// class GalleryModuleGrid extends ModuleWidget<GalleryModule> {
//   const GalleryModuleGrid({this.category});
//   final GroupConfig? category;

//   DynamicCollectionModel _gallery(
//     BuildContext context,
//     WidgetRef ref,
//     GalleryModule module,
//   ) {
//     if (category == null) {
//       return ref
//           .watchCollectionModel(module.contentQuery?.value ?? module.queryPath);
//     }
//     return ref.watchCollectionModel(
//       category!.query?.value ??
//           module.contentQuery?.value ??
//           ModelQuery(
//             module.queryPath,
//             key: module.categoryKey,
//             isEqualTo: category!.id,
//           ).value,
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final gallery = _gallery(context, ref, module);
//     final filtered = gallery.where(
//       (item) {
//         if (category == null) {
//           return true;
//         }
//         return item.get(module.categoryKey, "") == category!.id;
//       },
//     );

//     return LoadingBuilder(
//       futures: [
//         gallery.loading,
//       ],
//       builder: (context) {
//         return UIGridBuilder<DynamicDocumentModel>.extent(
//           maxCrossAxisExtent: context.isMobile
//               ? module.maxCrossAxisExtentForMobile
//               : module.maxCrossAxisExtentForDesktop,
//           childAspectRatio: context.isMobile
//               ? module.childAspectRatioForMobile
//               : module.childAspectRatioForDesktop,
//           mainAxisSpacing: module.tileSpacing,
//           crossAxisSpacing: module.tileSpacing,
//           source: filtered.toList(),
//           builder: (context, item) {
//             final path = item.get(module.mediaKey, "");
//             final type = getAdapterMediaType(path);
//             switch (type) {
//               case AdapterMediaType.video:
//                 return Container(
//                   color: context.theme.dividerColor,
//                   child: ClipRRect(
//                     child: ClickableBox.video(
//                       video: Asset.video(path),
//                       fit: BoxFit.cover,
//                       onTap: () {
//                         context.rootNavigator.pushNamed(
//                           module.skipDetailPage
//                               ? "/${module.routePath}/media/${item.get(Const.uid, "")}/view"
//                               : "/${module.routePath}/media/${item.get(Const.uid, "")}",
//                           arguments: RouteQuery.fullscreenOrModal,
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               default:
//                 return ClickableBox.image(
//                   image: Asset.image(path),
//                   fit: BoxFit.cover,
//                   onTap: () {
//                     context.rootNavigator.pushNamed(
//                       module.skipDetailPage
//                           ? "/${module.routePath}/media/${item.get(Const.uid, "")}/view"
//                           : "/${module.routePath}/media/${item.get(Const.uid, "")}",
//                       arguments: RouteQuery.fullscreenOrModal,
//                     );
//                   },
//                 );
//             }
//           },
//         );
//       },
//     );
//   }
// }

// class GalleryModuleMediaDetail extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleMediaDetail();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final item = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("media_id", "")}",
//     );

//     final now = ref.useNow();
//     final name = item.get(module.nameKey, "");
//     final text = item.get(module.textKey, "");
//     final media = item.get(module.mediaKey, "");
//     final createdTime =
//         item.get(module.createdTimeKey, now.millisecondsSinceEpoch);
//     final type = getAdapterMediaType(media);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(name),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               context.navigator.pushNamed(
//                 "/${module.routePath}/media/${context.get("media_id", "")}/edit",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//           ),
//         ],
//       ),
//       body: UIListView(
//         children: [
//           InkWell(
//             onTap: () {
//               context.navigator.pushNamed(
//                 "/${module.routePath}/media/${context.get("media_id", "")}/view",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//             child: () {
//               switch (type) {
//                 case AdapterMediaType.video:
//                   return Container(
//                     color: context.theme.dividerColor,
//                     height: module.heightOnDetailView,
//                     child: ClipRRect(
//                       child: Video(
//                         Asset.video(media),
//                         fit: BoxFit.cover,
//                         autoplay: true,
//                         mute: true,
//                         mixWithOthers: true,
//                       ),
//                     ),
//                   );
//                 default:
//                   return Container(
//                     height: module.heightOnDetailView,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: Asset.image(media),
//                         fit: BoxFit.cover,
//                       ),
//                       color: context.theme.disabledColor,
//                     ),
//                   );
//               }
//             }(),
//           ),
//           Indent(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               const Space.height(12),
//               if (text.isNotEmpty) ...[
//                 Text(text),
//                 const Space.height(12),
//               ],
//               Text(
//                 DateTime.fromMillisecondsSinceEpoch(createdTime)
//                     .format("yyyy/MM/dd HH:mm"),
//                 style: TextStyle(
//                   color: context.theme.disabledColor,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//           const Divid(),
//         ],
//       ),
//     );
//   }
// }

// class GalleryModuleMediaView extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleMediaView();

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final item = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("media_id", "")}",
//     );
//     final name = item.get(module.nameKey, "");
//     final media = item.get(module.mediaKey, "");
//     final type = getAdapterMediaType(media);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(name),
//         actions: [
//           if (module.skipDetailPage)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 context.navigator.pushNamed(
//                   "/${module.routePath}/media/${context.get("media_id", "")}/edit",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//             ),
//         ],
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
//                 case AdapterMediaType.video:
//                   return Center(
//                     child: Video(
//                       Asset.video(media),
//                       fit: BoxFit.contain,
//                       controllable: true,
//                       mixWithOthers: true,
//                     ),
//                   );
//                 default:
//                   return phto_view.PhotoView(
//                     imageProvider: Asset.image(media),
//                   );
//               }
//             }(),
//     );
//   }
// }

// class GalleryModuleEdit extends PageModuleWidget<GalleryModule> {
//   const GalleryModuleEdit();

//   List<GroupConfig> _categories(
//     BuildContext context,
//     WidgetRef ref,
//     GalleryModule module,
//   ) {
//     if (module.categoryQuery != null) {
//       final categories = ref.watchCollectionModel(module.categoryQuery!.value);
//       return categories.mapAndRemoveEmpty(
//         (item) =>
//             GroupConfig(id: item.uid, label: item.get(module.nameKey, "")),
//       )..addAll(module.categoryConfig);
//     }
//     return module.categoryConfig;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref, GalleryModule module) {
//     final form = ref.useForm("media_id");
//     final item = ref.watchDocumentModel("${module.queryPath}/${form.uid}");
//     final name = item.get(module.nameKey, "");
//     final text = item.get(module.textKey, "");
//     final media = item.get(module.mediaKey, "");
//     final categories = _categories(context, ref, module);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         sliverLayoutWhenModernDesign: false,
//         title: Text(
//           form.select(
//             "Editing %s".localize().format([name]),
//             "A new entry".localize(),
//           ),
//         ),
//         actions: [
//           if (form.exists)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () {
//                 UIConfirm.show(
//                   context,
//                   title: "Confirmation".localize(),
//                   text: "You can't undo it after deleting it. May I delete it?"
//                       .localize(),
//                   submitText: "Yes".localize(),
//                   cacnelText: "No".localize(),
//                   onSubmit: () async {
//                     await context.model
//                         ?.deleteDocument(item)
//                         .showIndicator(context);
//                     context.navigator.popUntilNamed("/${module.routePath}");
//                   },
//                 );
//               },
//             ),
//         ],
//       ),
//       body: FormBuilder(
//         padding: const EdgeInsets.all(0),
//         key: form.key,
//         children: [
//           FormItemMedia(
//             height: 200,
//             dense: true,
//             controller: ref.useTextEditingController(
//               module.mediaKey,
//               form.select(media, ""),
//             ),
//             errorText: "No input %s".localize().format(["Image".localize()]),
//             onTap: (onUpdate) async {
//               final media = await context.platform?.mediaDialog(
//                 context,
//                 title: "Please select your %s"
//                     .localize()
//                     .format(["Media".localize().toLowerCase()]),
//                 type: module.mediaType,
//               );
//               onUpdate(media?.path);
//             },
//             onSaved: (value) {
//               context[module.mediaKey] = value;
//             },
//           ),
//           const Space.height(12),
//           DividHeadline("Title".localize()),
//           FormItemTextField(
//             dense: true,
//             hintText: "Input %s".localize().format(["Title".localize()]),
//             errorText: "No input %s".localize().format(["Title".localize()]),
//             controller: ref.useTextEditingController(
//               module.nameKey,
//               form.select(name, ""),
//             ),
//             onSaved: (value) {
//               context[module.nameKey] = value;
//             },
//           ),
//           DividHeadline("Description".localize()),
//           FormItemTextField(
//             dense: true,
//             keyboardType: TextInputType.multiline,
//             minLines: 5,
//             maxLines: 5,
//             hintText: "Input %s".localize().format(["Description".localize()]),
//             allowEmpty: true,
//             controller: ref.useTextEditingController(
//               module.textKey,
//               form.select(text, ""),
//             ),
//             onSaved: (value) {
//               context[module.textKey] = value;
//             },
//           ),
//           if (categories.isNotEmpty) ...[
//             DividHeadline("Category".localize()),
//             FormItemDropdownField(
//               dense: true,
//               // labelText: "Category".localize(),
//               hintText: "Input %s".localize().format(["Category".localize()]),
//               controller: ref.useTextEditingController(
//                 module.categoryKey,
//                 form.select(
//                   item.get(module.categoryKey, categories.first.id),
//                   categories.first.id,
//                 ),
//               ),
//               items: <String, String>{
//                 for (final category in categories) category.id: category.label
//               },
//               onSaved: (value) {
//                 context[module.categoryKey] = value;
//               },
//             ),
//           ],
//           const Divid(),
//           const Space.height(100),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           if (!form.validate()) {
//             return;
//           }

//           item[module.nameKey] = context.get(module.nameKey, "");
//           item[module.textKey] = context.get(module.textKey, "");
//           item[module.categoryKey] = context.get(module.categoryKey, "");
//           item[module.mediaKey] = await context.model
//               ?.uploadMedia(context.get(module.mediaKey, ""))
//               .showIndicator(context);
//           await context.model?.saveDocument(item).showIndicator(context);
//           context.navigator.pop();
//         },
//         label: Text("Submit".localize()),
//         icon: const Icon(Icons.check),
//       ),
//     );
//   }
// }
