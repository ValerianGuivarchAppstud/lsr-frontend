import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';
import 'package:lsr/view/modules/character/CharacterState.dart';

class CharacterService {

  ICharacterProvider characterProvider;

  CharacterService({
    required this.characterProvider
  });

  Stream<CharacterPartialState> get(String name)  => characterProvider.get(name)
      .map(
          (model) => CharacterLoaded(model.first)
              // TODO remove "first"
  );

  Stream<CharacterPartialState> update(Character character) {
    print("chair5");
    return characterProvider.update(character)
        .map(
            (model) => CharacterLoaded(model.first)
    );
  }
}