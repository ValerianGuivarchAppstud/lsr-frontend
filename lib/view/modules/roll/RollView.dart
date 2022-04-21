
import 'dart:async';

import '../../../utils/view/Mvi.dart';
import 'RollState.dart';

class RollView implements MviView<RollState> {
  final fetchRoll = StreamController<RollPartialState>.broadcast(sync: true);

  @override
  Future tearDown() {
    return Future.wait([fetchRoll.close()]);
  }

  @override
  RollState get initialState => RollState.initial();
}