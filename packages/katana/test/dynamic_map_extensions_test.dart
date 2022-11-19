import 'package:katana/katana.dart';
import 'package:test/test.dart';

void main() {
  test("DynamicMapExtensions.toTreeMap", () {
    final test = {
      "/aaa/bbb/ccc": "ccc",
      "/aaa/ddd": "ddd",
      "/bbb/eee": "eee",
      "/fff/ggg": "ggg",
      "/fff/hhh": "hhh",
      "/fff/iii": "iii",
      "/fff/jjj/kkk": "kkk",
    };
    final tree = test.toTreeMap();
    expect(tree, {
      "aaa": {
        "bbb": {
          "ccc": "ccc",
        },
        "ddd": "ddd",
      },
      "bbb": {
        "eee": "eee",
      },
      "fff": {
        "ggg": "ggg",
        "hhh": "hhh",
        "iii": "iii",
        "jjj": {
          "kkk": "kkk",
        },
      }
    });
  });
}
