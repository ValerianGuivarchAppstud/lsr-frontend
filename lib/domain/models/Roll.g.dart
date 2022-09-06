// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roll _$RollFromJson(Map<String, dynamic> json) => Roll(
      json['id'] as String,
      json['rollerName'] as String,
      json['displayDices'] as bool,
      $enumDecode(_$RollTypeEnumMap, json['rollType']),
      DateTime.parse(json['date'] as String),
      json['secret'] as bool,
      json['focus'] as bool,
      json['power'] as bool,
      json['proficiency'] as bool,
      json['benediction'] as int,
      json['malediction'] as int,
      (json['result'] as List<dynamic>).map((e) => e as int).toList(),
      json['picture'] as String?,
      json['data'] as String?,
      json['empirique'] as String?,
      $enumDecodeNullable(_$ApotheoseEnumMap, json['apotheose']),
      json['success'] as int?,
      (json['resistRollList'] as List<dynamic>)
          .map((e) => Roll.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..juge12 = json['juge12'] as int?
      ..juge34 = json['juge34'] as int?
      ..characterToHelp = json['characterToHelp'] as String?;

Map<String, dynamic> _$RollToJson(Roll instance) => <String, dynamic>{
      'id': instance.id,
      'rollerName': instance.rollerName,
      'displayDices': instance.displayDices,
      'rollType': _$RollTypeEnumMap[instance.rollType]!,
      'date': instance.date.toIso8601String(),
      'secret': instance.secret,
      'focus': instance.focus,
      'power': instance.power,
      'proficiency': instance.proficiency,
      'benediction': instance.benediction,
      'malediction': instance.malediction,
      'result': instance.result,
      'success': instance.success,
      'juge12': instance.juge12,
      'juge34': instance.juge34,
      'characterToHelp': instance.characterToHelp,
      'picture': instance.picture,
      'empirique': instance.empirique,
      'data': instance.data,
      'apotheose': _$ApotheoseEnumMap[instance.apotheose],
      'resistRollList': instance.resistRollList,
    };

const _$RollTypeEnumMap = {
  RollType.CHAIR: 'CHAIR',
  RollType.ESPRIT: 'ESPRIT',
  RollType.ESSENCE: 'ESSENCE',
  RollType.EMPIRIQUE: 'EMPIRIQUE',
  RollType.APOTHEOSE: 'APOTHEOSE',
  RollType.MAGIE_LEGERE: 'MAGIE_LEGERE',
  RollType.MAGIE_FORTE: 'MAGIE_FORTE',
  RollType.SOIN: 'SOIN',
  RollType.ARCANE_FIXE: 'ARCANE_FIXE',
  RollType.ARCANE_ESPRIT: 'ARCANE_ESPRIT',
  RollType.ARCANE_ESSENCE: 'ARCANE_ESSENCE',
  RollType.SAUVEGARDE_VS_MORT: 'SAUVEGARDE_VS_MORT',
  RollType.RELANCE: 'RELANCE',
};

const _$ApotheoseEnumMap = {
  Apotheose.NONE: 'NONE',
  Apotheose.NORMALE: 'NORMALE',
  Apotheose.IMPROVED: 'IMPROVED',
  Apotheose.ARCANIQUE: 'ARCANIQUE',
  Apotheose.FORME_VENGERESSE: 'FORME_VENGERESSE',
  Apotheose.SURCHARGE: 'SURCHARGE',
  Apotheose.SURCHARGE_IMPROVED: 'SURCHARGE_IMPROVED',
  Apotheose.FINALE: 'FINALE',
};
