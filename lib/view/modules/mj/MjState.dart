import 'package:lsr/domain/models/MjSheet.dart';

import '../character/CharacterSheetState.dart';

class MjState {
  bool showLoading;
  MjSheet? mjSheet;
  late Map<String, CharacterSheetState> charactersState;
  String? error;
  late MjUIState uiState;


  MjState({
    this.showLoading = true,
    this.mjSheet,
    this.error}) {
    this.charactersState = {};
    this.uiState = MjUIState(false);
  }

  MjState copy(MjPartialState partialState) {
    switch (partialState.runtimeType) {
      case MjLoaded:
        showLoading = false;
        error = null;
        mjSheet = (partialState as MjLoaded).mjSheet;
        break;
      case MjMainLoaded:
        break;
      case MjFailed:
        showLoading = false;
        error = 'Unable to load MJ page';
        break;
      case MjLoading:
        showLoading = true;
        error = null;
        break;
      case MjUIUpdated:
        print("WESH");
        uiState = (partialState as MjUIUpdated).state;
        print(uiState.camera);
        break;
    }
    return this;
  }

  @override
  String toString() {
    return 'CharacterState {showLoading: $showLoading, mjSheet: $mjSheet, error: $error}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is MjState &&
            showLoading == other.showLoading &&
            mjSheet == other.mjSheet &&
            error == other.error;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ mjSheet.hashCode ^ error.hashCode;

  CharacterSheetState getCharacterStateData(String name) {
    if(charactersState[name] == null) {
      charactersState[name] = new CharacterSheetState();
    }
    return charactersState[name]!;
  }
}

abstract class MjPartialState {}

class MjLoaded extends MjPartialState {
  MjSheet mjSheet;

  MjLoaded(this.mjSheet);
}

class MjFailed extends MjPartialState {
  String error;

  MjFailed(this.error);
}

class MjLoading extends MjPartialState {}




class MjMainLoaded extends MjPartialState {
  bool camera;

  MjMainLoaded(this.camera);
}


class MjUIUpdated extends MjPartialState {
  MjUIState state;

  MjUIUpdated(this.state);
}

class MjUIState {
  bool camera;
  String? errorMessage;

  MjUIState(this.camera);
}