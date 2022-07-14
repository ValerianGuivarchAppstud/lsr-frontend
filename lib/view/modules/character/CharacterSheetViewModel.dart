import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/RollLast.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/domain/services/MjService.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';

import '../../../domain/services/SheetService.dart';

class CharacterSheetViewModel with ChangeNotifier {
  final SheetService _sheetService;
  late final SettingsService? _configService;
  late final MjService? _mjService;
  late final String? _characterName;
  late final bool _isPlayer;
  late CharacterSheetState _currentState;

  final streamController =
      StreamController<CharacterSheetState>.broadcast(sync: true);

  String? getCharacterName() {
    return _characterName;
  }

  CharacterSheetViewModel.playerConstructor(this._sheetService, this._configService) {
    _currentState = CharacterSheetState();
    _characterName = null;
    _isPlayer = true;
  }

  CharacterSheetViewModel.mjConstructor(this._sheetService, this._characterName, this._currentState) {
    _configService = null;
    _isPlayer = false;
  }

  CharacterSheetState getState() {
    return _currentState;
  }

  Future<void> getCharacterSheet([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(CharacterSheetLoading()));
    }
    String characterName = _isPlayer ? (await this._configService!.getCharacterName() ?? '') : _characterName!;

      _sheetService.get(characterName).then((value) {
        streamController.add(_currentState.copy(CharacterSheetLoaded(value.character, value.rollList, value.pjAlliesNames)));
      }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
      });
  }

  updateUi(CharacterSheetUIState state) {
    streamController.add(_currentState.copy(CharacterSheetUIUpdated(state)));
  }

  Future<void> createOrUpdateCharacter(Character character) async {
    _sheetService.createOrUpdateCharacter(character).then((value) {
      streamController.add(_currentState.copy(CharacterLoaded(value)));
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CharacterSheetFailed(error.toString())));
    });
  }

  Future<void> sendRoll(RollType rollType, [String empirique = '', String? resistRoll = null]) async {
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
          characterToHelp: _currentState.uiState.characterToHelp,
          resistRoll: resistRoll,
          empirique: empirique);
      if(_currentState.uiState.characterToHelp != null) {
        _currentState.uiState.characterToHelp = null;
      }
    }
  }

  void saveNotesIfEnoughTime(DateTime timeUpdate) {
    if(((_currentState.lastTimeNoteSaved?.difference(timeUpdate).inSeconds) ?? 0) <= 0) {
      _currentState.lastTimeNoteSaved = null;
      if(_currentState.character != null) {
        _currentState.character!.notes = _currentState.notes;
        this.createOrUpdateCharacter(_currentState.character!);
      }
    }
  }
}
