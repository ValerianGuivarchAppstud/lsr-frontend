import 'dart:async';

import 'package:lsr/data/api/entities/CreateOrUpdateRequest.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../../utils/api/ErrorHandlerTransformer.dart';
import '../../utils/api/NetworkingConfig.dart';

class CharacterProvider implements ICharacterProvider {
  final NetworkingConfig _networkingConfig;

  CharacterProvider(this._networkingConfig);

  @override
  Stream<Set<Character>> get(String name) {
    print('character?name=' + name);
    return Stream.fromFuture(_networkingConfig.dio.get('character?name=' + name))
        .transform(ErrorHandlerTransformer()).map((result) => {
      Character.fromJson(result.data)
    });
  }

  @override
  Stream<Set<Character>> update(Character character) {

    print("chair2");
    CreateOrUpdateRequest createOrUpdateRequest = new CreateOrUpdateRequest(character: character);
    return Stream.fromFuture(_networkingConfig.dio.put('character', data: createOrUpdateRequest.toJson()))
        .transform(ErrorHandlerTransformer()).map((result) => {
      Character.fromJson(result.data)
    });
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
