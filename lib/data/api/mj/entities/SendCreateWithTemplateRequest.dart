
import 'package:json_annotation/json_annotation.dart';

part 'SendCreateWithTemplateRequest.g.dart';

@JsonSerializable()
class SendCreateWithTemplateRequest {
  String templateName;
  String customName;
  int level;
  int number;


  SendCreateWithTemplateRequest({required this.templateName, required this.customName, required this.level, required this.number});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SendCreateWithTemplateRequest.fromJson(Map<String, dynamic> json) =>_$SendCreateWithTemplateRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SendCreateWithTemplateRequestToJson(this);
}