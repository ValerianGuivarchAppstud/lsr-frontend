
import 'package:lsr/domain/services/SheetService.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/models/Roll.dart';
import '../../../utils/view/Mvi.dart';
import 'RollState.dart';
import 'RollView.dart';

class RollPresenter extends MviPresenter<RollPartialState,
    RollState, RollView> {
  final RollView _view;
  final SheetService _interactor;

  RollPresenter({
    required RollView view,
    required SheetService interactor,
  })  : _view = view,
        _interactor = interactor,
        super(view) {
    subscribeIntents([_load()]);
  }

  Stream<RollPartialState> _load() =>
      _view.fetchRoll.stream.startWith(
          RollLoading()
      ).onErrorReturn(
          RollFailed()
      )
          .flatMap((_) =>
          _interactor
              .get("Viktor")
      ).map((event) => RollLoaded(event.first.character, event.first.rollList));



  // void triggerLoad() => _view.fetchRoll.add(true);

  sendRoll(Roll rollType) {
    _interactor.sendRoll(rollType);
  }
}