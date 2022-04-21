import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import 'RollType.dart';
part 'Roll.g.dart';

//  flutter pub run build_runner build
@JsonSerializable()
class Roll {
  String rollerName;
  RollType rollType;
  bool secret;
  bool focus;
  bool power;
  bool proficiency;
  int benediction;
  int malediction;
  List<int> result;

  Roll({required this.rollerName, required this.rollType, required this.secret, required this.focus, required this.power,
    required this.proficiency, required this.benediction, required this.malediction, required this.result});



  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Roll.fromJson(Map<String, dynamic> json) => _$RollFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RollToJson(this);
}