// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_shorten/katana_shorten.dart";

void main() {
  test("Duration", () {
    expect(100.s, const Duration(seconds: 100));
    expect(100.m, const Duration(minutes: 100));
    expect(100.h, const Duration(hours: 100));
    expect(100.d, const Duration(days: 100));
    expect(100.ms, const Duration(milliseconds: 100));
  });
  test("EdgeInsets", () {
    expect(100.p, const EdgeInsets.all(100));
    expect(100.px, const EdgeInsets.symmetric(horizontal: 100));
    expect(100.py, const EdgeInsets.symmetric(vertical: 100));
    expect(100.pt, const EdgeInsets.only(top: 100));
    expect(100.pb, const EdgeInsets.only(bottom: 100));
    expect(100.pl, const EdgeInsets.only(left: 100));
    expect(100.pr, const EdgeInsets.only(right: 100));
  });
  test("SizedBox", () {
    expect(100.sx.width, const SizedBox(width: 100).width);
    expect(100.sy.height, const SizedBox(height: 100).height);
  });
}
