import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';
import 'Roll.dart';
import 'Round.dart';

part 'MjSheet.g.dart';

@JsonSerializable()
class MjSheet {

  @override
  String toString() {
    return 'MjSheet{characters: $characters, pjNames: $pjNames, pnjNames: $pnjNames, tempoNames: $tempoNames, rollList: $rollList}';
  }
  List<Character> characters;
  List<String> pjNames;
  List<String> pnjNames;
  List<String> tempoNames;
  List<String> templateNames;
  List<Roll> rollList;
  List<String> playersName;
  List<String> charactersBattleAllies;
  List<String> charactersBattleEnnemies;
  int relanceMj;
  Round round;
  MjSheet({
      required this.characters,
    required this.rollList,
    required this.pjNames,
    required this.pnjNames,
    required this.tempoNames,
    required this.templateNames,
    required this.playersName,
    required this.charactersBattleAllies,
    required this.charactersBattleEnnemies,
    required this.relanceMj,
    required this.round
  });


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory MjSheet.fromJson(Map<String, dynamic> json) => _$MjSheetFromJson(json);


  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$MjSheetToJson(this);
}