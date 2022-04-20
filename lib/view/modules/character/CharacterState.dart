
import '../../../domain/models/Character.dart';
import '../../../utils/view/Mvi.dart';

class CharacterState
    extends MviStateViewModel<CharacterPartialState, CharacterState> {
  final bool showLoading;
  final Character? character;
  final String? error;

  CharacterState({required this.showLoading, this.character, this.error});

  factory CharacterState.initial() => CharacterState(showLoading: true);

  factory CharacterState.error(String message) => CharacterState(
      error: message, showLoading: false);

  factory CharacterState.withCharacter(Character character) =>
      CharacterState(error: null, showLoading: false, character: character);

  @override
  String toString() {
    return 'CharacterState {showLoading: $showLoading, character: $character, error: $error}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is CharacterState &&
            showLoading == other.showLoading &&
            character == other.character &&
            error == other.error;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ character.hashCode ^ error.hashCode;

  @override
  CharacterState reducer(CharacterPartialState partialState) {
    switch (partialState.runtimeType) {
      case CharacterLoaded:
        return CharacterState.withCharacter(
            (partialState as CharacterLoaded).character);
      case CharacterFailed:
        return CharacterState.error('Unable to load character');
      default:
        return CharacterState.initial();
    }
  }
}


class CharacterPartialState extends MviPartialState {}

class CharacterLoaded extends CharacterPartialState {
  Character character;

  CharacterLoaded(this.character);
}

class CharacterFailed extends CharacterPartialState {}

class CharacterLoading extends CharacterPartialState {}