import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/SettingsService.dart';
import '../../MainState.dart';
import '../../MainViewModel.dart';

import 'CallState.dart';

class CallViewModel extends SubViewModel with ChangeNotifier {
  late final SettingsService _configService;
  late CallState _currentState;

  final streamController = StreamController<CallState>.broadcast(sync: true);

  CallViewModel(this._configService) {
    _currentState = CallState();
  }

  CallState getState() {
    return _currentState;
  }

  Future<void> getCall([bool reload = false]) async {
    if (reload) {
      streamController.add(_currentState.copy(CallLoading()));
    }

    print("nia1");
    _configService.getVisio().then((value) {
      print("nia2");
      if (_currentState.charactersUid != value) {
        print("nia3");
        print(value);
        print(value.characters);

        streamController.add(_currentState.copy(CallLoaded(value.characters)));
      }
      print("nia4");
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CallFailed(error.toString())));
    });
  }

  Future<void> getToken([bool reload = false]) async {
    if (reload) {
      streamController.add(_currentState.copy(CallLoading()));
    }

    _configService.getToken().then((value) {
      streamController.add(_currentState.copy(TokenLoaded(value)));
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(CallFailed(error.toString())));
    });
  }

  updateUi(CallUIState state) {
    streamController.add(_currentState.copy(CallUIUpdated(state)));
  }

  @override
  changeMainState(MainUIUpdated state) {
    print("changeMainState call");
    CallUIState uiState = this.getState().uiState;
    uiState.pjDisplay = state.state.pj;
    this.updateUi(uiState);
  }

  Future<void> join(int uid) async {
    print("JOINJOIN ${uid}");
    String characterName = this._currentState.uiState.pjDisplay
        ? (await this._configService.getCharacterName() ?? '')
        : '';
    print("JOINJOIN ${characterName}");

    if (characterName != '') _configService.join(characterName, uid);
    CallUIState callUIState = _currentState.uiState;
    callUIState.uid = uid;
    this.updateUi(callUIState);
  }

  void newUser(int uid) {}

  void removeUser(int uid) {}
}
