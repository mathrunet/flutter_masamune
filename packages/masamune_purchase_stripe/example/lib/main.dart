// // Dart imports:

// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:masamune/masamune.dart';
// import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';

// final List<MasamuneAdapter> masamuneAdapters = [
//   StripePurchaseMasamuneAdapter(
//       callbackHost: Uri.parse(""), publicAPIKey: '', supportEmail: ''),
// ];

// void main() {
//   runMasamuneApp(
//     masamuneAdapters: masamuneAdapters,
//     (adapters) => MasamuneApp(
//       home: const AgoraPage(),
//       title: "Flutter Demo",
//       masamuneAdapters: adapters,
//       theme: AppThemeData(
//         primary: Colors.blue,
//       ),
//     ),
//   );
// }

// class AgoraPage extends StatefulWidget {
//   const AgoraPage({super.key});

//   @override
//   State<StatefulWidget> createState() => AgoraPagePageState();
// }

// class AgoraPagePageState extends State<AgoraPage> {
//   final AgoraController _controller = AgoraController("test_channel");

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(_handledOnUpdate);
//   }

//   void _handledOnUpdate() {
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.removeListener(_handledOnUpdate);
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("App Demo"),
//       ),
//       body: GridBuilder<AgoraUser>.count(
//         crossAxisCount: 2,
//         source: _controller.value ?? <AgoraUser>[],
//         builder: (context, item, index) {
//           return AgoraScreen(value: item);
//         },
//       ),
//       floatingActionButton: !_controller.connected
//           ? FloatingActionButton(
//               onPressed: () {
//                 _controller.disconnect();
//               },
//               child: const Icon(Icons.login),
//             )
//           : FloatingActionButton(
//               onPressed: () {
//                 _controller.connect(userName: "user_name");
//               },
//               child: const Icon(Icons.logout),
//             ),
//     );
//   }
// }
