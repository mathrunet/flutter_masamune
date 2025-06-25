// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IssueModel {
  String get title;
  String get body;
  String get state;
  int? get id;
  int? get number;
  Map<String, dynamic> get user;
  List<Map<String, dynamic>> get labels;
  String? get createdAt;
  String? get updatedAt;
  String? get closedAt;

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IssueModelCopyWith<IssueModel> get copyWith =>
      _$IssueModelCopyWithImpl<IssueModel>(this as IssueModel, _$identity);

  /// Serializes this IssueModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IssueModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt));
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
      const DeepCollectionEquality().hash(labels),
      createdAt,
      updatedAt,
      closedAt);

  @override
  String toString() {
    return 'IssueModel(title: $title, body: $body, state: $state, id: $id, number: $number, user: $user, labels: $labels, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt)';
  }
}

/// @nodoc
abstract mixin class $IssueModelCopyWith<$Res> {
  factory $IssueModelCopyWith(
          IssueModel value, $Res Function(IssueModel) _then) =
      _$IssueModelCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String body,
      String state,
      int? id,
      int? number,
      Map<String, dynamic> user,
      List<Map<String, dynamic>> labels,
      String? createdAt,
      String? updatedAt,
      String? closedAt});
}

/// @nodoc
class _$IssueModelCopyWithImpl<$Res> implements $IssueModelCopyWith<$Res> {
  _$IssueModelCopyWithImpl(this._self, this._then);

  final IssueModel _self;
  final $Res Function(IssueModel) _then;

  /// Create a copy of IssueModel
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
    Object? labels = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? closedAt = freezed,
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
      labels: null == labels
          ? _self.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _IssueModel extends IssueModel {
  const _IssueModel(
      {this.title = "",
      this.body = "",
      this.state = "open",
      this.id,
      this.number,
      final Map<String, dynamic> user = const <String, dynamic>{},
      final List<Map<String, dynamic>> labels = const <Map<String, dynamic>>[],
      this.createdAt,
      this.updatedAt,
      this.closedAt})
      : _user = user,
        _labels = labels,
        super._();
  factory _IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);

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

  final List<Map<String, dynamic>> _labels;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? closedAt;

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IssueModelCopyWith<_IssueModel> get copyWith =>
      __$IssueModelCopyWithImpl<_IssueModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IssueModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IssueModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality().equals(other._user, _user) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt));
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
      const DeepCollectionEquality().hash(_labels),
      createdAt,
      updatedAt,
      closedAt);

  @override
  String toString() {
    return 'IssueModel(title: $title, body: $body, state: $state, id: $id, number: $number, user: $user, labels: $labels, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt)';
  }
}

/// @nodoc
abstract mixin class _$IssueModelCopyWith<$Res>
    implements $IssueModelCopyWith<$Res> {
  factory _$IssueModelCopyWith(
          _IssueModel value, $Res Function(_IssueModel) _then) =
      __$IssueModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String body,
      String state,
      int? id,
      int? number,
      Map<String, dynamic> user,
      List<Map<String, dynamic>> labels,
      String? createdAt,
      String? updatedAt,
      String? closedAt});
}

/// @nodoc
class __$IssueModelCopyWithImpl<$Res> implements _$IssueModelCopyWith<$Res> {
  __$IssueModelCopyWithImpl(this._self, this._then);

  final _IssueModel _self;
  final $Res Function(_IssueModel) _then;

  /// Create a copy of IssueModel
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
    Object? labels = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? closedAt = freezed,
  }) {
    return _then(_IssueModel(
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
      labels: null == labels
          ? _self._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
