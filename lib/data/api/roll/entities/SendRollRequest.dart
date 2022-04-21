
import 'package:json_annotation/json_annotation.dart';
import 'package:lsr/domain/models/Roll.dart';

part 'SendRollRequest.g.dart';

@JsonSerializable()
class SendRollRequest {
  Roll roll;

  SendRollRequest({
    required this.roll
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SendRollRequest.fromJson(Map<String, dynamic> json) =>_$SendRollRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SendRollRequestToJson(this);
}