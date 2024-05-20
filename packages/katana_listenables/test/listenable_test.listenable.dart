// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check

part of 'listenable_test.dart';

// **************************************************************************
// ListenablesGenerator
// **************************************************************************

mixin _$ListenableValue implements Listenable {
  TextEditingController get controller => throw UnimplementedError();

  ValueNotifier<String>? get value => throw UnimplementedError();

  @override
  void addListener(VoidCallback listener) => throw UnimplementedError();

  @override
  void removeListener(VoidCallback listener) => throw UnimplementedError();

  void notifyListeners() => throw UnimplementedError();

  void dispose() => throw UnimplementedError();

  bool get hasListeners => throw UnimplementedError();

  @override
  String toString() {
    return "$runtimeType(controller: $controller, value: $value)";
  }
}

class _ListenableValue extends ListenableValue {
  _ListenableValue({
    required this.controller,
    this.value,
  }) : super._() {
    if (controller is Listenable) {
      controller.addListener(_handledOnUpdate);
    }
    if (value is Listenable) {
      value?.addListener(_handledOnUpdate);
    }
  }

  @override
  final TextEditingController controller;

  @override
  final ValueNotifier<String>? value;

  @override
  void dispose() {
    super.dispose();
    if (controller is Listenable) {
      controller.removeListener(_handledOnUpdate);
      controller.dispose();
    }
    if (value is Listenable) {
      value?.removeListener(_handledOnUpdate);
      value?.dispose();
    }
  }

  void _handledOnUpdate() {
    notifyListeners();
  }
}
