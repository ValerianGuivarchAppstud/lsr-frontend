import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';

class CharacterSheetState {
  bool showLoading;
  Character? character;
  List<Roll>? rollList;
  String? error;
  late CharacterSheetUIState uiState;
  DateTime? lastTimeNoteSaved;
  String notes;

  CharacterSheetState({
    this.showLoading = true,
    this.character,
    this.error,
    this.rollList,
    this.lastTimeNoteSaved,
  this.notes = ''}) {
    this.uiState = CharacterSheetUIState();
  }

  CharacterSheetState copy(CharacterSheetPartialState partialState) {
    switch (partialState.runtimeType) {
      case CharacterSheetLoaded:
        showLoading = false;
        error = null;
          character = (partialState as CharacterSheetLoaded).character;
          rollList = (partialState).rollList;
        break;
      case CharacterLoaded:
        showLoading = false;
        error = null;
          character = (partialState as CharacterLoaded).character;
        break;
      case RollListLoaded:
        showLoading = false;
        error = null;
          rollList = (partialState as RollListLoaded).rollList;
        break;
      case CharacterSheetFailed:
        showLoading = false;
        error = 'Unable to load character';
        break;
      case CharacterSheetLoading:
        showLoading = true;
        error = null;
        break;
      case CharacterSheetUIUpdated:
        uiState = (partialState as CharacterSheetUIUpdated).state;
        break;
      default:
        break;
    }
    return this;
  }


  @override
  String toString() {
    return 'CharacterSheetState{showLoading: $showLoading, character: $character, uiState: $uiState, lastTimeNoteSaved: $lastTimeNoteSaved}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is CharacterSheetState &&
            showLoading == other.showLoading &&
            character == other.character &&
            error == other.error &&
            rollList == other.rollList;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ character.hashCode ^ error.hashCode;



}


class CharacterSheetUIState {
  bool secret;
  bool power;
  bool proficiency;
  bool help;
  bool focus;
  int benediction;
  int malediction;

  CharacterSheetUIState({this.secret = false,
    this.power = false,
    this.proficiency = false,
    this.focus = false,
    this.help = false,
    this.benediction = 0,
    this.malediction = 0});
}

abstract class CharacterSheetPartialState {}

class CharacterSheetLoaded extends CharacterSheetPartialState {
  Character character;
  List<Roll> rollList;

  CharacterSheetLoaded(this.character, this.rollList);
}

class CharacterLoaded extends CharacterSheetPartialState {
  Character character;

  CharacterLoaded(this.character);
}

class RollListLoaded extends CharacterSheetPartialState {
  List<Roll> rollList;

  RollListLoaded(this.rollList);
}

class CharacterSheetFailed extends CharacterSheetPartialState {
  String error;

  CharacterSheetFailed(this.error);
}

class CharacterSheetUIUpdated extends CharacterSheetPartialState {
  CharacterSheetUIState state;

  CharacterSheetUIUpdated(this.state);
}

class CharacterSheetLoading extends CharacterSheetPartialState {}
