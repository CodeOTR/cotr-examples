import 'package:butler_labs_ai/models/butler_field.dart';
import 'package:json_annotation/json_annotation.dart';

part 'butler_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ButlerResult {
  final String documentId;

  final String? documentStatus;

  final String? fileName;

  final String? mimeType;

  final String? documentType;

  final String? confidenceScore;

  final List<ButlerField> formFields;

  ButlerResult({
    required this.documentId,
    this.documentStatus,
    this.fileName,
    this.mimeType,
    this.documentType,
    this.confidenceScore,
    required this.formFields,
  });

  factory ButlerResult.fromJson(Map<String, dynamic> json) => _$ButlerResultFromJson(json);

  Map<String, dynamic> toJson() => _$ButlerResultToJson(this);
}
