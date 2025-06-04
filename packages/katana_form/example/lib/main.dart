// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:katana_form/katana_form.dart";

void main() {
  runApp(const MyApp());
}

/// Selection enum for form example.
///
/// フォーム例で使用する選択肢のEnum。
enum Selection {
  /// First option.
  /// 最初の選択肢。
  one,

  /// Second option.
  /// 2番目の選択肢。
  two,

  /// Third option.
  /// 3番目の選択肢。
  three,
}

/// Main application widget.
///
/// メインアプリケーションWidget。
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  ///
  /// MyAppウィジェットを作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FormPage(),
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

/// Form page widget to demonstrate katana_form usage.
///
/// katana_formの使用方法を実演するフォームページWidget。
class FormPage extends StatefulWidget {
  /// Creates a FormPage widget.
  ///
  /// FormPageウィジェットを作成します。
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => FormPageState();
}

/// State for FormPage widget.
///
/// FormPageウィジェットのState。
class FormPageState extends State<FormPage> {
  /// Form controller for managing form state and validation.
  ///
  /// フォームの状態と検証を管理するフォームコントローラー。
  final form = FormController(<String, dynamic>{
    "name": "aaaa",
    "description": "bbb",
    "date": DateTime.now(),
    "monthDay": DateTime.now(),
    "number": 100,
  });

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
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          FormMedia(
            form: form,
            onTap: (ref) {
              ref.update(Uri.parse("assets/default.png"), FormMediaType.image);
            },
            builder: (context, value) {
              return Image.asset(
                value.uri!.toString(),
                fit: BoxFit.cover,
              );
            },
            onSaved: (value) => {...form.value, "media": value},
          ),
          const FormLabel("Name"),
          FormTextField(
            form: form,
            initialValue: form.value["name"],
            onSaved: (value) => {...form.value, "name": value},
            style: const FormStyle(
              border: OutlineInputBorder(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          const FormLabel("Description"),
          FormTextField(
            form: form,
            minLines: 5,
            initialValue: form.value["description"],
            onSaved: (value) => {...form.value, "description": value},
          ),
          const FormLabel("DateTime Form"),
          FormDateTimeField(
            form: form,
            initialValue: form.value["date"],
            onSaved: (value) => {...form.value, "date": value},
          ),
          const FormLabel("Date Form"),
          FormDateField(
            form: form,
            initialValue: form.value["monthDay"],
            onSaved: (value) => {...form.value, "monthDay": value},
          ),
          const FormLabel("Number Form"),
          FormNumModalField(
            form: form,
            initialValue: form.value["number"],
            onSaved: (value) => {...form.value, "number": value},
          ),
          const FormLabel("Enum Form"),
          FormEnumModalField(
            form: form,
            initialValue: Selection.one,
            picker: FormEnumModalFieldPicker(
              values: Selection.values,
            ),
            onSaved: (value) => {...form.value, "enumSelect": value},
          ),
          const FormLabel("Map Form"),
          FormMapModalField(
            form: form,
            initialValue: "one",
            picker: FormMapModalFieldPicker(
              defaultKey: "one",
              values: {"one": "one", "two": "two", "three": "three"},
            ),
            onSaved: (value) => {...form.value, "mapSelect": value},
          ),
          const FormLabel("Multimedia Form"),
          FormMultiMedia(
            form: form,
            onTap: (ref) {
              ref.update(Uri.parse("assets/default.png"), FormMediaType.image);
            },
            builder: (context, value) {
              return Image.asset(
                value.uri!.toString(),
                fit: BoxFit.cover,
              );
            },
            onSaved: (value) => {...form.value, "multiMedia": value},
          ),
          const SizedBox(height: 16),
          FormButton(
            "Submit",
            icon: const Icon(Icons.add),
            onPressed: () {
              final value = form.validate(); // Validate and get form values
              if (value == null) {
                return;
              }
              // TODO: Handle form submission
              debugPrint("Form submitted: $value");
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement floating action button functionality
          debugPrint("FloatingActionButton pressed");
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
