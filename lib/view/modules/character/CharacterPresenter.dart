
import 'package:flutter/material.dart';
import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/services/CharacterService.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/view/Mvi.dart';
import 'CharacterState.dart';
import 'CharacterView.dart';

class CharacterPresenter extends MviPresenter<CharacterPartialState,
    CharacterState, CharacterView> {
  final CharacterView _view;
  final CharacterService _interactor;

  CharacterPresenter({
    required CharacterView view,
    required CharacterService interactor,
  })  : _view = view,
        _interactor = interactor,
        super(view) {
    subscribeIntents([_load()]);
  }

  Stream<CharacterPartialState> _load() =>
      _view.fetchCharacter.stream.flatMap((_) => _interactor
          .get("Viktor")
          .startWith(
          CharacterLoading()
      )
          .onErrorReturn(
          CharacterFailed()
      ));

  void triggerLoad() => _view.fetchCharacter.add(true);

  updateCharacter(Character character) {
    _view.fetchCharacter.stream.flatMap((_) => _interactor.update(character));
  }
}