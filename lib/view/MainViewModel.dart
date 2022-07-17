import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'MainState.dart';

abstract class SubViewModel {
  changeMainState(MainUIUpdated state);
}

class MainViewModel with ChangeNotifier {
  List<SubViewModel> subViewModels = [];
  late MainState _currentState;

  final streamController =
      StreamController<MainState>.broadcast(sync: true);

  MainViewModel() {
    _currentState = MainState();
  }

  MainState getState() {
    return _currentState;
  }

  addSubViewModel(SubViewModel subViewModel) {
    subViewModels.add(subViewModel);
    print("pouet");
    print(subViewModels.length);
  }

  Future<void> getMain([bool reload = false]) async {
    if(reload) {

      streamController.add(_currentState.copy(MainLoading()));
    }
  }

  updateUi(MainUIState state) {
    streamController.add(_currentState.copy(MainUIUpdated(state)));

    print(subViewModels.length);
    for(SubViewModel subViewModel in subViewModels) {
      subViewModel.changeMainState(MainUIUpdated(state));
    }
  }

  switchRole() {
    _currentState.uiState.selectedIndex = 0;
    _currentState.uiState.pj = !_currentState.uiState.pj;
    updateUi( _currentState.uiState);
  }

  switchCamera() {
    _currentState.uiState.camera = !_currentState.uiState.camera;
    updateUi( _currentState.uiState);
  }

  changeTab(int index) {
    _currentState.uiState.selectedIndex = index;
    updateUi( _currentState.uiState);
  }
}
