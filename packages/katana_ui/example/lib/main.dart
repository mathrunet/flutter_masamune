// import "package:flutter/material.dart";
// import "package:katana_auth/katana_auth.dart";

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AuthAdapterScope(
//       adapter: const RuntimeAuthAdapter(),
//       child: MaterialApp(
//         home: const AuthPage(),
//         title: "Flutter Demo",
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//       ),
//     );
//   }
// }

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<StatefulWidget> createState() => AuthPageState();
// }

// class AuthPageState extends State<AuthPage> {
//   final auth = Authentication();

//   @override
//   void initState() {
//     super.initState();
//     auth.addListener(_handledOnUpdate);
//   }

//   void _handledOnUpdate() {
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     auth.removeListener(_handledOnUpdate);
//     auth.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("App Demo")),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text("SignedIn: ${auth.isSignedIn}"),
//           ),
//           ListTile(
//             title: Text("Anonymously: ${auth.isAnonymously}"),
//           ),
//           ListTile(
//             title: Text("ID: ${auth.userId}"),
//           ),
//           ListTile(
//             title: Text("Email: ${auth.userEmail}"),
//           ),
//           ListTile(
//             title: Text("Phone: ${auth.userPhoneNumber}"),
//           ),
//           ListTile(
//             title: Text("Providers: ${auth.activeProviderIds.join("\n")}"),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (_) {
//               return AuthControlPage(auth: auth);
//             },
//           ));
//         },
//         child: const Icon(Icons.person),
//       ),
//     );
//   }
// }

// class AuthControlPage extends StatelessWidget {
//   const AuthControlPage({
//     required this.auth,
//     super.key,
//   });

//   final Authentication auth;

//   @override
//   Widget build(BuildContext context) {
//     final navigator = Navigator.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Auth Control"),
//       ),
//       body: ListView(
//         children: [
//           if (!auth.isSignedIn) ...[
//             if (!auth.isWaitingConfirmation) ...[
//               ListTile(
//                 title: const Text("SignIn anonymously"),
//                 onTap: () async {
//                   await auth.signIn(AnonymouslyAuthQuery.signIn());
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("Register with email and password"),
//                 onTap: () async {
//                   await auth.register(
//                     EmailAndPasswordAuthQuery.register(
//                       email: "test@email.com",
//                       password: "12345678",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("SignIn with email and password"),
//                 onTap: () async {
//                   await auth.signIn(
//                     EmailAndPasswordAuthQuery.signIn(
//                       email: "test@email.com",
//                       password: "12345678",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("SignIn with email link"),
//                 onTap: () async {
//                   await auth.signIn(
//                     EmailLinkAuthQuery.signIn(
//                       email: "test@email.com",
//                       url: "https://test.com",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("SignIn with sms"),
//                 onTap: () async {
//                   await auth.signIn(
//                     SmsAuthQuery.signIn(
//                       phoneNumber: "01234567890",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//             ] else ...[
//               ListTile(
//                 title: const Text("Confirm signIn with email link"),
//                 onTap: () async {
//                   await auth.confirmSignIn(
//                     EmailLinkAuthQuery.confirmSignIn(
//                       url: "https://test.com",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("Confirm signIn with sms"),
//                 onTap: () async {
//                   await auth.confirmSignIn(
//                     SmsAuthQuery.confirmSignIn(
//                       body: "012345",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//             ],
//           ] else ...[
//             if (!auth.isWaitingConfirmation) ...[
//               ListTile(
//                 title: const Text("Change email"),
//                 onTap: () async {
//                   await auth.change(EmailAndPasswordAuthQuery.changeEmail(
//                       email: "changed@email.com"));
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("Change password"),
//                 onTap: () async {
//                   await auth.change(
//                       EmailAndPasswordAuthQuery.changePassword(password: ""));
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("Change phoneNumber"),
//                 onTap: () async {
//                   await auth.change(SmsAuthQuery.changePhoneNumber(
//                       phoneNumber: "1234567890"));
//                   navigator.pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("SignOut"),
//                 onTap: () async {
//                   await auth.signOut();
//                   navigator.pop();
//                 },
//               ),
//             ] else ...[
//               ListTile(
//                 title: const Text("Confirm changing Phone number with sms"),
//                 onTap: () async {
//                   await auth.confirmChange(
//                     SmsAuthQuery.confirmChangePhoneNumber(
//                       body: "012345",
//                     ),
//                   );
//                   navigator.pop();
//                 },
//               ),
//             ],
//           ],
//         ],
//       ),
//     );
//   }
// }
