
import 'dart:async';

import '../../../utils/view/Mvi.dart';
import 'CharacterState.dart';

class CharacterView implements MviView<CharacterState> {
  final fetchCharacter = StreamController<bool>.broadcast(sync: true);

  @override
  Future tearDown() {
    return Future.wait([fetchCharacter.close()]);
  }

  @override
  CharacterState get initialState => CharacterState.initial();
}