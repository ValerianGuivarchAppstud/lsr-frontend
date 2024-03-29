// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CharacterSheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterSheet _$CharacterSheetFromJson(Map<String, dynamic> json) =>
    CharacterSheet(
      character: Character.fromJson(json['character'] as Map<String, dynamic>),
      rollList: (json['rollList'] as List<dynamic>)
          .map((e) => Roll.fromJson(e as Map<String, dynamic>))
          .toList(),
      playersName: (json['playersName'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      chaos: json['chaos'] as int,
    );

Map<String, dynamic> _$CharacterSheetToJson(CharacterSheet instance) =>
    <String, dynamic>{
      'character': instance.character,
      'rollList': instance.rollList,
      'playersName': instance.playersName,
      'chaos': instance.chaos,
    };
