import 'package:lsr/domain/models/Character.dart';

import '../models/CharacterSheet.dart';

abstract class ICharacterProvider {
  Stream<Set<CharacterSheet>> get(String name);
  Stream<Set<CharacterSheet>> update(Character character);
}