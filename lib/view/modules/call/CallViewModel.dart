import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/services/SettingsService.dart';

import 'CallState.dart';

class CallViewModel with ChangeNotifier {
  late final SettingsService _configService;
  late CallState _currentState;

  final streamController =
      StreamController<CallState>.broadcast(sync: true);

  CallViewModel(this._configService) {
    _currentState = CallState();
  }

  CallState getState() {
    return _currentState;
  }

  Future<void> getCall([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(CallLoading()));
    }
      _configService.getVisioToken().then((value) {
        streamController.add(_currentState.copy(CallLoaded(
            value)));
      }).onError((error, stackTrace) {
        streamController.add(
            _currentState.copy(CallFailed(error.toString())));
      });
    }
}
