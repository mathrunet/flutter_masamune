// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, unnecessary_type_check

part of 'main.dart';

// **************************************************************************
// PrefsGenerator
// **************************************************************************

class _$_PrefsValue<T> {
  _$_PrefsValue(
    this._key,
    this._def,
    this._ref,
  );

  final String _key;

  final _$PrefsValue _ref;

  final T _def;

  T get() {
    final o = _ref._prefs?.get(_key);
    if (o is! T) {
      return _def;
    }
    return o;
  }

  Future<void> set(T value) async {
    if (value is bool) {
      await _ref._prefs?.setBool(_key, value);
    } else if (value is int) {
      await _ref._prefs?.setInt(_key, value);
    } else if (value is double) {
      await _ref._prefs?.setDouble(_key, value);
    } else if (value is String) {
      await _ref._prefs?.setString(_key, value);
    } else if (value is List<String>) {
      await _ref._prefs?.setStringList(_key, value);
    }
    _ref.notifyListeners();
  }

  @override
  String toString() {
    return get().toString();
  }
}

abstract class _$PrefsValue implements ChangeNotifier {
  SharedPreferences? get _prefs => throw UnimplementedError();
  _$_PrefsValue<String?> get userToken => throw UnimplementedError();
  _$_PrefsValue<double> get volumeSetting => throw UnimplementedError();
  @override
  void addListener(VoidCallback listener) => throw UnimplementedError();
  @override
  void removeListener(VoidCallback listener) => throw UnimplementedError();
  @override
  void notifyListeners() => throw UnimplementedError();
  @override
  void dispose() => throw UnimplementedError();
  @override
  bool get hasListeners => throw UnimplementedError();
  @override
  String toString() {
    return "$runtimeType(userToken: $userToken, volumeSetting: $volumeSetting)";
  }
}

class _PrefsValue extends PrefsValue {
  _PrefsValue({
    String? userToken,
    double volumeSetting = 1.0,
  })  : _userToken = userToken,
        _volumeSetting = volumeSetting,
        super._() {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      notifyListeners();
    });
  }

  @override
  SharedPreferences? _prefs;

  final String? _userToken;

  final double _volumeSetting;

  @override
  _$_PrefsValue<String?> get userToken =>
      _$_PrefsValue("_#userToken".toSHA1(), _userToken, this);
  @override
  _$_PrefsValue<double> get volumeSetting =>
      _$_PrefsValue("_#volumeSetting".toSHA1(), _volumeSetting, this);
}
