import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Category.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';
import 'package:lsr/view/modules/character/CharacterSheetViewModel.dart';

import '../../../domain/services/MjService.dart';
import '../../../domain/services/SettingsService.dart';
import '../../../domain/services/SheetService.dart';
import '../../MainState.dart';
import '../../MainViewModel.dart';
import 'MjState.dart';

class MjViewModel extends SubViewModel with ChangeNotifier {
  final MjService _mjService;
  final SheetService _sheetService;
  final SettingsService _settingsService;
  late MjState _currentState;
  late Map<String, CharacterSheetViewModel> _charactersViewModel;

  final streamController = StreamController<MjState>.broadcast(sync: true);

  MjViewModel(this._mjService, this._sheetService, this._settingsService) {
    _currentState = MjState();
    _charactersViewModel = {};
  }

  MjState getState() {
    return _currentState;
  }

  Future<void> getMj([bool reload = false]) async {
    if (reload) {
      streamController.add(_currentState.copy(MjLoading()));
    }
    _mjService.getMj().then((value) {
      if (value == null) {
        streamController.add(_currentState.copy(MjFailed('No mj')));
      } else {
        for (CharacterSheetViewModel _characterViewModel
            in _charactersViewModel.values) {
          _characterViewModel.getState().copy(CharacterSheetLoaded(
              value.characters.firstWhere((element) =>
                  element.name == _characterViewModel.getCharacterName()),
              [],
              [],
          value.playersName));
        }
        streamController.add(_currentState.copy(MjLoaded(value)));
      }
    }).onError((error, stackTrace) {
      streamController.add(_currentState.copy(MjFailed(error.toString())));
    });
  }

  CharacterSheetViewModel getCharacterViewModel(String name) {
    if (_charactersViewModel[name] == null) {
      _charactersViewModel[name] = new CharacterSheetViewModel.mjConstructor(
          _sheetService,
          _settingsService,
          name,
          _currentState.getCharacterStateData(name));
    }
    return _charactersViewModel[name]!;
  }

  CharacterSheetState getCharacterStateData(String name) {
    return _currentState.getCharacterStateData(name);
  }

  updateUi(MjUIState state) {
    streamController.add(_currentState.copy(MjUIUpdated(state)));
  }

  void addCharacterWithTemplate(
      String templateName, String customName, int level, int number) {
    _mjService
        .addCharacterWithTemplate(templateName, customName, level, number)
        .then((value) => {
              for (Character c in value) {this.addCharacterList(c.name)}
            });
  }

  void createNewCharacter(Character character) {
    _mjService.createOrUpdateCharacter(character).then((value) => {
          if (value.category == Category.TEMPO || value.category == Category.PNJ_ALLY || value.category == Category.PNJ_ENNEMY)
            {this.addCharacterList(value.name)}
        });
  }

  void addCharacterList(String characterName) {
    _mjService.addCharacterList(characterName);
  }

  void removeCharacterList(String characterName) {
    _charactersViewModel.remove(characterName);
    _mjService.removeCharacterList(characterName);
  }

  void subir(String name, int degats) {
    if (_currentState.getCharacterStateData(name).character != null) {
      _charactersViewModel[name]!.subir(degats);
    }
  }

  @override
  changeMainState(MainUIUpdated state) {
    print("changeMainState mj");

    _currentState.uiState.camera = state.state.camera;
    print("WESH");
    updateUi(_currentState.uiState);
  }

  deleteRolls() {
    _mjService.deleteRolls();
  }

  nextRound() {
    _mjService.nextRound();
  }

  stopBattle() {
    _mjService.stopBattle();
  }
}
