// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HealSheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealSheet _$HealSheetFromJson(Map<String, dynamic> json) => HealSheet(
      character: Character.fromJson(json['character'] as Map<String, dynamic>),
      rollList: (json['rollList'] as List<dynamic>)
          .map((e) => Roll.fromJson(e as Map<String, dynamic>))
          .toList(),
      pjAllies: (json['pjAllies'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HealSheetToJson(HealSheet instance) => <String, dynamic>{
      'character': instance.character,
      'rollList': instance.rollList,
      'pjAllies': instance.pjAllies,
    };
