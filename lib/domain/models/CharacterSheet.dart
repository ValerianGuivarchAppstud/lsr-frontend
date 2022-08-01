import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';
import 'Roll.dart';

part 'CharacterSheet.g.dart';

@JsonSerializable()
class CharacterSheet {
  Character character;
  List<Roll> rollList;
  late List<String> playersName;
  CharacterSheet(
      {required this.character,
      required this.rollList,
      required this.playersName});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CharacterSheet.fromJson(Map<String, dynamic> json) =>
      _$CharacterSheetFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CharacterSheetToJson(this);
}
