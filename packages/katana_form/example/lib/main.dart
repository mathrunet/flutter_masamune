// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:katana_form/katana_form.dart';

void main() {
  runApp(const MyApp());
}

enum Selection {
  one,
  two,
  three,
}

class MyApp extends StatelessWidget {
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

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<StatefulWidget> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
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
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.check),
      ),
    );
  }
}
