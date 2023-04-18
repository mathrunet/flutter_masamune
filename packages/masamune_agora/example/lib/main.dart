// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_calendar/masamune_calendar.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  const CalendarMasamuneAdapter(),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (adapters) => MasamuneApp(
      home: const OpenAIPage(),
      title: "Flutter Demo",
      masamuneAdapters: adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class OpenAIPage extends StatefulWidget {
  const OpenAIPage({super.key});

  @override
  State<StatefulWidget> createState() => OpenAIPagePageState();
}

class OpenAIPagePageState extends State<OpenAIPage> {
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _controller.prev();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              _controller.next();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CalendarHeader(
            controller: _controller,
          ),
          Expanded(
            child: Calendar(
              controller: _controller,
              events: [
                for (var i = 0; i < 10; i++)
                  CalendarEventItem(
                    startTime: DateTime(now.year, now.month, now.day).add(i.d),
                    title: "Event $i",
                  )
              ],
              expand: true,
            ),
          ),
        ],
      ),
    );
  }
}
