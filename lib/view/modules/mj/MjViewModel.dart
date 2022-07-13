import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';

import '../../../domain/services/MjService.dart';
import '../../../domain/services/SheetService.dart';
import 'MjState.dart';


class MjViewModel with ChangeNotifier {
  final MjService _mjService;
  final SheetService _sheetService;
  late MjState _currentState;
  late Map<String, CharacterSheetViewModel> _charactersViewModel;

  final streamController =
      StreamController<MjState>.broadcast(sync: true);

  MjViewModel(this._mjService, this._sheetService) {
    _currentState = MjState();
    _charactersViewModel = {};
  }

  MjState getState() {
    return _currentState;
  }

  Future<void> getMj([bool reload = false]) async {
    if(reload) {
      streamController.add(_currentState.copy(MjLoading()));
    }
    _mjService.getMj().then((value) {
      if(value==null) {
        streamController.add(_currentState.copy(MjFailed('No mj')));
      } else {
        for(CharacterSheetViewModel _characterViewModel in _charactersViewModel.values) {
          _characterViewModel.getState().copy(CharacterSheetLoaded(value.characters.firstWhere((element) => element.name == _characterViewModel.getCharacterName()), [], []));
        }
        streamController.add(_currentState.copy(MjLoaded(value)));
      }
    }).onError((error, stackTrace) {
        streamController.add(_currentState.copy(MjFailed(error.toString())));
      });
  }

  CharacterSheetViewModel getCharacterViewModel(String name) {
    if(_charactersViewModel[name] == null) {
      _charactersViewModel[name] = new CharacterSheetViewModel.mjConstructor(_sheetService, name, _currentState.getCharacterStateData(name));
    }
    return _charactersViewModel[name]!;
  }

  CharacterSheetState getCharacterStateData(String name) {
    return _currentState.getCharacterStateData(name);
  }

  updateUi(MjUIState state) {
    streamController.add(_currentState.copy(MjUIUpdated(state)));
  }

  void createOrUpdateCharacter(Character character) {
    _mjService.createOrUpdateCharacter(character);
  }

  void addCharacterList(String characterName) {
    _mjService.addCharacterList(characterName);
  }

  void removeCharacterList(String characterName) {
    _mjService.removeCharacterList(characterName);
  }
}
