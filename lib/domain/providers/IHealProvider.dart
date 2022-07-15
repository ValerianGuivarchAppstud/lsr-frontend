import 'package:lsr/domain/models/Character.dart';

import '../models/CharacterSheet.dart';
import '../models/HealSheet.dart';

abstract class IHealProvider {
  Future<HealSheet> get(String name);
}