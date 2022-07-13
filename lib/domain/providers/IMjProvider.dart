import 'package:lsr/domain/models/MjSheet.dart';

abstract class IMjProvider {
  Future<MjSheet> get();
  Future<MjSheet> addCharacterList(String characterName);
  Future<MjSheet> removeCharacterList(String characterName);
}