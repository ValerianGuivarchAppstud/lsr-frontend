
import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';
import '../../../utils/view/Mvi.dart';

class RollState
    extends MviStateViewModel<RollPartialState, RollState> {
  final bool? showLoading;
  final Character? character;
  final Set<Roll>? rollList;
  final String? error;

  RollState({this.showLoading, this.character, this.error, this.rollList});

  factory RollState.initial() => RollState(showLoading: true);

  factory RollState.error(String message) => RollState(
      error: message, showLoading: false);

  factory RollState.withRoll(Character character, Set<Roll> rollList) =>
      RollState(error: null, showLoading: false, character: character, rollList: rollList);

  factory RollState.withCharacter(Character character) =>
      RollState(error: null, showLoading: false, character: character);

  factory RollState.withRollList(Set<Roll> rollList) =>
      RollState(rollList: rollList);

  @override
  String toString() {
    return 'CharacterState {showLoading: $showLoading, character: $character, rollList: $rollList, error: $error}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is RollState &&
            showLoading == other.showLoading &&
            character == other.character &&
            error == other.error &&
            rollList == other.rollList;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ character.hashCode ^ error.hashCode;

  @override
  RollState reducer(RollPartialState partialState) {
    switch (partialState.runtimeType) {
      case RollLoaded:
        return RollState.withRoll(
          (partialState as RollLoaded).character,
          (partialState).rollList,
        );
      case RollFailed:
        return RollState.error('Unable to load character');
      default:
        return RollState.initial();
    }
  }
}


class RollPartialState extends MviPartialState {}
class RollLoaded extends RollPartialState {
  Character character;
  Set<Roll> rollList;

  RollLoaded(this.character, this.rollList);
}

class RollFailed extends RollPartialState {}

class RollLoading extends RollPartialState {}