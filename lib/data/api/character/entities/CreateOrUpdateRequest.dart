
import 'package:json_annotation/json_annotation.dart';
import 'package:lsr/domain/models/Character.dart';

part 'CreateOrUpdateRequest.g.dart';

@JsonSerializable()
class CreateOrUpdateRequest {
  Character character;

  CreateOrUpdateRequest({
    required this.character
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CreateOrUpdateRequest.fromJson(Map<String, dynamic> json) =>_$CreateOrUpdateRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CreateOrUpdateRequestToJson(this);
}