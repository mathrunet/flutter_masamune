// Flutter imports:
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Package imports:
import 'package:masamune_logger_firebase/masamune_logger_firebase.dart';

part 'main.freezed.dart';
part 'main.g.dart';

@freezed
@immutable
class AnalyticsValue
    with _$AnalyticsValue
    implements FirebaseLoggerAnalyticsValue {
  const factory AnalyticsValue({
    required String userId,
  }) = _AnalyticsValue;
  const AnalyticsValue._();

  factory AnalyticsValue.fromJson(Map<String, Object?> json) =>
      _$AnalyticsValueFromJson(json);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseLoggerMasamuneAdapterScope(
      adapter: const FirebaseLoggerMasamuneAdapter(),
      child: MasamuneApp(
        home: const PickerPage(),
        title: "Flutter Demo",
        theme: AppThemeData(
          primary: Colors.blue,
        ),
      ),
    );
  }
}

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<StatefulWidget> createState() => PickerPageState();
}

class PickerPageState extends State<PickerPage> {
  final logger = FirebaseLogger();

  @override
  void initState() {
    super.initState();
    logger.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    logger.removeListener(_handledOnUpdate);
    logger.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await logger
              .send(const AnalyticsValue(userId: "UserID"))
              .showIndicator(context);
        },
        label: const Text("Send Log"),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
