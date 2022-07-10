import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/MjSheet.dart';

class MjState {
  bool showLoading;
  MjSheet? mjSheet;
  late Map<String, CharacterSheetUIState> uiState;
  String? error;

  MjState({
    this.showLoading = true,
    this.mjSheet,
    this.error});

  MjState copy(MjPartialState partialState) {
    switch (partialState.runtimeType) {
      case MjLoaded:
        showLoading = false;
        error = null;
        mjSheet = (partialState as MjLoaded).mjSheet;
        break;
      case MjFailed:
        showLoading = false;
        error = 'Unable to load characters list';
        break;
      case MjLoading:
        showLoading = true;
        error = null;
        break;
      default:
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
