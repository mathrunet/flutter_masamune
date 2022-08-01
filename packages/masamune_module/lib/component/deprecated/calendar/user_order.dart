// import 'package:masamune_module/masamune_module.dart';

// @deprecated
// class CalendarModuleUserOrder extends PageModuleWidget<CalendarModule> {
//   const CalendarModuleUserOrder({
//     required this.title,
//     this.subtitle,
//     this.queryPath = "order",
//     this.userQuery,
//   });
//   final String title;
//   final String? subtitle;
//   final String queryPath;
//   final ModelQuery? userQuery;

//   @override
//   Widget build(BuildContext context, WidgetRef ref, CalendarModule module) {
//     final now = ref.useNow();
//     final orderList = <DynamicMap>[];
//     final date = context.get("date_id", now.toDateID()).toDateTime();
//     final users = ref.watchCollectionModel(userQuery?.value ?? module.userPath);

//     final orders = ref.watchCollectionModel(queryPath);
//     orders.sort(
//       (a, b) => b.get(module.startTimeKey, 0) - a.get(module.startTimeKey, 0),
//     );
//     final order = orders.firstWhereOrNull((element) {
//           return element.get(module.startTimeKey, 0) <=
//               date.millisecondsSinceEpoch;
//         }) ??
//         orders.lastOrNull;
//     final userOrder = order.getAsList<DynamicMap>(module.userKey, []);

//     for (final o in userOrder) {
//       final user = users.firstWhereOrNull((item) => item.uid == o.uid);
//       if (user == null) {
//         continue;
//       }
//       orderList.add(user);
//     }
//     for (final user in users) {
//       if (orderList.any((element) => element.uid == user.uid)) {
//         continue;
//       }
//       orderList.add(user);
//     }

//     return UIScaffold(
//       waitTransition: true,
//       appBar: UIAppBar(
//         title: Text(title),
//         subtitle: subtitle != null ? Text(subtitle!) : null,
//       ),
//       loadingFutures: [
//         orders.loading,
//         users.loading,
//       ],
//       body: ReorderableListBuilder<DynamicMap>(
//         onReorder: (o, n, item, reordered) async {
//           if (order == null) {
//             final doc = context.model?.createDocument(orders);
//             if (doc == null) {
//               return;
//             }
//             doc[module.userKey] = reordered.mapAndRemoveEmpty((item) {
//               return {
//                 Const.uid: item.uid,
//               };
//             });
//             doc[module.startTimeKey] = date.millisecondsSinceEpoch;
//             await context.model?.saveDocument(doc).showIndicator(context);
//           } else if (order.get(module.startTimeKey, 0) !=
//               date.millisecondsSinceEpoch) {
//             final doc = context.model?.createDocument(orders);
//             if (doc == null) {
//               return;
//             }
//             doc[module.userKey] = reordered.mapAndRemoveEmpty((item) {
//               return {
//                 Const.uid: item.uid,
//               };
//             });
//             doc[module.startTimeKey] = date.millisecondsSinceEpoch;
//             await context.model?.saveDocument(doc).showIndicator(context);
//           } else {
//             order[module.userKey] = reordered.mapAndRemoveEmpty((item) {
//               return {
//                 Const.uid: item.uid,
//               };
//             });
//             order[module.startTimeKey] = date.millisecondsSinceEpoch;
//             await context.model?.saveDocument(order).showIndicator(context);
//           }
//         },
//         source: orderList.toList(),
//         builder: (context, item, index) {
//           return [
//             ListItem(
//               leading: Text(
//                 (index + 1).toString(),
//                 style: const TextStyle(fontSize: 20),
//               ),
//               title: Text(item.get(module.nameKey, "")),
//               trailing: const Icon(Icons.reorder),
//             ),
//           ];
//         },
//       ),
//     );
//   }
// }
