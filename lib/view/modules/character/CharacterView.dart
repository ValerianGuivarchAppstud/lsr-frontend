
import 'dart:async';

import '../../../utils/view/Mvi.dart';
import 'CharacterState.dart';

class CharacterView implements MviView<CharacterSheetState> {
  final fetchCharacter = StreamController<bool>.broadcast(sync: true);

  @override
  Future tearDown() {
    return Future.wait([fetchCharacter.close()]);
  }

  @override
  CharacterSheetState get initialState => CharacterSheetState.initial();
}