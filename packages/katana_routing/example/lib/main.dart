// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:katana_routing/katana_routing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UIMaterialApp(
      title: "Routing Demo",
      initialRoute: "/",
      routes: {
        "/": RouteConfig((_) => const HomeDemo()),
        "/company": RouteConfig((_) => const CompanyDemo()),
        "/profile": RouteConfig((_) => const ProfileDemo()),
      },
      onUnknownRoute: RouteConfig((_) => const HomeDemo()),
    );
  }
}

class HomeDemo extends PageScopedWidget {
  const HomeDemo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Profile"),
            onTap: () {
              context.navigator.pushNamed("/profile");
            },
          ),
          ListTile(
            title: const Text("Company"),
            onTap: () {
              context.navigator.pushNamed("/company");
            },
          )
        ],
      ),
    );
  }
}

class ProfileDemo extends PageScopedWidget {
  const ProfileDemo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(child: Text("Profile")),
    );
  }
}

class CompanyDemo extends PageScopedWidget {
  const CompanyDemo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Company"),
      ),
      body: const Center(child: Text("Company")),
    );
  }
}
