import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/MjSheet.dart';

abstract class IMjProvider {
  Future<MjSheet> get();
  Future<MjSheet> addCharacterList(String characterName);
  Future<MjSheet> removeCharacterList(String characterName);
  Future<List<Character>> addCharacterWithTemplate(String templateName, String customName, int level, int number);
  deleteRolls();
}