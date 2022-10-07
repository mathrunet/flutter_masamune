// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      name: json['name'] as String,
      text: json['text'] as String,
      image: json['image'] as String?,
      age: json['age'] as int? ?? 20,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'image': instance.image,
      'age': instance.age,
    };

_$_StreamModel _$$_StreamModelFromJson(Map<String, dynamic> json) =>
    _$_StreamModel(
      name: json['name'] as String,
      text: json['text'] as String,
      user: json['user'] == null
          ? null
          : ModelRef<UserModel>.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_StreamModelToJson(_$_StreamModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'user': instance.user,
    };
