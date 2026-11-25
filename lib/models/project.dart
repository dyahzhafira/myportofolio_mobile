import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.status,
    required this.projectType,
    this.techStack = const [],
    this.projectUrl = '',
    this.projectImageUrl = '',
    this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;

  final String status;

  final String projectType;

  @JsonKey(defaultValue: <String>[])
  final List<String> techStack;

  @JsonKey(defaultValue: '')
  final String projectUrl;

  @JsonKey(defaultValue: '')
  final String projectImageUrl;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
