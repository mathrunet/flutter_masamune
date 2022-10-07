// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get name => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res>;
  $Res call({String name, String text, String? image, int age});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  final UserModel _value;
  // ignore: unused_field
  final $Res Function(UserModel) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? image = freezed,
    Object? age = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      age: age == freezed
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$_UserModelCopyWith(
          _$_UserModel value, $Res Function(_$_UserModel) then) =
      __$$_UserModelCopyWithImpl<$Res>;
  @override
  $Res call({String name, String text, String? image, int age});
}

/// @nodoc
class __$$_UserModelCopyWithImpl<$Res> extends _$UserModelCopyWithImpl<$Res>
    implements _$$_UserModelCopyWith<$Res> {
  __$$_UserModelCopyWithImpl(
      _$_UserModel _value, $Res Function(_$_UserModel) _then)
      : super(_value, (v) => _then(v as _$_UserModel));

  @override
  _$_UserModel get _value => super._value as _$_UserModel;

  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? image = freezed,
    Object? age = freezed,
  }) {
    return _then(_$_UserModel(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      age: age == freezed
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserModel implements _UserModel {
  const _$_UserModel(
      {required this.name, required this.text, this.image, this.age = 20});

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserModelFromJson(json);

  @override
  final String name;
  @override
  final String text;
  @override
  final String? image;
  @override
  @JsonKey()
  final int age;

  @override
  String toString() {
    return 'UserModel(name: $name, text: $text, image: $image, age: $age)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserModel &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.text, text) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.age, age));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(age));

  @JsonKey(ignore: true)
  @override
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      __$$_UserModelCopyWithImpl<_$_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String name,
      required final String text,
      final String? image,
      final int age}) = _$_UserModel;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override
  String get name;
  @override
  String get text;
  @override
  String? get image;
  @override
  int get age;
  @override
  @JsonKey(ignore: true)
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

StreamModel _$StreamModelFromJson(Map<String, dynamic> json) {
  return _StreamModel.fromJson(json);
}

/// @nodoc
mixin _$StreamModel {
  String get name => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  ModelRef<UserModel>? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreamModelCopyWith<StreamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamModelCopyWith<$Res> {
  factory $StreamModelCopyWith(
          StreamModel value, $Res Function(StreamModel) then) =
      _$StreamModelCopyWithImpl<$Res>;
  $Res call({String name, String text, ModelRef<UserModel>? user});
}

/// @nodoc
class _$StreamModelCopyWithImpl<$Res> implements $StreamModelCopyWith<$Res> {
  _$StreamModelCopyWithImpl(this._value, this._then);

  final StreamModel _value;
  // ignore: unused_field
  final $Res Function(StreamModel) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ModelRef<UserModel>?,
    ));
  }
}

/// @nodoc
abstract class _$$_StreamModelCopyWith<$Res>
    implements $StreamModelCopyWith<$Res> {
  factory _$$_StreamModelCopyWith(
          _$_StreamModel value, $Res Function(_$_StreamModel) then) =
      __$$_StreamModelCopyWithImpl<$Res>;
  @override
  $Res call({String name, String text, ModelRef<UserModel>? user});
}

/// @nodoc
class __$$_StreamModelCopyWithImpl<$Res> extends _$StreamModelCopyWithImpl<$Res>
    implements _$$_StreamModelCopyWith<$Res> {
  __$$_StreamModelCopyWithImpl(
      _$_StreamModel _value, $Res Function(_$_StreamModel) _then)
      : super(_value, (v) => _then(v as _$_StreamModel));

  @override
  _$_StreamModel get _value => super._value as _$_StreamModel;

  @override
  $Res call({
    Object? name = freezed,
    Object? text = freezed,
    Object? user = freezed,
  }) {
    return _then(_$_StreamModel(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ModelRef<UserModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StreamModel implements _StreamModel {
  const _$_StreamModel({required this.name, required this.text, this.user});

  factory _$_StreamModel.fromJson(Map<String, dynamic> json) =>
      _$$_StreamModelFromJson(json);

  @override
  final String name;
  @override
  final String text;
  @override
  final ModelRef<UserModel>? user;

  @override
  String toString() {
    return 'StreamModel(name: $name, text: $text, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StreamModel &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.text, text) &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(user));

  @JsonKey(ignore: true)
  @override
  _$$_StreamModelCopyWith<_$_StreamModel> get copyWith =>
      __$$_StreamModelCopyWithImpl<_$_StreamModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StreamModelToJson(
      this,
    );
  }
}

abstract class _StreamModel implements StreamModel {
  const factory _StreamModel(
      {required final String name,
      required final String text,
      final ModelRef<UserModel>? user}) = _$_StreamModel;

  factory _StreamModel.fromJson(Map<String, dynamic> json) =
      _$_StreamModel.fromJson;

  @override
  String get name;
  @override
  String get text;
  @override
  ModelRef<UserModel>? get user;
  @override
  @JsonKey(ignore: true)
  _$$_StreamModelCopyWith<_$_StreamModel> get copyWith =>
      throw _privateConstructorUsedError;
}
