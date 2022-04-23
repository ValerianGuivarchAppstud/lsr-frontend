import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';

import '../../../domain/services/SheetService.dart';

class CharacterSheetViewModel with ChangeNotifier {
  final SheetService _sheetService;

  final streamController =
      StreamController<CharacterSheetState>.broadcast(sync: true);

  CharacterSheetViewModel(this._sheetService);

  Future<void> getCharacterSheet(String name) async {
    streamController.add(CharacterSheetState.loading());
    _sheetService.get(name).then((value) {
      streamController.add(CharacterSheetState.withCharacterSheet(
          value.character, value.rollList));
    }).onError((error, stackTrace) {
      streamController.add(CharacterSheetState.error(error.toString()));
    });
  }

  Future<void> updateCharacter(Character character) async {
    _sheetService.update(character).then((value) {
      streamController.add(CharacterSheetState.withCharacter(
          value)); //withCharacterSheet(value.character, value.rollList));
    }).onError((error, stackTrace) {
      streamController.add(CharacterSheetState.error(error.toString()));
    });
  }

  Future<void> sendRoll(
      {required Character character,
      required RollType rollType,
      required bool focus,
      required bool power,
      required bool proficiency,
      required bool secret,
      required int benediction,
      required int malediction}) async {
    _sheetService.sendRoll(
        rollType: rollType,
        rollerName: character.name,
        secret: secret,
        focus: focus,
        power: power,
        proficiency: proficiency,
        benediction: benediction,
        malediction: malediction);
  }
}
