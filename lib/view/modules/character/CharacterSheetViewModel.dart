import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';

import '../../../domain/services/SheetService.dart';

class CharacterSheetViewModel with ChangeNotifier {
  final SheetService _sheetService;
  late CharacterSheetState _currentState;

  final streamController =
      StreamController<CharacterSheetState>.broadcast(sync: true);

  CharacterSheetViewModel(this._sheetService) {
    _currentState = CharacterSheetState();
  }

  CharacterSheetState getState() {
    return _currentState;
  }

  selectUi(String uiName) {
      streamController.add(_currentState.copy(CharacterSheetUISelected(uiName)));
  }

  Future<void> getCharacterSheet(String name) async {
    streamController.add(_currentState.copy(CharacterSheetLoading()));
    _sheetService.get(name).then((value) {
      streamController.add(_currentState.copy(CharacterSheetLoaded(value.character, value.rollList)));
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
    });
  }

  Future<void> updateCharacter(Character character) async {
    _sheetService.update(character).then((value) {
      streamController.add(_currentState.copy(CharacterLoaded(value)));
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
    });
  }

  Future<void> sendRoll(RollType rollType) async {
    if(_currentState.character != null) {
      _sheetService.sendRoll(
          rollType: rollType,
          rollerName: _currentState.character!.name,
          secret: _currentState.uiState.secret,
          focus: _currentState.uiState.focus,
          power: _currentState.uiState.power,
          proficiency: _currentState.uiState.proficiency,
          benediction: _currentState.uiState.benediction + (_currentState.uiState.lux ? 1 : 0) + (_currentState.uiState.secunda ? 1 : 0),
          malediction: _currentState.uiState.malediction + (_currentState.uiState.umbra ? 1 : 0));
    }
  }
}
