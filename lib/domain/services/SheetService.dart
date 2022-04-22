import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../models/Roll.dart';
import '../providers/IRollProvider.dart';

class SheetService {

  ICharacterProvider characterProvider;
  IRollProvider rollProvider;

  SheetService({
    required this.characterProvider,
    required this.rollProvider
  });

  Future<CharacterSheet> get(String name)  => characterProvider.get(name);

  Future<CharacterSheet> update(Character character) {
    return characterProvider.update(character);
  }

  void sendRoll(Roll roll) => rollProvider.send(roll);
}