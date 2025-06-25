// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pull_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PullRequestModel {
  String get title;
  String get body;
  String get state;
  int? get id;
  int? get number;
  Map<String, dynamic> get user;
  Map<String, dynamic> get head;
  Map<String, dynamic> get base;
  String? get createdAt;
  String? get updatedAt;
  String? get mergedAt;

  /// Create a copy of PullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PullRequestModelCopyWith<PullRequestModel> get copyWith =>
      _$PullRequestModelCopyWithImpl<PullRequestModel>(
          this as PullRequestModel, _$identity);

  /// Serializes this PullRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PullRequestModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.head, head) &&
            const DeepCollectionEquality().equals(other.base, base) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mergedAt, mergedAt) ||
                other.mergedAt == mergedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      body,
      state,
      id,
      number,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(head),
      const DeepCollectionEquality().hash(base),
      createdAt,
      updatedAt,
      mergedAt);

  @override
  String toString() {
    return 'PullRequestModel(title: $title, body: $body, state: $state, id: $id, number: $number, user: $user, head: $head, base: $base, createdAt: $createdAt, updatedAt: $updatedAt, mergedAt: $mergedAt)';
  }
}

/// @nodoc
abstract mixin class $PullRequestModelCopyWith<$Res> {
  factory $PullRequestModelCopyWith(
          PullRequestModel value, $Res Function(PullRequestModel) _then) =
      _$PullRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String body,
      String state,
      int? id,
      int? number,
      Map<String, dynamic> user,
      Map<String, dynamic> head,
      Map<String, dynamic> base,
      String? createdAt,
      String? updatedAt,
      String? mergedAt});
}

/// @nodoc
class _$PullRequestModelCopyWithImpl<$Res>
    implements $PullRequestModelCopyWith<$Res> {
  _$PullRequestModelCopyWithImpl(this._self, this._then);

  final PullRequestModel _self;
  final $Res Function(PullRequestModel) _then;

  /// Create a copy of PullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? state = null,
    Object? id = freezed,
    Object? number = freezed,
    Object? user = null,
    Object? head = null,
    Object? base = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mergedAt = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      head: null == head
          ? _self.head
          : head // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      base: null == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mergedAt: freezed == mergedAt
          ? _self.mergedAt
          : mergedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PullRequestModel extends PullRequestModel {
  const _PullRequestModel(
      {this.title = "",
      this.body = "",
      this.state = "open",
      this.id,
      this.number,
      final Map<String, dynamic> user = const <String, dynamic>{},
      final Map<String, dynamic> head = const <String, dynamic>{},
      final Map<String, dynamic> base = const <String, dynamic>{},
      this.createdAt,
      this.updatedAt,
      this.mergedAt})
      : _user = user,
        _head = head,
        _base = base,
        super._();
  factory _PullRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PullRequestModelFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String state;
  @override
  final int? id;
  @override
  final int? number;
  final Map<String, dynamic> _user;
  @override
  @JsonKey()
  Map<String, dynamic> get user {
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_user);
  }

  final Map<String, dynamic> _head;
  @override
  @JsonKey()
  Map<String, dynamic> get head {
    if (_head is EqualUnmodifiableMapView) return _head;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_head);
  }

  final Map<String, dynamic> _base;
  @override
  @JsonKey()
  Map<String, dynamic> get base {
    if (_base is EqualUnmodifiableMapView) return _base;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_base);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? mergedAt;

  /// Create a copy of PullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PullRequestModelCopyWith<_PullRequestModel> get copyWith =>
      __$PullRequestModelCopyWithImpl<_PullRequestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PullRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PullRequestModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality().equals(other._user, _user) &&
            const DeepCollectionEquality().equals(other._head, _head) &&
            const DeepCollectionEquality().equals(other._base, _base) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mergedAt, mergedAt) ||
                other.mergedAt == mergedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      body,
      state,
      id,
      number,
      const DeepCollectionEquality().hash(_user),
      const DeepCollectionEquality().hash(_head),
      const DeepCollectionEquality().hash(_base),
      createdAt,
      updatedAt,
      mergedAt);

  @override
  String toString() {
    return 'PullRequestModel(title: $title, body: $body, state: $state, id: $id, number: $number, user: $user, head: $head, base: $base, createdAt: $createdAt, updatedAt: $updatedAt, mergedAt: $mergedAt)';
  }
}

/// @nodoc
abstract mixin class _$PullRequestModelCopyWith<$Res>
    implements $PullRequestModelCopyWith<$Res> {
  factory _$PullRequestModelCopyWith(
          _PullRequestModel value, $Res Function(_PullRequestModel) _then) =
      __$PullRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String body,
      String state,
      int? id,
      int? number,
      Map<String, dynamic> user,
      Map<String, dynamic> head,
      Map<String, dynamic> base,
      String? createdAt,
      String? updatedAt,
      String? mergedAt});
}

/// @nodoc
class __$PullRequestModelCopyWithImpl<$Res>
    implements _$PullRequestModelCopyWith<$Res> {
  __$PullRequestModelCopyWithImpl(this._self, this._then);

  final _PullRequestModel _self;
  final $Res Function(_PullRequestModel) _then;

  /// Create a copy of PullRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? state = null,
    Object? id = freezed,
    Object? number = freezed,
    Object? user = null,
    Object? head = null,
    Object? base = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mergedAt = freezed,
  }) {
    return _then(_PullRequestModel(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      user: null == user
          ? _self._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      head: null == head
          ? _self._head
          : head // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      base: null == base
          ? _self._base
          : base // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mergedAt: freezed == mergedAt
          ? _self.mergedAt
          : mergedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
