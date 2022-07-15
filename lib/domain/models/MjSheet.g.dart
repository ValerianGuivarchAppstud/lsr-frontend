// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MjSheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MjSheet _$MjSheetFromJson(Map<String, dynamic> json) => MjSheet(
      characters: (json['characters'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
      rollList: (json['rollList'] as List<dynamic>)
          .map((e) => Roll.fromJson(e as Map<String, dynamic>))
          .toList(),
      pjNames:
          (json['pjNames'] as List<dynamic>).map((e) => e as String).toList(),
      pnjNames:
          (json['pnjNames'] as List<dynamic>).map((e) => e as String).toList(),
      tempoNames: (json['tempoNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      playersName: (json['playersName'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MjSheetToJson(MjSheet instance) => <String, dynamic>{
      'characters': instance.characters,
      'pjNames': instance.pjNames,
      'pnjNames': instance.pnjNames,
      'tempoNames': instance.tempoNames,
      'rollList': instance.rollList,
      'playersName': instance.playersName,
    };
