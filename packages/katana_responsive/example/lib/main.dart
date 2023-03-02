// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      breakpoint: ResponsiveContainerType.sm,
      appBar: ResponsiveAppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        centerTitle: false,
        title: const Text("Grid"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Scrollbar(
        interactive: true,
        trackVisibility: true,
        thumbVisibility: true,
        child: ResponsiveListView(
          primary: true,
          children: [
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
                    color: Colors.red,
                    height: 100,
                  ),
                ),
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
                ResponsiveCol(
                  sm: 6,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                ),
                ResponsiveCol(
                  sm: 6,
                  child: Container(
                    color: Colors.red,
                    height: 100,
                  ),
                ),
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
                ResponsiveCol(
                  sm: 6,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
