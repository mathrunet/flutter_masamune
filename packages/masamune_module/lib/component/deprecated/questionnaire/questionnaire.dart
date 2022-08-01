// import 'package:masamune_module/masamune_module.dart';

// enum _QuenstionFormType { text, selection }

// extension _StringExtension on String {
//   _QuenstionFormType get quenstionFormType {
//     for (final type in _QuenstionFormType.values) {
//       if (type.text == this) {
//         return type;
//       }
//     }
//     return _QuenstionFormType.text;
//   }
// }

// extension _QuenstionFormTypeExtension on _QuenstionFormType {
//   String get text {
//     switch (this) {
//       case _QuenstionFormType.selection:
//         return "selection";
//       default:
//         return "text";
//     }
//   }

//   String get name {
//     switch (this) {
//       case _QuenstionFormType.selection:
//         return "Choices".localize();
//       default:
//         return "Text".localize();
//     }
//   }
// }

// @immutable
// class QuestionnaireModule extends PageModule
//     with VerifyAppReroutePageModuleMixin {
//   const QuestionnaireModule({
//     bool enabled = true,
//     String? title = "",
//     this.routePath = "question",
//     this.queryPath = "question",
//     this.questionPath = "question",
//     this.answerPath = "answer",
//     this.userPath = "user",
//     this.nameKey = Const.name,
//     this.textKey = Const.text,
//     this.requiredKey = Const.required,
//     this.typeKey = Const.type,
//     this.questioner = true,
//     this.selectionKey = Const.selection,
//     this.createdTimeKey = Const.createdTime,
//     this.endTimeKey = Const.endTime,
//     this.answerKey = Const.answer,
//     this.sliverLayoutWhenModernDesignOnHome = true,
//     this.automaticallyImplyLeadingOnHome = true,
//     List<RerouteConfig> rerouteConfigs = const [],
//     this.questionnaireQuery,
//     this.homePage = const QuestionnaireModuleHome(),
//     this.editPage = const QuestionnaireModuleEdit(),
//     this.viewPage = const QuestionnaireModuleView(),
//     this.answerViewPage = const QuestionnaireAanswerView(),
//     this.answerDetailPage = const QuestionnaireModuleAnswerDetail(),
//     this.questionViewPage = const QuestionnaireModuleQuestionView(),
//     this.questionEditPage = const QuestionnaireModuleQuestionEdit(),
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
//       // "/$routePath/{post_id}": RouteConfig((_) => _PostView(this)),
//       "/$routePath/{question_id}": RouteConfig((_) => viewPage),
//       "/$routePath/{question_id}/edit": RouteConfig((_) => editPage),
//       "/$routePath/{question_id}/question":
//           RouteConfig((_) => questionViewPage),
//       "/$routePath/{question_id}/answer/empty":
//           RouteConfig((_) => const EmptyPage()),
//       "/$routePath/{question_id}/answer/{answer_id}":
//           RouteConfig((_) => answerDetailPage),
//       "/$routePath/{question_id}/question/edit":
//           RouteConfig((_) => questionEditPage),
//       "/$routePath/{question_id}/question/{item_id}":
//           RouteConfig((_) => questionEditPage),
//     };
//     return route;
//   }

//   final PageModuleWidget<QuestionnaireModule> homePage;
//   final PageModuleWidget<QuestionnaireModule> editPage;
//   final PageModuleWidget<QuestionnaireModule> viewPage;
//   final PageModuleWidget<QuestionnaireModule> answerViewPage;
//   final PageModuleWidget<QuestionnaireModule> questionViewPage;
//   final PageModuleWidget<QuestionnaireModule> answerDetailPage;
//   final PageModuleWidget<QuestionnaireModule> questionEditPage;

//   /// ホームをスライバーレイアウトにする場合True.
//   final bool sliverLayoutWhenModernDesignOnHome;

//   /// ホームのときのバックボタンを削除するかどうか。
//   final bool automaticallyImplyLeadingOnHome;

//   /// ルートのパス。
//   @override
//   // ignore: overridden_fields
//   final String routePath;

//   /// クエリーのパス。
//   @override
//   // ignore: overridden_fields
//   final String queryPath;

//   /// アンケートデータのパス。
//   final String questionPath;

//   /// 回答データのパス。
//   final String answerPath;

//   /// ユーザーのデータパス。
//   final String userPath;

//   /// 作成日のキー。
//   final String createdTimeKey;

//   /// タイトルのキー。
//   final String nameKey;

//   /// テキストのキー。
//   final String textKey;

//   /// タイプのキー。
//   final String typeKey;

//   /// 任意項目であるかどうかのキー。
//   final String requiredKey;

//   /// 選択項目のキー。
//   final String selectionKey;

//   /// 答えのキー。
//   final String answerKey;

//   /// 締切日のキー。
//   final String endTimeKey;

//   /// クエリー。
//   final ModelQuery? questionnaireQuery;

//   /// 質問者の場合True.
//   final bool questioner;
// }

// class QuestionnaireModuleHome extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleHome();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     final now = ref.useNow();
//     final question = ref.watchCollectionModel(
//       module.questionnaireQuery?.value ?? module.queryPath,
//     );
//     final answered = ref.watchCollectionModel(
//       "${module.userPath}/${context.model?.userId}/${module.answerPath}",
//     );

//     final questionWithAnswer = question.map((e) {
//       final uid = e.get(Const.uid, "");
//       if (uid.isEmpty) {
//         return e;
//       }
//       if (answered.any((element) => element.uid == uid)) {
//         return {...e}..["answered"] = true;
//       }
//       return e;
//     });
//     final user = ref.watchUserDocumentModel(module.userPath);
//     final controller = ref.useNavigatorController(
//       "${module.routePath}/${questionWithAnswer.firstOrNull.get(Const.uid, "")}",
//       (route) => questionWithAnswer.isEmpty,
//     );

//     return UIScaffold(
//       waitTransition: true,
//       loadingFutures: [
//         question.loading,
//         user.loading,
//       ],
//       appBar: UIAppBar(
//         title: Text(module.title ?? "Questionnaire".localize()),
//         sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
//         automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
//       ),
//       body: UIListBuilder<DynamicMap>(
//         source: questionWithAnswer.toList(),
//         builder: (context, item, index) {
//           return [
//             ListItem(
//               selected: !context.isMobileOrModal &&
//                   controller.route?.name.last() == item.get(Const.uid, ""),
//               selectedColor: context.theme.textColorOnPrimary,
//               iconColor: Colors.green,
//               selectedTileColor: context.theme.primaryColor.withOpacity(0.8),
//               disabledTapOnSelected: true,
//               title: Text(item.get(module.nameKey, "")),
//               subtitle: Text(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   item.get(module.createdTimeKey, now.millisecondsSinceEpoch),
//                 ).format("yyyy/MM/dd HH:mm"),
//               ),
//               onTap: () {
//                 if (context.isMobile) {
//                   context.navigator.pushNamed(
//                     "${module.routePath}/${item.get(Const.uid, "")}",
//                     arguments: RouteQuery.fullscreen,
//                   );
//                 } else {
//                   controller.navigator.pushReplacementNamed(
//                     "${module.routePath}/${item.get(Const.uid, "")}",
//                   );
//                 }
//               },
//               trailing: item.get("answered", false)
//                   ? const Icon(Icons.check_circle)
//                   : null,
//             ),
//           ];
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         label: Text("Add".localize()),
//         icon: const Icon(Icons.add),
//         onPressed: () {
//           context.rootNavigator.pushNamed(
//             "/${module.routePath}/edit",
//             arguments: RouteQuery.fullscreenOrModal,
//           );
//         },
//       ),
//     );
//   }
// }

// class QuestionnaireModuleView extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleView();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     if (!module.questioner) {
//       return module.answerViewPage;
//     } else {
//       return module.questionViewPage;
//     }
//   }
// }

// class QuestionnaireAanswerView extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireAanswerView();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     final now = ref.useNow();
//     final question = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("question_id", "")}",
//     );
//     final questions = ref.watchCollectionModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.questionPath}",
//     );
//     final answers = ref.watchCollectionModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.answerPath}",
//     );
//     final answersWithUsers = answers.mergeUserInformation(
//       ref,
//       userCollectionPath: module.userPath,
//     );
//     final name = question.get(module.nameKey, "");
//     final text = question.get(module.textKey, "");
//     final endDate = question.get(module.endTimeKey, 0);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(name),
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.rootNavigator.pushNamed(
//                 "${module.routePath}/${context.get("question_id", "")}/edit",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//             icon: const Icon(Icons.edit),
//           ),
//           IconButton(
//             onPressed: () {
//               context.rootNavigator.pushNamed(
//                 "/${module.routePath}/${context.get("question_id", "")}/question",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//             icon: const Icon(Icons.settings),
//           )
//         ],
//       ),
//       body: () {
//         if (questions.isEmpty) {
//           return InkWell(
//             onTap: () {
//               context.rootNavigator.pushNamed(
//                 "/${module.routePath}/${context.get("question_id", "")}/question",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: MessageBox(
//                   "設問が設定されていません。こちらから設問を設定してください。",
//                   color: context.theme.errorColor,
//                 ),
//               ),
//             ),
//           );
//         }
//         return UIListBuilder<DynamicMap>(
//           source: answersWithUsers,
//           top: [
//             if (text.isNotEmpty)
//               MessageBox(
//                 text,
//                 color: context.theme.dividerColor,
//                 margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//               ),
//             if (endDate > 0)
//               MessageBox(
//                 "Deadline %s".localize().format([
//                   DateTime.fromMillisecondsSinceEpoch(endDate)
//                       .format("yyyy/MM/dd")
//                 ]),
//                 color: context.theme.errorColor,
//                 margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//               ),
//             const Space.height(10),
//             if (answers.isEmpty)
//               MessageBox(
//                 "回答がまだありません。",
//                 color: context.theme.dividerColor,
//                 margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//               )
//             else
//               DividHeadline(
//                 "List of %s answers".localize().format([name]),
//               ),
//           ],
//           builder: (context, item, index) {
//             return [
//               ListItem(
//                 title: Text(item.get("${Const.user}${module.nameKey}", "")),
//                 subtitle: Text(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     item.get(
//                       module.createdTimeKey,
//                       now.millisecondsSinceEpoch,
//                     ),
//                   ).format("yyyy/MM/dd HH:mm"),
//                 ),
//                 onTap: () {
//                   context.rootNavigator.pushNamed(
//                     "/${module.routePath}/${context.get("question_id", "")}/answer/${item.get(Const.uid, "")}",
//                     arguments: RouteQuery.fullscreenOrModal,
//                   );
//                 },
//               ),
//             ];
//           },
//         );
//       }(),
//     );
//   }
// }

// class QuestionnaireModuleAnswerDetail
//     extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleAnswerDetail();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     int i = 0;
//     final questions = ref.watchCollectionModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.questionPath}",
//     );
//     final answer = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.answerPath}/${context.get("answer_id", "")}",
//     );
//     final user = ref.watchDocumentModel(
//       "${module.userPath}/${answer.get(Const.user, "empty")}",
//     );

//     return UIScaffold(
//       waitTransition: true,
//       loadingFutures: [
//         questions.loading,
//         answer.loading,
//         user.loading,
//       ],
//       appBar: UIAppBar(
//         title: Text(
//           "%s answers".localize().format([user.get(module.nameKey, "")]),
//         ),
//       ),
//       body: UIListBuilder<DynamicDocumentModel>(
//         padding: const EdgeInsets.only(top: 12),
//         source: questions,
//         builder: (contex, item, index) {
//           i++;
//           return [
//             QuestionnaireModuleListTile(
//               index: i,
//               question: item,
//               answer: answer,
//               canEdit: true,
//               onlyView: true,
//             ),
//           ];
//         },
//       ),
//     );
//   }
// }

// class QuestionnaireModuleQuestionView
//     extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleQuestionView();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     int i = 0;
//     final form = ref.useForm();
//     final question = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("question_id", "")}",
//     );
//     final questions = ref.watchCollectionModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.questionPath}",
//     );
//     final answer = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.answerPath}/${context.model?.userId}",
//     );
//     final name = question.get(module.nameKey, "");
//     final text = question.get(module.textKey, "");
//     final endDate = question.get(module.endTimeKey, 0);

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(name),
//         actions: [
//           if (module.questioner && !context.isMobileOrModal)
//             IconButton(
//               onPressed: () {
//                 context.rootNavigator.pushNamed(
//                   "/${module.routePath}/${context.get("question_id", "")}/question/edit",
//                   arguments: RouteQuery.fullscreenOrModal,
//                 );
//               },
//               icon: const Icon(Icons.add),
//             ),
//         ],
//       ),
//       body: questions.isEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: Text(
//                   module.questioner
//                       ? "The question is empty. Please set a new question by clicking the 'Add New' button."
//                           .localize()
//                       : "The question has not been set yet. Please wait for a while until the question is set."
//                           .localize(),
//                 ),
//               ),
//             )
//           : FormBuilder(
//               key: form.key,
//               padding: const EdgeInsets.all(0),
//               children: [
//                 if (text.isNotEmpty)
//                   MessageBox(
//                     text,
//                     color: context.theme.dividerColor,
//                     margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                   ),
//                 if (answer.isNotEmpty)
//                   MessageBox(
//                     "Already responding".localize(),
//                     icon: Icons.check_circle,
//                     color: context.theme.primaryColor,
//                     margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                   )
//                 else if (endDate > 0)
//                   MessageBox(
//                     "Deadline %s".localize().format([
//                       DateTime.fromMillisecondsSinceEpoch(endDate)
//                           .format("yyyy/MM/dd")
//                     ]),
//                     color: context.theme.errorColor,
//                     margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                   ),
//                 const Space.height(10),
//                 ...questions.mapListenable((item) {
//                   i++;
//                   return QuestionnaireModuleListTile(
//                     index: i,
//                     question: item,
//                     answer: answer,
//                     canEdit: module.questioner,
//                     onlyView: false,
//                   );
//                 }),
//                 const Divid(),
//                 const Space.height(100),
//               ],
//             ),
//       floatingActionButton: () {
//         if (!module.questioner && questions.isEmpty) {
//           return null;
//         }
//         if (!context.isMobileOrModal) {
//           return null;
//         }
//         return FloatingActionButton.extended(
//           onPressed: () async {
//             if (module.questioner) {
//               context.navigator.pushNamed(
//                 "/${module.routePath}/${context.get("question_id", "")}/question/edit",
//                 arguments: RouteQuery.fullscreenOrModal,
//               );
//             } else {
//               if (!form.validate()) {
//                 return;
//               }
//               await context.model?.saveDocument(answer).showIndicator(context);
//               UIDialog.show(
//                 context,
//                 title: "Success".localize(),
//                 text:
//                     "%s is completed.".localize().format(["Answer".localize()]),
//                 submitText: "Back".localize(),
//                 onSubmit: () {
//                   context.navigator.pop();
//                 },
//               );
//             }
//           },
//           icon: Icon(module.questioner ? Icons.add : Icons.check),
//           label: Text(
//             module.questioner ? "Add".localize() : "Submit".localize(),
//           ),
//         );
//       }(),
//     );
//   }
// }

// class QuestionnaireModuleListTile extends ModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleListTile({
//     required this.index,
//     required this.question,
//     required this.answer,
//     required this.canEdit,
//     required this.onlyView,
//   });
//   final bool onlyView;
//   final int index;
//   final bool canEdit;
//   final DynamicDocumentModel question;
//   final DynamicDocumentModel answer;

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     final uid = question.get(Const.uid, "");
//     final type = question.get(module.typeKey, "").quenstionFormType;
//     final name = question.get(module.nameKey, "");
//     final required = question.get(module.requiredKey, false);
//     final answers = answer.get(module.answerKey, {});
//     switch (type) {
//       case _QuenstionFormType.selection:
//         final select = question.get(module.selectionKey, {});

//         return InkWell(
//           onTap: canEdit && !onlyView
//               ? () {
//                   context.rootNavigator.pushNamed(
//                     "/${module.routePath}/${context.get("question_id", "")}/question/$uid",
//                     arguments: RouteQuery.fullscreenOrModal,
//                   );
//                 }
//               : null,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               DividHeadline(
//                 "Question No.%s".localize().format([index]),
//                 icon: required ? Icons.check_circle : null,
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Text(name),
//               ),
//               if (!canEdit) ...[
//                 Divid(
//                   indent: 12,
//                   endIndent: 12,
//                   color: context.theme.dividerColor.withOpacity(0.5),
//                 ),
//                 FormItemDropdownField(
//                   dense: true,
//                   allowEmpty: !required,
//                   items: {...select},
//                   hintText: "Please select your %s"
//                       .localize()
//                       .format(["Answer".localize().toLowerCase()]),
//                   controller: ref.useTextEditingController(
//                     "answer",
//                     answers.get(uid, ""),
//                   ),
//                   onSaved: (value) {
//                     final answers =
//                         Map<String, dynamic>.from(answer.get("answer", {}));
//                     answers[uid] = value;
//                     answer["answer"] = answers;
//                   },
//                 ),
//               ] else if (onlyView) ...[
//                 Divid(
//                   indent: 12,
//                   endIndent: 12,
//                   color: context.theme.dividerColor.withOpacity(0.5),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   child: Text(answers.get(uid, "")),
//                 ),
//               ],
//             ],
//           ),
//         );
//       default:
//         return InkWell(
//           onTap: canEdit && !onlyView
//               ? () {
//                   context.rootNavigator.pushNamed(
//                     "/${module.routePath}/${context.get("question_id", "")}/question/$uid",
//                     arguments: RouteQuery.fullscreenOrModal,
//                   );
//                 }
//               : null,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               DividHeadline(
//                 "Question No.%s".localize().format([index]),
//                 icon: required ? Icons.check_circle : null,
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Text(name),
//               ),
//               if (!canEdit) ...[
//                 Divid(
//                   indent: 12,
//                   endIndent: 12,
//                   color: context.theme.dividerColor.withOpacity(0.5),
//                 ),
//                 FormItemTextField(
//                   dense: true,
//                   allowEmpty: !required,
//                   hintText: "Please input your %s"
//                       .localize()
//                       .format(["Answer".localize().toLowerCase()]),
//                   errorText:
//                       "No input %s".localize().format(["Answer".localize()]),
//                   controller: ref.useTextEditingController(
//                     "answer",
//                     answers.get(uid, ""),
//                   ),
//                   onSaved: (value) {
//                     final answers =
//                         Map<String, dynamic>.from(answer.get("answer", {}));
//                     answers[uid] = value;
//                     answer["answer"] = answers;
//                   },
//                 ),
//               ] else if (onlyView) ...[
//                 Divid(
//                   indent: 12,
//                   endIndent: 12,
//                   color: context.theme.dividerColor.withOpacity(0.5),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   child: Text(answers.get(uid, "")),
//                 ),
//               ],
//             ],
//           ),
//         );
//     }
//   }
// }

// class QuestionnaireModuleQuestionEdit
//     extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleQuestionEdit();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     final form = ref.useForm("item_id");
//     final item = ref.watchDocumentModel(
//       "${module.queryPath}/${context.get("question_id", "")}/${module.questionPath}/${form.uid}",
//     );
//     final name = item.get(module.nameKey, "");
//     final type = item.get(module.typeKey, Const.text);
//     final required = item.get(module.requiredKey, false);
//     final view = ref.state("viewType", type);
//     final selection = item.get(module.selectionKey, {});
//     final selectionTextEditingControllers =
//         ref.useTextEditingControllerMap("selection", selection);

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
//                     context.navigator.pop();
//                   },
//                 );
//               },
//             ),
//         ],
//       ),
//       body: FormBuilder(
//         key: form.key,
//         padding: const EdgeInsets.all(0),
//         children: [
//           const Space.height(16),
//           DividHeadline("Question".localize()),
//           FormItemTextField(
//             dense: true,
//             hintText: "Input %s".localize().format(["Question".localize()]),
//             errorText: "No input %s".localize().format(["Question".localize()]),
//             keyboardType: TextInputType.multiline,
//             controller: ref.useTextEditingController(
//               module.nameKey,
//               name,
//             ),
//             minLines: 3,
//             maxLines: 5,
//             onSaved: (value) {
//               context[module.nameKey] = value;
//             },
//           ),
//           DividHeadline("Required".localize()),
//           FormItemDropdownField(
//             dense: true,
//             items: {
//               "yes": "Required".localize(),
//               "no": "Optional".localize(),
//             },
//             controller: ref.useTextEditingController(
//               module.requiredKey,
//               required ? "yes" : "no",
//             ),
//             onSaved: (value) {
//               context[module.requiredKey] = value == "yes";
//             },
//           ),
//           DividHeadline("Type".localize()),
//           FormItemDropdownField(
//             dense: true,
//             items: {
//               ..._QuenstionFormType.values.toMap(
//                 key: (e) => (e as _QuenstionFormType).text,
//                 value: (e) => (e as _QuenstionFormType).name,
//               )
//             },
//             controller: ref.useTextEditingController(
//               module.typeKey,
//               type,
//             ),
//             onChanged: (value) {
//               view.value = value ?? Const.text;
//             },
//             onSaved: (value) {
//               context[module.typeKey] = value;
//             },
//           ),
//           if (view.value == _QuenstionFormType.selection.text) ...[
//             DividHeadline("Choices".localize()),
//             AppendableBuilder(
//               initialValues: selection.keys.cast<String>(),
//               builder: (context, id, onAdd, onRemove) {
//                 return AppendableBuilderItem(
//                   onPressed: () {
//                     onRemove(id);
//                   },
//                   child: FormItemTextField(
//                     dense: true,
//                     hintText:
//                         "Input %s".localize().format(["Choices".localize()]),
//                     errorText:
//                         "No input %s".localize().format(["Choices".localize()]),
//                     keyboardType: TextInputType.text,
//                     controller: selectionTextEditingControllers[id],
//                     onSaved: (value) {
//                       final select = context.get(module.selectionKey, {});
//                       select[id] = value;
//                       context[module.selectionKey] = select;
//                     },
//                   ),
//                 );
//               },
//               child: (context, children, onAdd, onRemove) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ...children,
//                     IconButton(
//                       icon: const Icon(
//                         Icons.add,
//                       ),
//                       onPressed: () {
//                         onAdd.call();
//                       },
//                     ),
//                   ],
//                 );
//               },
//             )
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

//           final type = context.get(module.typeKey, Const.text);
//           item[module.nameKey] = context.get(module.nameKey, "");
//           item[module.requiredKey] = context.get(module.requiredKey, false);
//           item[module.typeKey] = context.get(module.typeKey, Const.text);
//           if (type == _QuenstionFormType.selection.text) {
//             item[module.selectionKey] = context.get(module.selectionKey, {});
//           }
//           await context.model?.saveDocument(item).showIndicator(context);
//           context.navigator.pop();
//         },
//         icon: const Icon(Icons.check),
//         label: Text("Submit".localize()),
//       ),
//     );
//   }
// }

// class QuestionnaireModuleEdit extends PageModuleWidget<QuestionnaireModule> {
//   const QuestionnaireModuleEdit();

//   @override
//   Widget build(
//     BuildContext context,
//     WidgetRef ref,
//     QuestionnaireModule module,
//   ) {
//     final form = ref.useForm("question_id");
//     final item = ref.watchDocumentModel("${module.queryPath}/${form.uid}");
//     final name = item.get(module.nameKey, "");
//     final text = item.get(module.textKey, "");
//     final endTime = item.get(module.endTimeKey, 0);

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
//                     context.navigator.pop();
//                     context.navigator.pop();
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
//           const Space.height(20),
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
//           DividHeadline("End date".localize()),
//           FormItemDateTimeField(
//             dense: true,
//             allowEmpty: true,
//             hintText: "Input %s".localize().format(["End date".localize()]),
//             errorText: "No input %s".localize().format(["End date".localize()]),
//             controller: ref.useTextEditingController(
//               module.endTimeKey,
//               form.select(FormItemDateTimeField.formatDate(endTime), ""),
//             ),
//             type: FormItemDateTimeFieldPickerType.date,
//             onSaved: (value) {
//               context[module.endTimeKey] = value?.millisecondsSinceEpoch ?? 0;
//             },
//           ),
//           const Divid(),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           if (!form.validate()) {
//             return;
//           }

//           item[module.nameKey] = context.get(module.nameKey, "");
//           item[module.textKey] = context.get(module.textKey, "");
//           item[module.endTimeKey] = context.get(module.endTimeKey, 0);
//           await context.model?.saveDocument(item).showIndicator(context);
//           context.navigator.pop();
//         },
//         label: Text("Submit".localize()),
//         icon: const Icon(Icons.check),
//       ),
//     );
//   }
// }
