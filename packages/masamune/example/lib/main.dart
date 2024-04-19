// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';

part 'main.theme.dart';
part 'main.localize.dart';

/// App Title.
const title = "";

/// Initial page query.
const initialQuery = null;

/// App Model.
///
/// By replacing this with another adapter, the data storage location can be changed.
const modelAdapter = RuntimeModelAdapter();

/// App Auth.
///
/// Changing to another adapter allows you to change to another authentication mechanism.
const authAdapter = RuntimeAuthAdapter();

/// App Storage.
///
/// Changing to another adapter allows you to change to another storage mechanism.
const storageAdapter = LocalStorageAdapter();

/// App Functions.
///
/// Changing to another adapter allows you to change to another functions mechanism.
const functionsAdapter = RuntimeFunctionsAdapter();

/// App Theme.
///
/// ```dart
/// theme.color.primary   // Primary color.
/// theme.text.bodyMedium // Medium body text style.
/// theme.asset.xxx       // xxx image.
/// theme.font.xxx        // xxx font.
/// ```
@appTheme
final theme = AppThemeData(
  primary: Colors.blue,
  secondary: Colors.cyan,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
);

/// App Router.
///
/// ```dart
/// router.push(Page.query());  // Push page to Page.
/// router.pop();               // Pop page.
/// ```
final router = AppRouter(
  boot: null,
  initialQuery: initialQuery,
  redirect: [],
  pages: [],
);

/// App Localization.
///
/// ```dart
/// l().xxx  // Localization for xxx.
/// ```
final l = AppLocalize();

@GoogleSpreadSheetLocalize(
  [
    "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808"
  ],
  version: 1,
)
class AppLocalize extends _$AppLocalize {}

/// App Ref.
///
/// ```dart
/// appRef.controller(Controller.query()); // Get a controller.
/// appRef.model(Model.query());           // Get a model.
/// ```
final appRef = AppRef();

/// App authentication.
///
/// ```dart
/// appAuth.signIn(
///   EmailAndPasswordSignInAuthProvider(
///     email: email,
///     password: password,
///   ),
/// );
/// ```
final appAuth = Authentication();

/// App server functions.
///
/// It is used in conjunction with the server side.
///
/// ```dart
/// appFunction.notification(
///   title: "Notification",
///   text: "Notification text",
///   target: "Topic",
/// );
/// ```
final appFunction = Functions();

/// App Flavor.
const flavor = String.fromEnvironment("FLAVOR");

/// App.
void main() {
  runMasamuneApp(
    (adapters) => MasamuneApp(
      title: title,
      appRef: appRef,
      theme: theme,
      routerConfig: router,
      localize: l,
      authAdapter: authAdapter,
      modelAdapter: modelAdapter,
      storageAdapter: storageAdapter,
      functionsAdapter: functionsAdapter,
      masamuneAdapters: adapters,
    ),
  );
}
