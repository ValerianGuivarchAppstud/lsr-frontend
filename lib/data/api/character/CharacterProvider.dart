import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../../../utils/api/ErrorHandlerTransformer.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'entities/CreateOrUpdateRequest.dart';

class CharacterProvider implements ICharacterProvider {
  final NetworkingConfig _networkingConfig;

  CharacterProvider(this._networkingConfig);

  @override
  Future<CharacterSheet> get(String name) async{
    Response response = await _networkingConfig.dio.get('character?name=' + name);
    CharacterSheet characterSheet = CharacterSheet.fromJson(response.data);
    return characterSheet;
  }


  @override
  Future<Character> update(Character character) async{
    CreateOrUpdateRequest createOrUpdateRequest = new CreateOrUpdateRequest(character: character);
    Response response = await _networkingConfig.dio.put('character', data: createOrUpdateRequest.toJson());
    return Character.fromJson(response.data);
  }

/*
  @override
  Stream<Character> get(String name) {
    final response = _networkingConfig.dio.get(ConfigReader.getBaseUrl() + '/character?name=$name')
    return Stream.fromFuture(Character.fromJson(jsonDecode(response.body)))
    );
  }


  Stream<Character> get(String name) {
    final response = await http.get(Uri.parse( ));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Character.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }*/
}
