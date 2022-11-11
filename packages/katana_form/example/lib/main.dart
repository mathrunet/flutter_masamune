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
  final form = FormContext(<String, dynamic>{});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: Form(
        key: form.key,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32),
          children: [
            const FormLabel("Text Form"),
            FormTextField(
              form,
              initialValue: form.value["name"],
              onSaved: (form, value) => {...form.value, "name": value},
            ),
            const FormLabel("DateTime Form"),
            FormDateTimeField(
              form,
              initialValue: form.value["date"],
              onSaved: (form, value) => {...form.value, "date": value},
            ),
            const FormLabel("Date Form"),
            FormDateField(
              form,
              initialValue: form.value["date"],
              onSaved: (form, value) => {...form.value, "date": value},
            ),
            const FormLabel("Number Form"),
            FormNumField(
              form,
              initialValue: form.value["number"],
              onSaved: (form, value) => {...form.value, "number": value},
            ),
            const FormLabel("Enum Form"),
            FormEnumField(
              form,
              initialValue: Selection.one,
              picker: FormEnumFieldPicker(
                values: Selection.values,
              ),
              onSaved: (form, value) => {...form.value, "enumSelect": value},
            ),
            const FormLabel("Nao Form"),
            FormMapField(
              form,
              initialValue: "one",
              picker: FormMapFieldPicker(
                defaultKey: "one",
                data: {"one": "one", "two": "two", "three": "three"},
              ),
              onSaved: (form, value) => {...form.value, "mapSelect": value},
            ),
            const SizedBox(height: 16),
            FormButton(
              "Submit",
              icon: Icon(Icons.add),
              style: FormStyle(
                prefix: FormAffixStyle.text("aaaa"),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.check),
      ),
    );
  }
}
