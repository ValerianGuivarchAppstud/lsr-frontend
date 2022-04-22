import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/CharacterSheet.dart';
import 'package:lsr/view/modules/character/CharacterSheetState.dart';

import '../../../domain/services/SheetService.dart';

class CharacterSheetViewModel with ChangeNotifier {
  final SheetService _interactor;

  CharacterSheetState _state = CharacterSheetState.initial();
  final streamController = StreamController<CharacterSheetState>.broadcast(sync: true);

  CharacterSheetViewModel(this._interactor);

  CharacterSheetState get state {
    return _state;
  }

  Future<void> getCharacterSheet(String name) async {

    streamController.add(CharacterSheetState.initial());
    _interactor.get(name).then(
            (value) {
              streamController.add(CharacterSheetState.withCharacterSheet(value.character, value.rollList));
            }
      ).onError((error, stackTrace) {
      streamController.add(CharacterSheetState.error(error.toString()));
    });

        }
}