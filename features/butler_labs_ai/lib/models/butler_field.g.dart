// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'butler_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButlerField _$ButlerFieldFromJson(Map<String, dynamic> json) => ButlerField(
      fieldName: json['fieldName'] as String,
      value: json['value'] as String?,
      confidenceScore: json['confidenceScore'] as String?,
      confidenceValue: (json['confidenceValue'] as num).toDouble(),
      ocrConfidenceValue: (json['ocrConfidenceValue'] as num).toDouble(),
    );

Map<String, dynamic> _$ButlerFieldToJson(ButlerField instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'value': instance.value,
      'confidenceScore': instance.confidenceScore,
      'confidenceValue': instance.confidenceValue,
      'ocrConfidenceValue': instance.ocrConfidenceValue,
    };
