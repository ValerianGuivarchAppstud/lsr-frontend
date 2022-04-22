import 'package:lsr/domain/models/Character.dart';

import '../models/CharacterSheet.dart';

abstract class ICharacterProvider {
  Future<CharacterSheet> get(String name);
  Future<CharacterSheet> update(Character character);
}