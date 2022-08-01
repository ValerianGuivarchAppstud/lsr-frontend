import 'package:json_annotation/json_annotation.dart';

import 'Roll.dart';

part 'RollLast.g.dart';

@JsonSerializable()
class RollLast {
  final List<Roll> rollList;
  RollLast({required this.rollList});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RollLast.fromJson(Map<String, dynamic> json) =>
      _$RollLastFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RollLastToJson(this);
}
