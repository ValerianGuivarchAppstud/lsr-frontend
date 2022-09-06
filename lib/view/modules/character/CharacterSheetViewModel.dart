import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/Roll.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';

import '../../../domain/services/SheetService.dart';
import '../../../utils/MessagedException.dart';
import '../../MainState.dart';
import '../../MainViewModel.dart';

class CharacterSheetViewModel extends SubViewModel with ChangeNotifier {
  final SheetService _sheetService;
  late final SettingsService _configService;
  late final String? _characterName;
  late final bool _isPlayer;
  late CharacterSheetState _currentState;

  final streamController =
      StreamController<CharacterSheetState>.broadcast(sync: true);

  String? getCharacterName() {
    return _characterName;
  }

  CharacterSheetViewModel.playerConstructor(
      this._sheetService, this._configService) {
    _currentState = CharacterSheetState();
    _characterName = null;
    _isPlayer = true;
  }

  CharacterSheetViewModel.mjConstructor(this._sheetService, this._configService,
      this._characterName, this._currentState) {
    _isPlayer = false;
  }

  CharacterSheetState getState() {
    return _currentState;
  }

  Future<void> getCharacterSheet([bool reload = false]) async {
    if (reload) {
      streamController.add(_currentState.copy(CharacterSheetLoading()));
    }
    String characterName = _isPlayer
        ? (await this._configService.getCharacterName() ?? '')
        : _characterName!;

    if (characterName == '') {
      _configService.getSettings().then((value) {
        streamController.add(_currentState.copy(SettingsLoaded(value)));
      }).onError((error, stackTrace) {
        streamController
            .add(_currentState.copy(CharacterSheetFailed(error.toString())));
      });
    } else {
      _sheetService.get(characterName).then((value) {
        streamController.add(_currentState.copy(CharacterSheetLoaded(
            value.character,
            value.rollList,
            value.character.alliesName ?? [],
            value.playersName)));
      }).onError((error, stackTrace) {
        streamController
            .add(_currentState.copy(CharacterSheetFailed(error.toString())));
      });
    }
  }

  Future<void> selectCharacterName(String? characterName) async {
    await this._configService.setCharacterName(characterName ?? '');
  }

  Future<void> selectPlayerName(String? playerName) async {
    await this._configService.setPlayerName(playerName ?? '');
  }

  updateUi(CharacterSheetUIState state) {
    streamController.add(_currentState.copy(CharacterSheetUIUpdated(state)));
  }

  Future<void> createOrUpdateCharacter(Character character) async {
    _sheetService.createOrUpdateCharacter(character).then((value) {
      streamController.add(_currentState.copy(CharacterLoaded(value)));
    }).onError((error, stackTrace) {
      streamController
          .add(_currentState.copy(CharacterSheetFailed(error.toString())));
    });
  }

  Future<Roll?> sendRoll(RollType rollType,
      [String empirique = '', String? resistRoll = null]) async {
    if (_currentState.character != null) {
      try {
        Roll roll = await _sheetService.sendRoll(
            rollType: rollType,
            rollerName: _currentState.character!.name,
            secret: _currentState.uiState.secret || rollType == RollType.SAUVEGARDE_VS_MORT,
            focus: _currentState.uiState.focus,
            power: _currentState.uiState.power,
            proficiency: _currentState.uiState.proficiency,
            benediction: _currentState.uiState.benediction,
            malediction: _currentState.uiState.malediction + max(
                (rollType == RollType.CHAIR
                    ? _currentState.character!.getInjury()
                    : 0), 0),
            characterToHelp: _currentState.uiState.characterToHelp,
            resistRoll: resistRoll,
            empirique: empirique);
        if (_currentState.uiState.characterToHelp != null) {
          _currentState.uiState.characterToHelp = null;
        }
        return roll;
      } on MessagedException catch (e) {
        print(e.message);
        _currentState.uiState.errorMessage = e.message;
      }
    }
    return null;
  }

  void saveNotesIfEnoughTime(DateTime timeUpdate) {
    if (((_currentState.lastTimeNoteSaved?.difference(timeUpdate).inSeconds) ??
            0) <=
        0) {
      _currentState.lastTimeNoteSaved = null;
      if (_currentState.character != null) {
        _currentState.character!.notes = _currentState.notes;
        this.createOrUpdateCharacter(_currentState.character!);
      }
    }
  }

  void subir(int degats) {
    if (_currentState.character != null) {
      _currentState.character!.pv =
          max(_currentState.character!.pv - degats, 0);
      this.createOrUpdateCharacter(_currentState.character!);
    }
  }

  @override
  changeMainState(MainUIUpdated state) {
    print("changeMainState character");
    // nothing to do
  }
}
