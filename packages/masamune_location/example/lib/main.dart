// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_location/masamune_location.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  MobileLocationMasamuneAdapter(),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (adapters) => MasamuneApp(
      home: const LocationPage(),
      title: "Flutter Demo",
      masamuneAdapters: adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<StatefulWidget> createState() => LocationPagePageState();
}

class LocationPagePageState extends State<LocationPage> {
  final Location _controller = Location();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handledOnUpdate);
    _controller.listen();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
      ),
      body: Center(
        child: _controller.value == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Latitude: ${_controller.value?.latitude}"),
                  Text("Longitude: ${_controller.value?.longitude}"),
                ],
              ),
      ),
    );
  }
}
