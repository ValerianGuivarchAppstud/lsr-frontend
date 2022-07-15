import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';
import 'Roll.dart';

part 'HealSheet.g.dart';

@JsonSerializable()
class HealSheet {
  Character character;
  List<Roll> rollList;
  List<Character> pjAllies;
  HealSheet({
      required this.character,
      required this.rollList,
    required this.pjAllies
  });


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory HealSheet.fromJson(Map<String, dynamic> json) => _$HealSheetFromJson(json);


  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$HealSheetToJson(this);
}