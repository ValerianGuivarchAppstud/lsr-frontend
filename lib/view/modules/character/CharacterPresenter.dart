
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/services/SheetService.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/models/Roll.dart';
import '../../../utils/view/Mvi.dart';
import 'CharacterState.dart';
import 'CharacterView.dart';

class CharacterPresenter extends MviPresenter<CharacterSheetPartialState,
    CharacterSheetState, CharacterView> {
  final CharacterView _view;
  final SheetService _interactor;

  CharacterPresenter({
    required CharacterView view,
    required SheetService interactor,
  })  : _view = view,
        _interactor = interactor,
        super(view) {
    subscribeIntents([_load()]);
  }

  Stream<CharacterSheetPartialState> _load() =>
      _view.fetchCharacter.stream
          .flatMap((_) =>
         _interactor
            .get("Viktor").map((event) => CharacterSheetLoaded(
             event.first.character, event.first.rollList
         ))
      );


  void triggerLoad() => _view.fetchCharacter.add(true);

  updateCharacter(Character character) {
    _view.fetchCharacter.stream.flatMap((_) => _interactor.update(character));
  }

  sendRoll(Roll rollType) {
    //_view.fetchCharacter.stream.flatMap((_) => _interactor.sendRoll(rollType));
    _interactor.sendRoll(rollType);
  }
}