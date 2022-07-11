import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/domain/providers/ICharacterProvider.dart';
import 'package:lsr/domain/providers/IMjProvider.dart';
import 'package:lsr/domain/providers/IStorageProvider.dart';


class MjService {
  IMjProvider mjProvider;
  ICharacterProvider characterProvider;

  MjService({required this.mjProvider, required this.characterProvider});

  Future<MjSheet?> getMj() async {
    return await this.mjProvider.get();
  }

  Future<Character> createOrUpdateCharacter(Character character) async {
    return await this.characterProvider.createOrUpdateCharacter(character);
  }

  Future<MjSheet> addCharacterList(String characterName) async {
    return await this.mjProvider.addCharacterList(characterName);
  }

  Future<MjSheet> removeCharacterList(String characterName) async {
    return await this.mjProvider.removeCharacterList(characterName);
  }
}
