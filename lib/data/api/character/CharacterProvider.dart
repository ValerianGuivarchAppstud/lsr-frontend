import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../../../utils/api/NetworkingConfig.dart';
import 'entities/CreateOrUpdateRequest.dart';

class CharacterProvider implements ICharacterProvider {
  final NetworkingConfig _networkingConfig;

  CharacterProvider(this._networkingConfig);

  @override
  Future<CharacterSheet> get(String name) async {
    Response response =
        await _networkingConfig.dio.get('character?name=' + name);
    CharacterSheet characterSheet = CharacterSheet.fromJson(response.data);
    return characterSheet;
  }

  @override
  Future<Character> createOrUpdateCharacter(Character character) async {
    CreateOrUpdateRequest createOrUpdateRequest =
        new CreateOrUpdateRequest(character: character);
    Response response = await _networkingConfig.dio
        .put('character', data: createOrUpdateRequest.toJson());
    return Character.fromJson(response.data);
  }
}
