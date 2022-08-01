import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';

part 'Visio.g.dart';

@JsonSerializable()
class Visio {
  List<Character>? characters;

  Visio({this.characters});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Visio.fromJson(Map<String, dynamic> json) => _$VisioFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VisioToJson(this);
}
