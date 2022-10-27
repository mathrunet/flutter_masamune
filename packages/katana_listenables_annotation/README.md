<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Listenables</h1>
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

# Motivation

You may want to manage multiple TextEditingControllers, ValueNotifiers, and other controllers that inherit these ChangeNotifiers when creating widgets.

It would then generally look something like the following.

- Define multiple ChangeNotifier inherited classes in State<StatefulWidget> and do addListener for all of them
    - It is also necessary to create a separate method to execute setState()
- Create a class inheriting from ChangeNotifier for use in the state management package and addListener for all

I have created the following package to simplify the above implementation.

- Create a class inheriting from ChageNotofier with a simple description
- Monitor its parameters by passing an object inheriting from ChageNotofier as a parameter.
    - When a change occurs in a monitored ChageNotifier, the change is propagated to its own object.

For example, the following statement is used

```dart
@listenables
class ControllerGroup with _$ControllerGroup, ChangeNotifier {
  factory ControllerGroup({
    required TextEditingController emailTextEditingController,
    required TextEditingController passwordTextEditingController,
    required FocusNode focusNode,
    ValueNotifier<bool> checkTerms,
  }) = _ControllerGroup;
}
```

When [build_runner](https://pub.dev/packages/build_runner) is run with this, a class inheriting from ChangeNotifier (Listenable) given as an argument is automatically generated.

If you load this in [riverpod](https://pub.dev/packages/freezed), for example, as follows…

```dart
final controllerProvider = ChangeNotifierProvider((_) {
  return ControllerGroup(
    emailTextEditingController: TextEdigingController(),
    passwordTextEditingController: TextEdigingController(),
    focusNode: FocusNode(),
    checkTerms: ValueNotifier(false),
 );
});

class TestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref){
    final controller = ref.watch(controllerProvider);

    ~~~~
    controller.emailTextEditingController.text = "New Text"; // At this time, the controller is also notified of the change and the widget is updated again.
    ~~~~
  }
}
```

When the contents of `emailTextEditingController` defined in the `controller` are updated, the change notification is propagated to the `controller` as well.

Since the controller is also a ChangeNotifier, changes can be monitored by `addListener`, etc.

# Installation

Import the following package for code generation using [build_runner](https://pub.dev/packages/build_runner).

```dart
flutter pub add katana_listenables
flutter pub add --dev build_runner
flutter pub add --dev katana_listenables_builder
```

# Implementation

## Make a Class

Create a class as follows

Add `part '(filename).listenable.dart';`.

Annotate the defined class with `@listenables` and mixin `_$(defined class name)` and `ChangeNotifier`.

The constructor is created in the `factory` and defines classes that inherit from ChangeNotifier and Listenable that you want to use in the parameters.

(Required values are marked "`required`"; if "required" is not marked, leave it as it is.)

After the constructor, write `= _ (the name of the defined class)`.

```dart
// controller.dart

import 'package:flutter/material.dart';
import 'package:katana_listenables/katana_listenables.dart';

part 'controller.listenable.dart';

@listenables
class ControllerGroup with _$ControllerGroup, ChangeNotifier {
  factory ControllerGroup({
    required TextEditingController emailTextEditingController,
    required TextEditingController passwordTextEditingController,
    required FocusNode focusNode,
    ValueNotifier<bool> checkTerms,
  }) = _ControllerGroup;
}
```

# Code Generation

Automatic code generation is performed by entering the following command.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

# How to use

Since the created class inherits from ChangeNotifier, it can be used in the same way as a general ChangeNotifier.

- For State<StatefulWidget>

```dart
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState => TestPageState();
}

class TestPageState extends State<TestPage> {
  final controller = ControllerGroup(
    emailTextEditingController: TextEdigingController(),
    passwordTextEditingController: TextEdigingController(),
    focusNode: FocusNode(),
    checkTerms: ValueNotifier(false),
  );

  @override
  void initState(){
    super.initState();
    controller.addListener(_handledOnUpdate);
  }
	
  void _handledOnUpdate(){
    setState((){});
  }

  @override
  void dispose(){
    super.dispose();
    controller.removeListener(_handledOnUpdate);
    controller.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final controller = ref.watch(controllerProvider);

    ~~~~
    controller.emailTextEditingController.text = "New Text"; // At this time, the controller is also notified of the change and the widget is updated again.
    ~~~~
  }
}
```

- For riverpod

```dart
final controllerProvider = ChangeNotifierProvider((_) {
  return ControllerGroup(
    emailTextEditingController: TextEdigingController(),
    passwordTextEditingController: TextEdigingController(),
    focusNode: FocusNode(),
    checkTerms: ValueNotifier(false),
  );
});

class TestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref){
    final controller = ref.watch(controllerProvider);

    ~~~~
    controller.emailTextEditingController.text = "New Text"; // At this time, the controller is also notified of the change and the widget is updated again.
    ~~~~
  }
}
```

# Additional Usage

## Adding Methods

To add a method, use the following writing style.

`(defined class name). _();` constructor must be added.

```dart
// controller.dart

import 'package:flutter/material.dart';
import 'package:katana_listenables/katana_listenables.dart';

part 'controller.listenable.dart';

@listenables
class ControllerGroup with _$ControllerGroup, ChangeNotifier {
  factory ControllerGroup({
    required TextEditingController emailTextEditingController,
    required TextEditingController passwordTextEditingController,
    required FocusNode focusNode,
    ValueNotifier<bool> checkTerms,
  }) = _ControllerGroup;
  ControllerGroup._(); // Additional Required

  bool checked {
    return checkTerms?.value ?? false;
  }
}
```
