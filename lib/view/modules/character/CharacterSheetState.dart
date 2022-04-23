import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';
import '../../../utils/view/Mvi.dart';

class CharacterSheetState
    extends MviStateViewModel<CharacterSheetPartialState, CharacterSheetState> {
  final bool? showLoading;
  final Character? character;
  final List<Roll>? rollList;
  final String? error;
  final bool? secret;
  final bool? power;
  final bool? proficiency;
  final bool? focus;
  final int? benediction;
  final int? malediction;

  CharacterSheetState(
      {this.secret,
        this.power,
        this.proficiency,
      this.focus,
      this.benediction,
      this.malediction,
      this.showLoading,
      this.character,
      this.error,
      this.rollList});

  factory CharacterSheetState.initial() =>
      CharacterSheetState(showLoading: true);

  factory CharacterSheetState.loading() =>
      CharacterSheetState(showLoading: true);

  factory CharacterSheetState.error(String message) =>
      CharacterSheetState(error: message, showLoading: false);

  factory CharacterSheetState.withCharacterSheet(
          Character character, List<Roll> rollList) =>
      CharacterSheetState(
          error: null,
          showLoading: false,
          character: character,
          rollList: rollList);

  factory CharacterSheetState.withCharacter(Character character) =>
      CharacterSheetState(
          error: null, showLoading: false, character: character);

  factory CharacterSheetState.withRollList(List<Roll> rollList) =>
      CharacterSheetState(rollList: rollList);

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

  @override
  CharacterSheetState reducer(CharacterSheetPartialState partialState) {
    switch (partialState.runtimeType) {
      case CharacterSheetLoaded:
        return CharacterSheetState.withCharacterSheet(
          (partialState as CharacterSheetLoaded).character,
          (partialState).rollList,
        );
      case CharacterSheetFailed:
        return CharacterSheetState.error('Unable to load character');
      case CharacterSheetLoading:
        return CharacterSheetState.loading();
      default:
        return CharacterSheetState.initial();
    }
  }
}

class CharacterSheetPartialState extends MviPartialState {}

class CharacterSheetLoaded extends CharacterSheetPartialState {
  Character character;
  List<Roll> rollList;

  CharacterSheetLoaded(this.character, this.rollList);
}

class CharacterSheetFailed extends CharacterSheetPartialState {}

class CharacterSheetLoading extends CharacterSheetPartialState {}
