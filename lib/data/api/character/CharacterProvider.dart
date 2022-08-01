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
    print("POUET1");

    print(response);
    try {
      CharacterSheet characterSheet2 = CharacterSheet.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    CharacterSheet characterSheet = CharacterSheet.fromJson(response.data);

    print("POUET2");
    print(characterSheet);
    print("POUET3");


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
