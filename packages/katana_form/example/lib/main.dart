import 'package:flutter/material.dart';
import 'package:katana_form/katana_form.dart';
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
            style: FormStyle(
                border: OutlineInputBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                contentPadding: const EdgeInsets.all(16)),
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
          FormNumField(
            form: form,
            initialValue: form.value["number"],
            onSaved: (value) => {...form.value, "number": value},
          ),
          const FormLabel("Enum Form"),
          FormEnumField(
            form: form,
            initialValue: Selection.one,
            picker: FormEnumFieldPicker(
              values: Selection.values,
            ),
            onSaved: (value) => {...form.value, "enumSelect": value},
          ),
          const FormLabel("Nao Form"),
          FormMapField(
            form: form,
            initialValue: "one",
            picker: FormMapFieldPicker(
              defaultKey: "one",
              data: {"one": "one", "two": "two", "three": "three"},
            ),
            onSaved: (value) => {...form.value, "mapSelect": value},
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
