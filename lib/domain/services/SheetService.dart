import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';
import 'package:lsr/view/modules/character/CharacterState.dart';

import '../models/Roll.dart';
import '../providers/IRollProvider.dart';

class SheetService {

  ICharacterProvider characterProvider;
  IRollProvider rollProvider;

  SheetService({
    required this.characterProvider,
    required this.rollProvider
  });

  // TODO remove "first"
  Stream<Set<CharacterSheet>> get(String name)  => characterProvider.get(name);

  Stream<CharacterSheetPartialState> update(Character character) {
    return characterProvider.update(character)
        .map(
            (model) => CharacterSheetLoaded(model.first.character, model.first.rollList)
    );
  }

  void sendRoll(Roll roll) => rollProvider.send(roll);
}