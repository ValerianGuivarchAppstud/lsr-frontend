// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendRollRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendRollRequest _$SendRollRequestFromJson(Map<String, dynamic> json) =>
    SendRollRequest(
      roll: Roll.fromJson(json['roll'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendRollRequestToJson(SendRollRequest instance) =>
    <String, dynamic>{
      'roll': instance.roll,
    };
