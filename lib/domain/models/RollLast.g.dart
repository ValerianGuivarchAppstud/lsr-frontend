// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RollLast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RollLast _$RollLastFromJson(Map<String, dynamic> json) => RollLast(
      rollList: (json['rollList'] as List<dynamic>)
          .map((e) => Roll.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RollLastToJson(RollLast instance) => <String, dynamic>{
      'rollList': instance.rollList,
    };
