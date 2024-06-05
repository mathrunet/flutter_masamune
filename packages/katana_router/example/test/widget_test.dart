// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Flutter imports:
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:katana_router/katana_router.dart';

void main() {
  test("regexsplit", () {
    const text =
        "{name} is delisours. so {name} is mine. but {name} was wrong. {name}";
    final regexp = RegExp(r"([^\{]+)|\{([a-zA-Z0-9_-]+)\}");
    final matches = regexp.allMatches(text).toList();
    expect(matches.map((e) => e.group(0)).toList(), [
      "{name}",
      " is delisours. so ",
      "{name}",
      " is mine. but ",
      "{name}",
      " was wrong. ",
      "{name}",
    ]);
  });
  test("regexptest", () {
    const testList = {
      "InnerPageType.type2": "@HiddenPage(value: InnerPageType.type2)",
      "'InnerPageType.type2'": "@HiddenPage(value : 'InnerPageType.type2')",
      '"InnerPageType.type2"': '@HiddenPage(value:"InnerPageType.type2")',
      '"a,b,c,d,e"': '@HiddenPage(value : "a,b,c,d,e")',
      "100": "@HiddenPage(value: 100)",
      "100.5928": "@HiddenPage(value :100.5928)",
      "false": "@HiddenPage(value : false)",
      "InnerPageType.type3":
          "@HiddenPage(value:InnerPageType.type3, redirect:[LoginRedirect(),])",
      "500":
          "@HiddenPage(value:500, redirect :[LoginRedirect(),RegisterRedirect()])",
      "LoginRedirect()":
          "@HiddenPage(value:LoginRedirect(), redirect :[ LoginRedirect(), RegisterRedirect()  ])",
      "LoginRedirect('aaaa', 500, false )":
          "@HiddenPage(value:LoginRedirect('aaaa', 500, false ), redirect :[ LoginRedirect(), RegisterRedirect()  ])",
      "LoginRedirect(test: 'aaaa', aaa: TestRidirect(), false )":
          "@HiddenPage(value:LoginRedirect(test: 'aaaa', aaa: TestRidirect(), false ), redirect:[LoginRedirect(),])",
      "InnerPageType.type4":
          "@HiddenPage(redirect:[LoginRedirect(),], value:InnerPageType.type4, )",
      "501":
          "@HiddenPage(redirect :[LoginRedirect(),RegisterRedirect()], value:501, )",
      "LoginRedirect2()":
          "@HiddenPage( redirect :[ LoginRedirect(), RegisterRedirect()  ],value:LoginRedirect2())",
      "LoginRedirect('aaaa', 500, true )":
          "@HiddenPage(redirect :[ LoginRedirect(), RegisterRedirect()  ], value:LoginRedirect('aaaa', 500, true ), )",
      "LoginRedirect(test: 'aaaa', aaa: TestRidirect2(), false )":
          "@HiddenPage(redirect:[LoginRedirect(),], value:LoginRedirect(test: 'aaaa', aaa: TestRidirect2(), false ), )"
    };
    final regExpList = RegExp(r"value\s*:\s*(.+),?\s*\)\s*$");
    final redirectExp = RegExp(r"redirect\s*:\s*\[([^\]]*)\]");
    for (final tmp in testList.entries) {
      final res = regExpList.firstMatch(tmp.value);
      final redirect = redirectExp.firstMatch(tmp.value);
      debugPrint(res?.group(1));
      debugPrint(redirect?.group(0));
      expect(
          res
              ?.group(1)
              ?.replaceAll(redirect?.group(0) ?? "", "")
              .trim()
              .trimStringRight(",")
              .trim(),
          tmp.key);
    }
  });
}
