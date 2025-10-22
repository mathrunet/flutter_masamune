// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VectorModel _$VectorModelFromJson(Map<String, dynamic> json) => _VectorModel(
      content: json['content'] as String,
      vector: ModelVectorValue.fromJson(json['vector'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VectorModelToJson(_VectorModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'vector': instance.vector,
    };
