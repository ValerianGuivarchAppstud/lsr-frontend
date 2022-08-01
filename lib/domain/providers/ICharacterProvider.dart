import 'package:lsr/domain/models/Character.dart';

import '../models/CharacterSheet.dart';

abstract class ICharacterProvider {
  Future<CharacterSheet> get(String name);
  Future<Character> createOrUpdateCharacter(Character character);
}
