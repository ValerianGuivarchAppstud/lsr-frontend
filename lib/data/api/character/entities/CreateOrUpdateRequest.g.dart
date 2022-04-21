// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreateOrUpdateRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrUpdateRequest _$CreateOrUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    CreateOrUpdateRequest(
      character: Character.fromJson(json['character'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrUpdateRequestToJson(
        CreateOrUpdateRequest instance) =>
    <String, dynamic>{
      'character': instance.character,
    };
