// Package imports:
import 'package:test/test.dart';

void main() {
  test("RegExp", () {
    const text = """
6C906C1A9BBEC34CC45CAFA0 /* Pods */ = {
			isa = PBXGroup;
			children = (
				A9CDE84F0C0C7E0F917BE0F8 /* Pods-Runner.debug.xcconfig */,
				5AEE743295992710A837FBA6 /* Pods-Runner.release.xcconfig */,
				8B8C40C5E82AEBA5DB1D3A74 /* Pods-Runner.profile.xcconfig */,
			);
			name = Pods;
			path = Pods;
			sourceTree = "<group>";
		};
""";
    expect(
      RegExp(r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/ = {[\s\t\n]+isa = PBXGroup;[\s\t\n]+children = \((?<children>[^\)]+)\);[\s\t\n]+(name = (?<name>[a-zA-Z_."-]+);)?[\s\t\n]+(path = (?<path>[a-zA-Z_ ."-]+);)?[\s\t\n]+sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+);[\s\t\n]+};')
          .hasMatch(text),
      true,
    );
  });
}
