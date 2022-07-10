import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/RollLast.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';
import 'dart:convert';

import '../../../domain/services/SheetService.dart';

class CharacterSheetViewModel with ChangeNotifier {
  final SheetService _sheetService;
  final SettingsService _configService;
  late CharacterSheetState _currentState;

  final streamController =
      StreamController<CharacterSheetState>.broadcast(sync: true);

  CharacterSheetViewModel(this._sheetService, this._configService) {
    _currentState = CharacterSheetState();
  }

  CharacterSheetState getState() {
    return _currentState;
  }

  Future<void> getCharacterSheet([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(CharacterSheetLoading()));
    }
    String characterName = await this._configService.getCharacterName() ?? '';
      _sheetService.get(characterName).then((value) {
        streamController.add(_currentState.copy(CharacterSheetLoaded(value.character, value.rollList)));
      }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
      });
  }

  updateUi(CharacterSheetUIState state) {
    streamController.add(_currentState.copy(CharacterSheetUIUpdated(state)));
  }

  Future<void> updateCharacter(Character character) async {
    _sheetService.update(character).then((value) {
      streamController.add(_currentState.copy(CharacterLoaded(value)));
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
    });
  }

  Future<void> sendRoll(RollType rollType, [String empirique = '']) async {
    if(_currentState.character != null) {
      _sheetService.sendRoll(
          rollType: rollType,
          rollerName: _currentState.character!.name,
          secret: _currentState.uiState.secret,
          focus: _currentState.uiState.focus,
          power: _currentState.uiState.power,
          proficiency: _currentState.uiState.proficiency,
          benediction: _currentState.uiState.benediction,
          malediction: _currentState.uiState.malediction,
          empirique: empirique);
    }
  }

  void getRollList() {
    _sheetService.getRollList().listen((event) {
      print('Received:' +
          DateTime
              .now()
              .millisecondsSinceEpoch
              .toString() +
          ' : ' +
          event.toString());

      streamController.add(_currentState.copy(RollListLoaded(RollLast.fromJson(jsonDecode(event.toString())).rollList)));
    });
  }
}
