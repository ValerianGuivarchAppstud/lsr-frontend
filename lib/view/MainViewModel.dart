import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'MainState.dart';

abstract class SubViewModel {
  changeMainState(MainLoaded state);
}

class MainViewModel with ChangeNotifier {
  late MainState _currentState;

  final streamController =
      StreamController<MainState>.broadcast(sync: true);

  MainViewModel() {
    _currentState = MainState();
  }

  MainState getState() {
    return _currentState;
  }

  Future<void> getMain([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(MainLoading()));
    }
        streamController.add(_currentState.copy(MainLoaded(MyApp.INITIAL_STATE_PJ, MyApp.INITIAL_STATE_CAMERA, 0)));
  }

  switchRole() {
    streamController.add(_currentState.copy(MainLoaded(!_currentState.pj, _currentState.camera, 0)));
  }

  switchCamera() {
    streamController.add(_currentState.copy(MainLoaded(_currentState.pj, !_currentState.camera, _currentState.selectedIndex)));
  }

  changeTab(int index) {
    print("lol2");
    print(_currentState.pj);
    print(_currentState.selectedIndex);
    print(index);
    streamController.add(_currentState.copy(MainLoaded(_currentState.pj, _currentState.camera, index)));
  }
}
