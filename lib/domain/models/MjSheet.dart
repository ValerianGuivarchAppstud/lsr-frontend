import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';
import 'Roll.dart';

part 'MjSheet.g.dart';

@JsonSerializable()
class MjSheet {
  List<Character> pj;
  List<Character> pnj;
  List<Roll> rollList;
  MjSheet({
      required this.pj,
      required this.pnj,
      required this.rollList
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