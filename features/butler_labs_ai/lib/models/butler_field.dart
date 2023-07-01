import 'package:json_annotation/json_annotation.dart';

part 'butler_field.g.dart';

@JsonSerializable(explicitToJson: true)
class ButlerField {
  final String fieldName;

  final String? value;

  final String? confidenceScore;

  final double confidenceValue;

  final double ocrConfidenceValue;

  ButlerField({
    required this.fieldName,
    this.value,
    this.confidenceScore,
    required this.confidenceValue,
    required this.ocrConfidenceValue,
  });

  factory ButlerField.fromJson(Map<String, dynamic> json) => _$ButlerFieldFromJson(json);

  Map<String, dynamic> toJson() => _$ButlerFieldToJson(this);
}
