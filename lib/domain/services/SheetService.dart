import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/models/HealSheet.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';

import '../models/Roll.dart';
import '../providers/IHealProvider.dart';
import '../providers/IRollProvider.dart';

class SheetService {
  ICharacterProvider characterProvider;
  IHealProvider healProvider;
  IRollProvider rollProvider;

  SheetService({required this.characterProvider, required this.rollProvider, required this.healProvider});

  Future<CharacterSheet> get(String name) => characterProvider.get(name);

  Future<HealSheet> getHeal(String name) => healProvider.get(name);

  Future<Character> createOrUpdateCharacter(Character character) {
    return characterProvider.createOrUpdateCharacter(character);
  }

  Future<Roll> sendRoll(
          {required String rollerName,
          required RollType rollType,
          required bool secret,
          required bool focus,
          required bool power,
          required bool proficiency,
          required int benediction,
          required int malediction,
          required String? characterToHelp,
          required String? resistRoll,
            String empirique = ''}) =>
      rollProvider.send(
          rollerName: rollerName,
          rollType: rollType,
          secret: secret,
          focus: focus,
          power: power,
          proficiency: proficiency,
          benediction: benediction,
          malediction: malediction,
          characterToHelp: characterToHelp,
          resistRoll: resistRoll,
          empirique: empirique);

}
