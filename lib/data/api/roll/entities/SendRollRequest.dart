
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/models/RollType.dart';

part 'SendRollRequest.g.dart';

@JsonSerializable()
class SendRollRequest {
  String rollerName;
  RollType rollType;
  bool secret;
  bool focus;
  bool power;
  bool proficiency;
  int benediction;
  int malediction;
  String? characterToHelp;
  String? empiriqueRoll;
  String? resistRoll;


  SendRollRequest({required this.rollerName, required this.rollType, required this.secret, required this.focus,
      required this.power, required this.proficiency, required this.benediction, required this.malediction, this.empiriqueRoll,
    this.characterToHelp, this.resistRoll});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SendRollRequest.fromJson(Map<String, dynamic> json) =>_$SendRollRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SendRollRequestToJson(this);
}