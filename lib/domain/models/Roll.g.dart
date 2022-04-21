// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roll _$RollFromJson(Map<String, dynamic> json) => Roll(
      rollerName: json['rollerName'] as String,
      rollType: $enumDecode(_$RollTypeEnumMap, json['rollType']),
      secret: json['secret'] as bool,
      focus: json['focus'] as bool,
      power: json['power'] as bool,
      proficiency: json['proficiency'] as bool,
      benediction: json['benediction'] as int,
      malediction: json['malediction'] as int,
      result: (json['result'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$RollToJson(Roll instance) => <String, dynamic>{
      'rollerName': instance.rollerName,
      'rollType': _$RollTypeEnumMap[instance.rollType],
      'secret': instance.secret,
      'focus': instance.focus,
      'power': instance.power,
      'proficiency': instance.proficiency,
      'benediction': instance.benediction,
      'malediction': instance.malediction,
      'result': instance.result,
    };

const _$RollTypeEnumMap = {
  RollType.CHAIR: 'CHAIR',
  RollType.ESPRIT: 'ESPRIT',
  RollType.ESSENCE: 'ESSENCE',
  RollType.EMPIRIQUE: 'EMPIRIQUE',
  RollType.MAGIE: 'MAGIE',
  RollType.SOIN: 'SOIN',
  RollType.ARCANE_ESPRIT: 'ARCANE_ESPRIT',
  RollType.ARCANE_ESSENCE: 'ARCANE_ESSENCE',
  RollType.SAUVEGARDE_VS_MORT: 'SAUVEGARDE_VS_MORT',
};
