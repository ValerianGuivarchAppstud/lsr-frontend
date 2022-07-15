// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      currentPlayer: json['currentPlayer'] as String? ?? "",
      playersName: (json['playersName'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      currentCharacter: json['currentCharacter'] as String? ?? "",
      charactersName: (json['charactersName'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'currentPlayer': instance.currentPlayer,
      'playersName': instance.playersName,
      'currentCharacter': instance.currentCharacter,
      'charactersName': instance.charactersName,
    };
