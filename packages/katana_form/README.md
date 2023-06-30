<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana Form</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Introduction

Form implementation is a very important part of the application.

It has become an indispensable interface that allows users to enter their information into the application.

Simplifying the implementation of Forms can be very helpful in increasing the speed and safety of application implementation.

Flutter provides `FormField`-type widgets such as `Form` and `TextFormField`.

However, it does not address data handling, and data acquisition and storage require implementation for each state management system.

Also, although it is possible to change the design with `InputDecoration`, I would like to simplify it and use it like `ButtonStyle` because there are many setting items.

For this reason, I have created the following package.

- Enables input/output using a form by storing values for use in the form in the FormController and passing them to the `FormController`.
- Unify design specifications by making `FormStyle` available to all form widgets. Enables easy unification of design.

It can be easily written as follows.

```dart

final form = FormController(<String, dynamic>{});

return Scaffold(
  appBar: AppBar(title: const Text("App Demo")),
  body: ListView(
    padding: const EdgeInsets.symmetric(vertical: 32),
    children: [
      const FormLabel("Name"),
      FormTextField(
        form: form,
        initialValue: form.value["name"],
        onSaved: (value) => {...form.value, "name": value},
      ),
      const FormLabel("Description"),
      FormTextField(
        form: form,
        minLines: 5,
        initialValue: form.value["description"],
        onSaved: (value) => {...form.value, "description": value},
      ),
      FormButton(
        "Submit",
        icon: Icon(Icons.check),
        onPressed: () {
          if (!form.validateAndSave()) {
            return;
          }
          print(form.value);
          // Save form.value as is.
        },
      ),
    ]
  )
);
```

This package can also be used with [freezed](https://pub.dev/packages/freezed) to write code more safely.

# Installation

Import the following packages

```bash
flutter pub add katana_form
```

# Implementation

## Create a Controller

First, define the `FormController` with initial values.

For new data creation, pass an empty object; for existing data, insert values read from the database.

This example is for a case where `Map<String, dynamic>` is used to handle data for a database.

```dart
// New data
final form = FormController(<String, dynamic>{});

// Existing data
final Map<String, dynamic> data = getRepositoryData();
final form = FormController(data);
```

This is maintained by a state management mechanism such as `StatefulWidget`.

Since FormController inherits from `ChangeNotifier`, it can be used in conjunction with [riverpod](https://pub.dev/packages/riverpod)'s `ChangeNotifierProvider`, etc.

## Form Implementation

`Form` widget installation is not required.

All you have to do is pass the FormController you created, and if you pass a `FormController`, you must also pass `onSaved`. (If you want to use only onChanged, you do not need to pass FormController.)

Pass the initial value to `initialValue`. When passing an initial value, pass the value obtained from `FormController.value` as is.

`onSaved` is passed the currently entered value as a callback, so be sure to return the changed `FormController.value` value as is.

```dart
FormTextField(
  form: form,
  initialValue: form.value["description"],
  onSaved: (value) => {...form.value, "description": value},
),
```

## Form Validation and Storage

`FormController.validateAndSave` can be executed to validate and save the form.

Validation is performed first, and `false` is returned in case of failure.

If successful, `true` is returned and `FormController.value` is populated with the value changed by `onSaved` of each FormWidget.

Please update the database based on that value.

```dart
if (!form.validateAndSave()) {
	return;
}
print(form.value);
// Save form.value as is.
```

## Sample code

The above sequence of events can be written in summary as follows

When destroying a form page, `FormController` should also be `disposed` of by disposing of it together with the form page.

```dart
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final form = FormController(<String, dynamic>{});

  @override
  void dispose() {
    super.dispose();
    form.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          const FormLabel("Name"),
          FormTextField(
            form: form,
            initialValue: form.value["name"],
            onSaved: (value) => {...form.value, "name": value},
          ),
          const FormLabel("Description"),
          FormTextField(
            form: form,
            minLines: 5,
            initialValue: form.value["description"],
            onSaved: (value) => {...form.value, "description": value},
          ),
          const SizedBox(height: 16),
          FormButton(
            "Submit",
            icon: Icon(Icons.add),
            onPressed: () {
              if (!form.validateAndSave()) {
                return;
              }
              print(form.value);
              // Save form.value as is.
            },
          ),
        ],
      ),
    );
  }
}
```

[Freezed](https://pub.dev/packages/freezed) allows you to write code more safely.

```dart
@freezed
class FormValue with _$FormValue {
  const factory FormValue({
    String? name,
    String? description,
  }) = _FormValue;
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final form = FormController(FormValue());

  @override
  void dispose() {
    super.dispose();
    form.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          const FormLabel("Name"),
          FormTextField(
            form: form,
            initialValue: form.value.name,
            onSaved: (value) => form.value.copyWith(name: value),
          ),
          const FormLabel("Description"),
          FormTextField(
            form: form,
            minLines: 5,
            initialValue: form.value.description,
            onSaved: (value) => form.value.copyWith(description: value),
          ),
          const SizedBox(height: 16),
          FormButton(
            "Submit",
            icon: Icon(Icons.add),
            onPressed: () {
              if (!form.validateAndSave()) {
                return;
              }
              print(form.value);
              // Save form.value as is.
            },
          ),
        ],
      ),
    );
  }
}
```

# Style Change

The style of each `FormWidget` can be changed together with `FormStyle`.

The default style is plain, but if you specify the following, the style will be changed to the Material design with a border.

```dart
FormTextField(
  form: form,
  initialValue: form.value["name"],
  onSaved: (value) => {...form.value, "name": value},
  style: FormStyle(
      border: OutlineInputBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      contentPadding: const EdgeInsets.all(16)),
),
```

# Type of FormWidget

Currently available FormWidget are

Adding as needed.

- `FormTextField`
    - Field for entering text
- `FormDateTimeField`
    - Field to select and enter the date and time in the Flutter dialog
- `FormDateField`
    - Field to select the date (month and day) from a choice
- `FormNumField`
    - Field to select a numerical value from a list of choices.
- `FormEnumField`
    - Field to select from the Enum definition.
- `FormMapField`
    - Field where you pass a Map and choose from its options.

The widgets that assist Form are as follows.

- `FormLabel`
    - The label portion of the form is displayed separately. It also serves as a Divider.
- `FormButton`
    - Used for confirm and cancel buttons for forms.
    - FormStyle is available.
