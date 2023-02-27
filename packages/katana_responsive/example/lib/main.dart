import 'package:flutter/material.dart';
import 'package:katana_responsive/katana_responsive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GridPage(),
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid"),
        actions: [
          ResponsiveVisibility(
            visible: (tier) => tier <= ResponsiveGridTier.xs,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context) => [
          ResponsiveRow(
            children: [
              ResponsiveCol(
                lg: 12,
                child: Container(
                  color: Colors.red,
                  height: 100,
                ),
              ),
            ],
          ),
          ResponsiveRow(
            children: [
              ResponsiveCol(
                sm: 6,
                child: Container(
                  color: Colors.green,
                  height: 100,
                ),
              ),
              ResponsiveCol(
                sm: 6,
                child: Container(
                  color: Colors.blue,
                  height: 100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
