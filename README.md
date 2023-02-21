<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Framework</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

# Introduction

Please see here first.

![Implementation sample](https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/packages/masamune/.github/images/sample.gif)

- Sample code for the video is available [here](https://github.com/mathrunet/flutter_sample_memo_test).

Here is a video of a notepad application being completed in just 5 minutes from a completely empty state.

By using the `Masamune framework`, it is possible to reduce most of the coding that is done in application development.

This framework focuses on the following functions

- Generation of code templates by CLI (command line interface) tools
- Automatic generation of additional code by [build_runner](https://pub.dev/packages/build_runner)

In other words, by having the majority of the code generated mechanically, the human coding part is reduced as much as possible.

In addition, the human coding part is almost type-safe, allowing implementation without hesitation with the support of the IDE's suggestion function and other features.

The following benefits can be enjoyed by offering these features

- **Faster implementation**
    - Faster implementation because fewer parts are actually coded.
- **Fewer coding errors**
    - Since fewer parts are actually coded, the probability of making a mistake is also reduced by that amount.
- **Easier to follow the source code**
    - It is easier to follow the source later after some time has passed because there is less actual coding to do.
- **Differences in codes between people are difficult to distinguish**
    - Coding is done according to the generated template, so it is difficult to have different codes for different people.
- **Facilitates team development**
    - `Since it is difficult to differentiate codes among people`, it is easier to check codes and assign personnel within the team.

In addition, this framework provides the following functions to support application development from many angles

- `Routing`
    - Web URL support, conditional redirection, and nested navigation are also available.
- `Database`
    - NoSQL database based on Firestore structure.
    - Local and Firestore can be easily switched by switching adapters.
- `State management`
    - State management in a simple form like [flutter_hooks](https://pub.dev/packages/flutter_hooks).
- `Translation`
    - Translation management using Google Spreadsheets.
- `Theme management`
    - You can define the colors and text of the theme.
    - Image and font files can be retrieved type-safe in code.
- `Shared preferences`
    - A data store using SharedPreferences is available in addition to the databases listed above.
- `Form building`
    - Support data input from users, mainly forms, from the UI level.
- `UI support`
    - It provides functions to implement list widgets and simple modals that can update widgets with less load when data is updated.
- `Firebase/Firestore support`
    - Provides the ability to easily switch to Firebase features such as `Authentication`, `Cloud Firestore`, and `Cloud Storage`.

By using this framework, for example, a simple CRUD application requires only the following parts to be implemented.

- `DataScheme`
    - Only the type and variable name (and possibly the initial value) need be defined.
- `View`
    - Build the application design with widgets. (Support is provided for some elements, such as forms.)
    - Data binding, for example, can be easily performed.

# Installation

Install the `CLI` with the following command.

```bash
flutter pub global activate katana_cli
```

To install Masamune Framework in an existing project, add the package with the following command.

[build_runner](https://pub.dev/packages/build_runner), [freezed](https://pub.dev/packages/freezed), and [json_serializable](https://pub.dev/packages/json_serializable) must also be installed.

```bash
flutter pub add masamune
flutter pub add json_annotation
flutter pub add freezed_annotation
flutter pub add --dev build_runner
flutter pub add --dev masamune_builder
flutter pub add --dev json_serializable
flutter pub add --dev freezed
```

# Project Creation

Execute the following command in the folder where the project was created.

The `Application ID` should include the ID in the **reverse domain** (com.test.myapplication).

```bash
katana create [Application ID(e.g. com.test.myapplication)]
```

Basically, it is the same as `flutter create`, but the following changes are made automatically.

- You can automatically place image files under the `assets` folder.
- `katana.yaml` will be placed.
- Required packages are installed automatically.
- The launcher settings for VSCode are automatically set.
- `main.dart` is rewritten and code generation is performed by [build_runner](https://pub.dev/packages/build_runner).

# Code Change Monitoring

It uses build_runner's monitoring function to detect changes in the target code and automatically generates the code immediately if any changes are made.

The code analysis of build_runner itself is very slow, so the developer experience would be much better if it were constantly monitored.

To monitor the code, execute the following command in a **separate terminal**.

```bash
katana code watch
```

When the command is typed, it enters the monitoring state and is left alone.

(If you do not do this, you will not be able to type the code template creation command described below, so please start it in a different terminal.)

If code monitoring is not performed, enter the following command as appropriate.

```bash
katana code generate
```

# Implementation

## Page

### Create Page

To create a screen (page) for the application, execute the following command.

```bash
katana code page [Page name]
```

A file named `(Page name).dart` will be created under `lib/pages`.

A class named `(Page name)Page` is created as follows

Describe the contents of the screen UI inside the `build`, just as you would with a StatelessWidget or a StatefulWidget.

```dart
// test.dart

// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';

part 'test.page.dart';

@immutable
// TODO: Set the path for the page.
@PagePath("test")
class TestPage extends PageScopedWidget {
  const TestPage({
    super.key,
    // TODO: Set parameters for the page.
    
  });

  // TODO: Set parameters for the page in the form [final String xxx].
  

  /// Used to transition to the TestPage screen.
  ///
  /// ```dart
  /// router.push(TestPage.query(parameters));    // Push page to TestPage.
  /// router.replace(TestPage.query(parameters)); // Push page to TestPage.
  /// ```
  @pageRouteQuery
  static const query = _$TestPageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // TODO: Implement the variable loading process.
    

    // Describes the structure of the page.
    // TODO: Implement the view.
    return Scaffold();
  }
}
```

You can specify the deep link path by specifying the path in `@PagePath("")`.

```dart
@PagePath("user/:user_id")
```

If the page requires an argument, simply add the parameter as follows.

```dart
const TestPage({
  super.key,
  // TODO: Set parameters for the page.
  required this.name,
  this.text,
});

// TODO: Set parameters for the page in the form [final String xxx].
final String name;
final String? text;

~~~~~~~~~~~~~~~~~~
```

### Page Transition

Page transitions are performed using the `router` defined in main.dart.

You can specify a `query` already described in the created class to transition to that page.

```dart
// Transition to TestPage
router.push(TestPage.query());

// Page Replacements
router.replace(TestPage.query());

// Back to Previous Page
router.pop();
```

## Initial Page Setup

You can set the page when the application is launched by passing the query you want to set for the initial page to the `initialQuery` defined in main.dart.

```bash
/// Initial page query.
// TODO: Define the initial page query of the application.
final initialQuery = TestPage.query();
```

To learn more about the other features listed below, please visit the package details page.

- How to specify AppRouter
- Deep linking support
- Nest Navigation

katana_router

[https://pub.dev/packages/katana_router](https://pub.dev/packages/katana_router)

## Data model

### Data structure

The Masamune framework can store data with reference to the Firestore data structure.

[https://pub.dev/packages/katana_model#structure](https://pub.dev/packages/katana_model#structure)

### Collection (Document) model creation

To create a collection model, enter the following command

```bash
katana code collection [Collection name]
```

A file named `(Collection name).dart` will be created under `lib/models`.

A class named `(Collection name)Model` is created as follows

If a collection model is created with the above command, a document model will also be available with the same data scheme.

```dart
// test.dart

// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'test.m.dart';
part 'test.g.dart';
part 'test.freezed.dart';

/// Alias for ModelRef<TestModel>.
/// 
/// When defining parameters for other Models, you can define them as follows
/// 
/// ```dart
/// @refParam TestModelRef test
/// ```
typedef TestModelRef = ModelRef<TestModel>?;

/// Value for model.
@freezed
@formValue
@immutable
// TODO: Set the path for the collection.
@CollectionModelPath("test")
class TestModel with _$TestModel {
  const factory TestModel({
     // TODO: Set the data schema.
     
  }) = _TestModel;
  const TestModel._();

  factory TestModel.fromJson(Map<String, Object?> json) => _$TestModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(TestModel.document(id));      // Get the document.
  /// ref.model(TestModel.document(id))..load(); // Load the document.
  /// ```
  static const document = _$TestModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(TestModel.collectoin());      // Get the collection.
  /// ref.model(TestModel.collection())..load(); // Load the collection.
  /// ```
  static const collection = _$TestModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(TestModel.form());     // Get the form controller.
  /// ```
  static const form = _$TestModelFormQuery();
}
```

If you do not need a collection, but only a document model, you can create one with the following command.

```bash
katana code document [Document name]
```

Specify the data path by specifying the contents of `@CollectionModelPath("")` (`@DocumentModelPath("")`).

As with Firestore, there are restrictions on path hierarchy.

(Odd: collection, Even: document)

```dart
@CollectionModelPath("user")
```

Also, list the variables that will be the data scheme in the factory constructor.

This is the content of the data that can be handled in this collection (document).

```dart
const factory TestModel({
   // TODO: Set the data schema.
   required String name,
   String? test,
}) = _TestModel;
```

### Using Model

The created model can be handled by using `ref.model` from `PageRef (WidgetRef)` passed in the `build` method if it is within a page or widget created with `ScopedWidget` or `Scoped`.

The actual object can be obtained by passing a `collection` or `document` defined in the model created in `ref.model`.

Data can also be loaded from the database by executing the `load` method of the retrieved object.

When loading is complete or data is rewritten, the widget that executed `ref.model` is rebuilt.

```dart
@override
Widget build(BuildContext context, PageRef ref) {
  // Describes the process of loading
  // and defining variables required for the page.
  // TODO: Implement the variable loading process.
  final testModelCollection = ref.model(TestModel.collection()); // Obtain a collection of TestModel.
  testModelCollection.load();  // Load model data

  ~~~~~~~~~
}
```

Also, if you want to use it outside of a page or widget, you can use it in an `appRef` defined in main.dart.

```dart
final testModelCollection = appRef.model(TestModel.collection());
```

To learn more about the other features listed below, please visit the package details page.

- Editing and Deleting data
- Specifying a filter query for data
- Sort function for collections
- Text search
- Specify and retrieve relational data
- Special Field Values

katana_model

[https://pub.dev/packages/katana_model](https://pub.dev/packages/katana_model)

## Controller

Create a controller when you want to use a controller already provided by Flutter, such as `ScrollController` or `TextEditingController`, in a page or widget, or when you want to make minor adjustments such as bundling data models.

```bash
katana code controller [Controller name]
```

A file named `(Page name).dart` will be created under `lib/controllers`.

A class named `(Page name)Controller` is created as follows.

```dart
// test.dart

// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';

part 'test.m.dart';

/// Controller.
@Controller(autoDisposeWhenUnreferenced: true)
class TestController extends ChangeNotifier {
  TestController(
    // TODO: Define some arguments.
    
  );

  // TODO: Define fields and processes.
  

  /// Query for TestController.
  ///
  /// ```dart
  /// appRef.conroller(TestController.query(parameters));   // Get from application scope.
  /// ref.app.conroller(TestController.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(TestController.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$TestControllerQuery();
}
```

When using `PageRef (WidgetRef)`, you can obtain the actual object by passing `query` to `ref.(page/app).controller()`.

If defined in `ref.app.controller`, the controller is destroyed when the referenced widget reaches 0.

If defined in `ref.page.controller`, the controller will also be destroyed when the page is destroyed.

```dart
@override
Widget build(BuildContext context, PageRef ref) {
  // Describes the process of loading
  // and defining variables required for the page.
  // TODO: Implement the variable loading process.
  final testController = ref.page.controller(TestController.query()); // Obtain TestController.   

  ~~~~~~~~~
}
```

Internally, it inherits from `ChangeNotifier`, so when `notifyLisnteners()` is executed, the loaded widget is rebuilt.

It can also be used from outside the widget using `appRef`.

In the case of `appRef`, it is managed across pages. (Same as `ref.app.controller`)

```dart
final testController = appRef.controller(TestController.query());
```

If you want to bundle multiple controllers, enter the following command to create a controller group.

```bash
katana code group [ControllerGroup name]
```

## State management

Basically, I think the above `ref.model` and `ref.(page/app).controller` can cover most of the state management.

State management can also be extended, so please see the package details page for more information.

katana_scoped

[https://pub.dev/packages/katana_model](https://pub.dev/packages/katana_model)

## Translation

Translation will be done through a Google spreadsheet.

Please see below for preparation.

[https://pub.dev/packages/katana_localization#advance-preparation](https://pub.dev/packages/katana_localization#advance-preparation)

To update the translation, AppLocalize is defined in main.dart, so update the `version` there.

```dart
@GoogleSpreadSheetLocalize(
  "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
  version: 1, // When updating, increment this version.
)
class AppLocalize extends _$AppLocalize {}
```

Acquisition of the translation text is done using the `l` object.

```dart
Text(l().success);
```

To learn more about the other features listed below, please visit the package details page.

- Specifying Parameters
- Change Translation Language

katana_localization

[https://pub.dev/packages/katana_localization](https://pub.dev/packages/katana_localization)

## Theme Management

### Asset Definition

Edit pubspec.yaml with reference to the official site below so that the assets can be loaded in the application.

[https://docs.flutter.dev/development/ui/assets-and-images](https://docs.flutter.dev/development/ui/assets-and-images)

```yaml
// pubspec.yaml

flutter:
  assets:
    - assets/images/
```

### Font Definition

Edit pubspec.yaml with reference to the official site below so that the fonts can be loaded in the application.

[https://docs.flutter.dev/cookbook/design/fonts](https://docs.flutter.dev/cookbook/design/fonts)

```yaml
// pubspec.yaml

flutter:
  fonts:
    - family: RobotoMono
      fonts:
        - asset: fonts/RobotoMono-Regular.ttf
        - asset: fonts/RobotoMono-Bold.ttf
          weight: 700
```

### Color and Text Definition

By rewriting the following section of main.dart, it is possible to specify colors and text.

The following colors can be specified according to the Material Design color scheme.

[https://m3.material.io/styles/color/the-color-system/key-colors-tones](https://m3.material.io/styles/color/the-color-system/key-colors-tones)

Text can also be specified according to the Typography of the material design.

[https://m3.material.io/styles/typography/type-scale-tokens](https://m3.material.io/styles/typography/type-scale-tokens)

```dart
// main.dart

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
  // TODO: Set the design.
  primary: Colors.blue,
  secondary: Colors.cyan,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
);
```

### Using Themes

The following themes can be obtained by using the `theme` in main.dart.

- `color`
    - ColorScheme defined when creating `AppThemeData`.
- `text`
    - TypeScale defined when creating `AppThemeData`.
- `asset`
    - Assets under the `assets` folder created in code generation.
- `font`
    - FontFamily created by Code Generation.

```dart
@override
Widget build(BuildContext context, PageRef ref) {
  // Describes the process of loading
  // and defining variables required for the page.
  // TODO: Implement the variable loading process.

  // Describes the structure of the page.
  // TODO: Implement the view.
  return Scaffold(
    appBar: AppBar(title: Text("Title"), backgroundColor: theme.color.secondary),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Center(child: CircleAvatar(backgroundImage: theme.asset.userIcon.provider)),
        Text("User Name", style: theme.text.displayMedium)
      ]
    )
  );
}
```

To learn more about the other features listed below, please visit the package details page.

- Theme Extension
- Gradation
- Conversion Methods

katana_theme

[https://pub.dev/packages/katana_theme](https://pub.dev/packages/katana_theme)

## Shared Preferences

`SharedPreferences` is available to locally store settings and other settings in the app separately from the data model.

### Creating a Object

You can create an object for SharedPreferences with the following command

```bash
katana code prefs
```

The following code will be created in `lib/prefs.dart`.

```dart
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';

part 'prefs.prefs.dart';

/// Get SharedPreferences for the app.
/// 
/// ```dart
/// appPrefs.xxx.get();      // Get xxx value.
/// appPrefs.xxx.set("xxx"); // Set xxx value.
/// ```
final appPrefs = Prefs(
  // TODO: Initial values defined in Prefs are listed here.
  
);

/// Shared Preferences.
@prefs
class Prefs with _$Prefs, ChangeNotifier {
  factory Prefs({
    // TODO: Define here the values to be managed in Shared Preferences.
    
  }) = _Prefs;
  Prefs._();
}
```

Specify the type and name of the value you want to manage in the `factory` method.

Also, the value specified in `required` must always be listed as the initial value in the definition of `Prefs`.

```dart
factory Prefs({
  // TODO: Define here the values to be managed in Shared Preferences.
  required double volumeSetting, 
  String? userToken,
}) = _Prefs;
```

```dart
final appPrefs = Prefs(
  // TODO: Initial values defined in Prefs are listed here.
  volumeSetting: 0.5,
);
```

### How to use

SharedPreferences are obtained and saved by executing the `get()` and `set(value)` methods of the `appPrefs` object.

```dart
appPrefs.volumeSetting.get();     // Get the value of `volumeSetting
appPrefs.volumeSetting.set(1.0);  // Set `volumeSetting` to 1.0
```

For other details, please see the package details page.

katana_prefs

[https://pub.dev/packages/katana_prefs](https://pub.dev/packages/katana_prefs)

## Form Building

### Retrieving Form Controllers

First, obtain a form controller to control and hold the form values.

When creating a form that targets a `data model`, such as editing profile data, use a `form` that is defined in an existing data model.

```dart
/// Query for form value.
///
/// ```dart
/// ref.page.controller(TestModel.form());     // Get the form controller.
/// ```
static const form = _$TestModelFormQuery();
```

The `form` is passed to `ref.page.controller`, but the original object (`TestModel`) must be passed as an argument.

When registering new data, simply create and pass a `TestModel`, and when editing existing data, pass the values read from the `data model` as they are.

```dart
// When creating new data
final memo = const MemoModel(title: "", text: "");
final formController = ref.page.controller(MemoModel.form( memo ));

// When creating existing data
final memo = ref.model(MemoModel.document("Memo ID"))..load();
final formController = ref.page.controller(MemoModel.form( memo ));
```

To create a form for data not defined in the data model, such as login, use the following command to create a data definition for the form.

```bash
katana code value [Value name]
```

The following file will be created in `lib/models/(Value name).dart`.

Internally, a class named `(Value name)Value` is created.

```dart
// login.dart

// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.g.dart';
part 'login.m.dart';
part 'login.freezed.dart';

/// Immutable value.
@freezed
@formValue
@immutable
class LoginValue with _$LoginValue {
  const factory LoginValue({
    // TODO: Set the data schema.

  }) = _LoginValue;
  const LoginValue._();

  factory LoginValue.fromJson(Map<String, Object?> json) =>
      _$LoginValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(LoginValue.form());     // Get the form controller.
  /// ```
  static const form = _$LoginValueFormQuery();
}
```

Please add the necessary data scheme in the factory method.

```dart
const factory LoginValue({
  // TODO: Set the data schema.
  required String email,
  required String password,
}) = _LoginValue;
```

To retrieve the form controller, use the `form` defined in this object for the same purpose.

```dart
final login = const LoginValue(email: "", password: "");
final formController = ref.page.controller(LoginValue.form( login ));
```

### Form drawing and validation/finalization

Pass the above form controller to the form parameter of each widget for the `form`.

In doing so, please write a process to rewrite the form value and return it with the target value passed to the `onSaved` parameter.

```dart
FormTextField(
  form: formController,
  onSaved: (value) => formController.value.copyWith(email: value),
),
```

After writing the form widget while including the above process, the form values are validated and confirmed by executing `formController.validateAndSave` when the confirm button is pressed.

Then, after the validation passes, use `formController.value` to obtain the value and perform the saving process, etc.

```dart
FormButton(
  "Login",
  onPressed: () async {
    if (!formController.validateAndSave()) {
      return;
    }
    try {
      final LoginValue loginValue = formController.value; // Get form values
      // Normal processing
    } catch (e) {
      // Error handling
    }
  },
),
```

Please see the package details page for other details.

katana_form

[https://pub.dev/packages/katana_form](https://pub.dev/packages/katana_form)

## UI Support

### Dialog

The dialog can be displayed with the following code.

```dart
// Alert dialog.
Modal.alert(
  title: "Title",
  text: "Contents text",
  submitText: "OK",
  onSubmit: () {
    // Processing when the OK button is pressed
  },
);

// Confirmation dialog.
Modal.confirm(
  title: "Title",
  text: "Contents text",
  submitText: "Yes",
  cancelText: "No",
  onSubmit: () {
    // Processing when the Yes button is pressed
  },
  onCancel: () {
    // Processing when the No button is pressed
  }
);
```

For other details, please see the package details page.

katana_ui

[https://pub.dev/packages/katana_ui](https://pub.dev/packages/katana_ui)

## Authentication

For user registration and authentication, use the `appAuth` object in main.dart.

User registration, login, and logout can be performed by executing various methods of appAuth.

```dart
// User registration
await auth.register(
  EmailAndPasswordAuthQuery.register(
    email: "test@email.com",
    password: "12345678",
  ),
);

// Login
await auth.signIn(
  EmailAndPasswordAuthQuery.signIn(
    email: "test@email.com",
    password: "12345678",
  ),
);

// Logout
await auth.signOut();
```

By default, these are only stored in the app's memory and will revert to their original state when the app is restarted.

If you wish to persist data, see `Firebase/Firestore support` below.

For other details, please see the package details page.

katana_auth

[https://pub.dev/packages/katana_auth](https://pub.dev/packages/katana_auth)

## File storage

If you want to upload image files, etc., use the Storage object.

Use a file picker or similar tool to obtain the `file path` and `byte data (UInt8List)` of the file to be uploaded and pass them to the various methods.

```dart
final storage = Storage(const StorageQuery("test/file"));

final pickedData = await FilePicker.platform.pickFiles();
storage.upload(pickedData.first.path);
```

By default, these are only stored in the app's memory and will revert to their original state when the app is restarted.

If you wish to persist data, see `Firebase/Firestore support` below.

For other details, please see the package details page.

katana_storage

[https://pub.dev/packages/katana_storage](https://pub.dev/packages/katana_storage)

## Firebase/Firestore support

As for the `data model (database)`, `authentication`, and `file storage`, the default provides the ability to store only within the app, but it can be switched to target the device local or Firebase by replacing the adapter.

If you use the adapter for Firebase/Firestore, import the following packages in advance.

```bash
# If you want to use Firebase Authentication
flutter pub add katana_auth_firebase

# If you want to use Firestore
flutter pub add katana_model_firestore

# If you want to use Cloud Storage for Firebase
flutter pub add katana_storage_firebase
```

Also, please complete the initial Firebase setup using [FlutterFire](https://firebase.flutter.dev/) or similar.

```bash
flutterfire configure
```

To switch the data model (database), authentication, and file storage to `Firestore`, `Firebase Authentication`, or `Cloud Storage for Firebase`, respectively, the following adapters must be replaced with the corresponding ones.

```dart
/// App Model.
///
/// By replacing this with another adapter, the data storage location can be changed.
// TODO: Change the database.
// final modelAdapter = RuntimeModelAdapter();
final modelAdapter = FirestoreModelAdapter(options: DefaultFirebaseOptions.currentPlatform);

/// App Auth.
/// 
/// Changing to another adapter allows you to change to another authentication mechanism.
// TODO: Change the authentication.
// final authAdapter = RuntimeAuthAdapter();
final authAdapter = FirebaseAuthAdapter(options: DefaultFirebaseOptions.currentPlatform);

/// App Storage.
/// 
/// Changing to another adapter allows you to change to another storage mechanism.
// TODO: Change the storage.
// final storageAdapter = LocalStorageAdapter();
final storageAdapter = FirebaseStorageAdapter(options: DefaultFirebaseOptions.currentPlatform);
```

**You can change to Firebase without worrying about other code, just change the adapter.**

## Other Functions

The Masamune framework provides other useful features.

Each is offered in a separate package, so please refer to that for details.

### Provides shorthand notation

katana_shorten

[https://pub.dev/packages/katana_shorten](https://pub.dev/packages/katana_shorten)

### Indicator display while waiting for Future

katana_indicator

[https://pub.dev/packages/katana_indicator](https://pub.dev/packages/katana_indicator)
