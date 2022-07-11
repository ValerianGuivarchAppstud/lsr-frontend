import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/domain/models/Settings.dart';

import '../models/CharacterSheet.dart';

abstract class IMjProvider {
  Future<MjSheet> get();
  Future<MjSheet> addCharacterList(String characterName);
  Future<MjSheet> removeCharacterList(String characterName);
}