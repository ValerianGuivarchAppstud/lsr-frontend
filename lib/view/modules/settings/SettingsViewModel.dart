import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/view/MainState.dart';

import '../../../domain/services/SettingsService.dart';
import '../../MainViewModel.dart';
import 'SettingsState.dart';

class SettingsViewModel extends SubViewModel with ChangeNotifier {
  final SettingsService _settingsService;
  late SettingsState _currentState;

  final streamController =
      StreamController<SettingsState>.broadcast(sync: true);

  SettingsViewModel(this._settingsService) {
    _currentState = SettingsState();
  }

  SettingsState getState() {
    return _currentState;
  }

  updateUi(SettingsUIState state) {
    streamController.add(_currentState.copy(SettingsUIUpdated(state)));
  }

  Future<void> selectCharacterName(String? characterName) async {
    await this._settingsService.setCharacterName(characterName ?? '');
  }

  Future<void> selectPlayerName(String? playerName) async {
    await this._settingsService.setPlayerName(playerName ?? '');
  }

  Future<void> getSettings([bool reload = false]) async {

    if(reload) {
      streamController.add(_currentState.copy(SettingsLoading()));
    }

    _settingsService.getSettings().then((value) {
        streamController.add(_currentState.copy(SettingsLoaded(value)));
    }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(SettingsFailed(error.toString())));
      });
  }


  @override
  changeMainState(MainUIUpdated state) {
    print("changeMainState settings !!!!!");
    print(_currentState);
    print(_currentState.uiState);
    print(_currentState.uiState.pj);
    print(state);
    print(state.state);
    print(state.state.pj);
    _currentState.uiState.pj = state.state.pj;
    print("changeMainState settings 2");
    updateUi(_currentState.uiState);
    print("changeMainState settings 3");
  }
}
