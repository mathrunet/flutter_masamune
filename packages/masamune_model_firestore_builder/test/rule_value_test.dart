// Package imports:
import "package:masamune_builder/masamune_builder.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_firestore_builder/masamune_model_firestore_builder.dart";

class _FakeClassValue implements ClassValue {
  _FakeClassValue(this.name);

  @override
  final String name;

  @override
  List<ParamaterValue> get parameters => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAnnotationValue implements ModelAnnotationValue {
  _FakeAnnotationValue(this.permission);

  @override
  final List<PermissionValue>? permission;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

String _rules(String path, List<String>? permission) {
  return RuleValue(
    classValue: _FakeClassValue("Purchase"),
    pathValue: PathValue(path),
    annotationValue: _FakeAnnotationValue(
      permission?.map(PermissionValue.from).toList(),
    ),
  ).apply(StringBuffer()).toString();
}

void main() {
  test("Read-only permission denies every client write", () {
    final rules = _rules(
      "user/:user_id/purchase",
      ["AllowReadModelPermissionQuery.userFromPath('user_id')"],
    );
    expect(rules, contains("match /user/{userId}/purchase/{uid}"));
    expect(rules, contains("allow read: if isSpecifiedUser(userId);"));
    // Firestore denies any operation that no rule allows, so no write rule means no client writes.
    expect(rules, isNot(contains("allow write")));
    expect(rules, isNot(contains("allow create")));
    expect(rules, isNot(contains("allow update")));
    expect(rules, isNot(contains("allow delete")));
  });

  test("Authenticated read-only collections can be expressed", () {
    final rules = _rules(
      "plan",
      ["AllowReadModelPermissionQuery.authUsers()"],
    );
    expect(rules, contains("allow read: if isAuthUser();"));
    expect(rules, isNot(contains("allow write")));
  });

  test("Empty permission denies all client access", () {
    final rules = _rules("entitlement", const []);
    expect(rules, contains("allow read, write: if false;"));
  });
}
