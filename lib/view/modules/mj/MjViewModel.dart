import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';

import '../../../domain/models/RollType.dart';
import '../../../domain/services/MjService.dart';
import '../../../domain/services/SheetService.dart';
import 'MjState.dart';
import 'dart:developer' as developer;

class MjViewModel with ChangeNotifier {
  final MjService _mjService;
  final SheetService _sheetService;
  late MjState _currentState;

  final streamController =
      StreamController<MjState>.broadcast(sync: true);

  MjViewModel(this._mjService) {
    _currentState = MjState();
  }

  MjState getState() {
    return _currentState;
  }


  Future<void> sendRoll(Character character, RollType rollType, [String empirique = '']) async {
      _sheetService.sendRoll(
          rollType: rollType,
          rollerName: character.name,
          secret: uiState.secret,
          focus: _currentState.uiState.focus,
          power: _currentState.uiState.power,
          proficiency: _currentState.uiState.proficiency,
          benediction: _currentState.uiState.benediction,
          malediction: _currentState.uiState.malediction,
          empirique: empirique);
  }

  Future<void> getMj([bool reload = false]) async {

    if(reload) {
      streamController.add(_currentState.copy(MjLoading()));
    }

    _mjService.getMj(_currentState.mjSheet?.pj.map((e) => e.name).toList() ?? [], _currentState.mjSheet?.pnj.map((e) => e.name).toList() ?? []).then((value) {
      if(value==null) {
        streamController.add(_currentState.copy(MjFailed('No mj')));
      } else {
        streamController.add(_currentState.copy(MjLoaded(value)));
      }
    }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(MjFailed(error.toString())));
      });
  }
}
