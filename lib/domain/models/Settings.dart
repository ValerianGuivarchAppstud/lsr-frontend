import 'package:json_annotation/json_annotation.dart';

part 'Settings.g.dart';

@JsonSerializable()
class Settings {
  String? currentPlayer;
  List<String> playersName;
  String? currentCharacter;
  List<String> charactersName;

  Settings({
    this.currentPlayer = "",
    required this.playersName,
    this.currentCharacter = "",
    required this.charactersName
  });


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}