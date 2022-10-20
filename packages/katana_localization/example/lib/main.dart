import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:katana_localization/katana_localization.dart';

part 'main.localize.dart';

final l = AppLocalize();

@GoogleSpreadSheetLocalize(
  "https://docs.google.com/spreadsheets/d/1bw7IXEr7BGkZ4U6on0OuF7HQkTMgDSm6u5ThpBkDPeo/edit#gid=551986808",
)
class AppLocalize extends _$AppLocalize {}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: l.delegates(),
      supportedLocales: l.supportedLocales(),
      home: const MainPage(),
      locale: Locale("en", "US"),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    l.setCurrentLocale(context);
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text(
              l().$(l().$(l().process).of.$(l().data)).hasBeenCompleted,
            ),
          ),
        ],
      ),
    );
  }
}
