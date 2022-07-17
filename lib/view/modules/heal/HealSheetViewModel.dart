import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/RollType.dart';
import 'package:lsr/view/MainState.dart';
import '../../MainViewModel.dart';
import 'package:lsr/domain/services/SettingsService.dart';

import '../../../domain/services/SheetService.dart';
import 'HealSheetState.dart';

class HealSheetViewModel extends SubViewModel with ChangeNotifier {
  final SheetService _sheetService;
  late final SettingsService? _configService;
  late final String? _characterName;
  late final bool _isPlayer;
  late HealSheetState _currentState;

  final streamController =
      StreamController<HealSheetState>.broadcast(sync: true);

  String? getCharacterName() {
    return _characterName;
  }

  HealSheetViewModel(this._sheetService, this._configService) {
    _currentState = HealSheetState();
    _characterName = null;
    _isPlayer = true;
  }

  HealSheetState getState() {
    return _currentState;
  }

  Future<void> getHealSheet([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(HealSheetLoading()));
    }
    String characterName = _isPlayer ? (await this._configService!.getCharacterName() ?? '') : _characterName!;

      _sheetService.getHeal(characterName).then((value) {
        streamController.add(_currentState.copy(HealSheetLoaded(value.character, value.pjAllies, value.rollList)));
      }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(HealSheetFailed(error.toString())));
      });
  }

  updateUi(HealSheetUIState state) {
    streamController.add(_currentState.copy(HealSheetUIUpdated(state)));
  }

  Future<void> healCharacter(Character allie) async {
    if(this._currentState.uiState.heal > 0) {
      allie.pv = allie.pv + 1;
      _sheetService.createOrUpdateCharacter(allie).then((value) {
        this._currentState.uiState.heal = this._currentState.uiState.heal - 1;
        updateUi(_currentState.uiState);
      }).onError((error, stackTrace) {
        streamController.add(
            _currentState.copy(HealSheetFailed(error.toString())));
      });
    }
  }

  Future<void> sendHealRoll() async {
    if(_currentState.character != null) {
      _sheetService.sendRoll(
          rollType: RollType.SOIN,
          rollerName: _currentState.character!.name,
          secret: false,
          focus: _currentState.uiState.focus,
          power: _currentState.uiState.power,
          proficiency: false,
          benediction: _currentState.uiState.benediction,
          malediction: _currentState.uiState.malediction,
          characterToHelp: null,
          resistRoll: null,
          empirique: '').then((value) {
        this._currentState.uiState.heal = (value.success ?? 0);
        this._currentState.uiState.healMax = (value.success ?? 0);
        updateUi(_currentState.uiState);
      }).onError((error, stackTrace) {
        streamController.add(
            _currentState.copy(HealSheetFailed(error.toString())));
      });
    }
  }

  @override
  changeMainState(MainLoaded state) {
    // nothing to do
  }
}
