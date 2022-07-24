import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';

class HealSheetState {
  bool showLoading;
  Character? character;
  List<Roll>? rollList;
  List<Character>? pjAllies;
  String? error;
  late HealSheetUIState uiState;

  HealSheetState({
    this.showLoading = true,
    this.character,
    this.pjAllies,
    this.error,
    this.rollList}) {
    this.uiState = HealSheetUIState();
  }

  HealSheetState copy(HealSheetPartialState partialState) {
    switch (partialState.runtimeType) {
      case HealSheetLoaded:
        showLoading = false;
        error = null;
        character = (partialState as HealSheetLoaded).character;
        pjAllies = (partialState).pjAllies;
          rollList = (partialState).rollList;
        break;
      case HealSheetFailed:
        showLoading = false;
        error = 'Unable to load heal';
        break;
      case HealSheetLoading:
        showLoading = true;
        error = null;
        break;
      case HealSheetUIUpdated:
        uiState = (partialState as HealSheetUIUpdated).state;
        break;
      default:
        break;
    }
    return this;
  }

  @override
  String toString() {
    return 'HealState {showLoading: $showLoading, character: $character, rollList: $rollList, error: $error}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is HealSheetState &&
            showLoading == other.showLoading &&
            character == other.character &&
            error == other.error &&
            rollList == other.rollList;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ character.hashCode ^ error.hashCode;



}


class HealSheetUIState {
  bool power;
  bool focus;
  int benediction;
  int malediction;
  int heal;
  int healMax;
  String? errorMessage;

  HealSheetUIState({
    this.power = false,
    this.focus = false,
    this.heal = 0,
    this.healMax = 0,
    this.benediction = 0,
    this.malediction = 0});
}

abstract class HealSheetPartialState {}

class HealSheetLoaded extends HealSheetPartialState {
  Character character;
  List<Character> pjAllies;
  List<Roll> rollList;

  HealSheetLoaded(this.character, this.pjAllies, this.rollList);
}

class HealLoaded extends HealSheetPartialState {
  Character heal;

  HealLoaded(this.heal);
}

class RollListLoaded extends HealSheetPartialState {
  List<Roll> rollList;

  RollListLoaded(this.rollList);
}

class HealSheetFailed extends HealSheetPartialState {
  String error;

  HealSheetFailed(this.error);
}

class HealSheetUIUpdated extends HealSheetPartialState {
  HealSheetUIState state;

  HealSheetUIUpdated(this.state);
}

class HealSheetLoading extends HealSheetPartialState {}
