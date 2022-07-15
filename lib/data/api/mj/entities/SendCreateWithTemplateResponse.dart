
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/models/Character.dart';

part 'SendCreateWithTemplateResponse.g.dart';

@JsonSerializable()
class SendCreateWithTemplateResponse {
  List<Character> templateNewCharacters;


  SendCreateWithTemplateResponse({required this.templateNewCharacters});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SendCreateWithTemplateResponse.fromJson(Map<String, dynamic> json) =>_$SendCreateWithTemplateResponseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SendCreateWithTemplateResponseToJson(this);
}