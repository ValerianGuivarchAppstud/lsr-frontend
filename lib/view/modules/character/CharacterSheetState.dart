import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';

class CharacterSheetState {
  bool showLoading;
  Character? character;
  List<Roll>? rollList;
  String? error;
  late CharacterSheetUIState uiState;

  CharacterSheetState({
    this.showLoading = true,
    this.character,
    this.error,
    this.rollList}) {
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
      case CharacterSheetUISelected:
        switch((partialState as CharacterSheetUISelected).uiName) {
          case 'Lux':
            uiState.lux =  !(uiState.lux);
            break;
          case 'Umbra':
            uiState.umbra =  !(uiState.umbra);
            break;
          case 'Secunda':
            uiState.secunda =  !(uiState.secunda);
            break;
          case 'Focus':
            uiState.focus =  !(uiState.focus);
            break;
          case 'Power':
            uiState.power =  !(uiState.power);
            break;
          case 'Secret':
            uiState.secret =  !(uiState.secret);
            break;
          case 'Proficiency':
            uiState.proficiency =  !(uiState.proficiency);
        }
        break;
      default:
        break;
    }
    return this;
  }

  @override
  String toString() {
    return 'CharacterState {showLoading: $showLoading, character: $character, rollList: $rollList, error: $error}';
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
  bool focus;
  bool lux;
  bool umbra;
  bool secunda;
  int benediction;
  int malediction;

  CharacterSheetUIState({this.secret = false,
    this.power = false,
    this.proficiency = false,
    this.focus = false,
    this.lux = false,
    this.umbra = false,
    this.secunda = false,
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

class CharacterSheetUISelected extends CharacterSheetPartialState {
  String uiName;

  CharacterSheetUISelected(this.uiName);
}

class CharacterSheetLoading extends CharacterSheetPartialState {}
