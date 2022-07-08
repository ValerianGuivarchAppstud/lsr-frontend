// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendRollRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendRollRequest _$SendRollRequestFromJson(Map<String, dynamic> json) =>
    SendRollRequest(
      rollerName: json['rollerName'] as String,
      rollType: $enumDecode(_$RollTypeEnumMap, json['rollType']),
      secret: json['secret'] as bool,
      focus: json['focus'] as bool,
      power: json['power'] as bool,
      proficiency: json['proficiency'] as bool,
      benediction: json['benediction'] as int,
      malediction: json['malediction'] as int,
      empiriqueRoll: json['empiriqueRoll'] as String?,
    );

Map<String, dynamic> _$SendRollRequestToJson(SendRollRequest instance) =>
    <String, dynamic>{
      'rollerName': instance.rollerName,
      'rollType': _$RollTypeEnumMap[instance.rollType],
      'secret': instance.secret,
      'focus': instance.focus,
      'power': instance.power,
      'proficiency': instance.proficiency,
      'benediction': instance.benediction,
      'malediction': instance.malediction,
      'empiriqueRoll': instance.empiriqueRoll,
    };

const _$RollTypeEnumMap = {
  RollType.CHAIR: 'CHAIR',
  RollType.ESPRIT: 'ESPRIT',
  RollType.ESSENCE: 'ESSENCE',
  RollType.EMPIRIQUE: 'EMPIRIQUE',
  RollType.MAGIE_LEGERE: 'MAGIE_LEGERE',
  RollType.MAGIE_FORTE: 'MAGIE_FORTE',
  RollType.SOIN: 'SOIN',
  RollType.ARCANE_FIXE: 'ARCANE_FIXE',
  RollType.ARCANE_ESPRIT: 'ARCANE_ESPRIT',
  RollType.ARCANE_ESSENCE: 'ARCANE_ESSENCE',
  RollType.SAUVEGARDE_VS_MORT: 'SAUVEGARDE_VS_MORT',
  RollType.RELANCE: 'RELANCE',
};
