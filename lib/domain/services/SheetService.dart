import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../providers/IRollProvider.dart';

class SheetService {
  ICharacterProvider characterProvider;
  IRollProvider rollProvider;

  SheetService({required this.characterProvider, required this.rollProvider});

  Future<CharacterSheet> get(String name) => characterProvider.get(name);

  Future<Character> update(Character character) {
    return characterProvider.update(character);
  }

  void sendRoll(
          {required String rollerName,
          required RollType rollType,
          required bool secret,
          required bool focus,
          required bool power,
          required bool proficiency,
          required int benediction,
          required int malediction}) =>
      rollProvider.send(
          rollerName: rollerName,
          rollType: rollType,
          secret: secret,
          focus: focus,
          power: power,
          proficiency: proficiency,
          benediction: benediction,
          malediction: malediction);
}
