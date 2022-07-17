import 'package:lsr/main.dart';

class MainState {

  late MainUIState uiState;

  bool showLoading;
  String? error;


  MainState({
    this.showLoading = true,
    this.error}) {
    this.uiState = MainUIState(MyApp.INITIAL_STATE_PJ, MyApp.INITIAL_STATE_CAMERA, 0);
  }

  MainState copy(MainPartialState partialState) {
    switch (partialState.runtimeType) {
      case MainLoaded:
        showLoading = false;
        error = null;
        break;
      case MainFailed:
        showLoading = false;
        error = 'Unable to load app';
        break;
      case MainLoading:
        showLoading = true;
        error = null;
        break;
      case MainUIUpdated:
        uiState = (partialState as MainUIUpdated).state;
        break;
    }
    return this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainState &&
          runtimeType == other.runtimeType &&
          showLoading == other.showLoading &&
          error == other.error;

  @override
  int get hashCode =>
      showLoading.hashCode ^
      error.hashCode;
}

abstract class MainPartialState {}

class MainLoaded extends MainPartialState {

  MainLoaded();
}

class MainUIUpdated extends MainPartialState {
  MainUIState state;

  MainUIUpdated(this.state);
}

class MainFailed extends MainPartialState {
  String error;

  MainFailed(this.error);
}

class MainLoading extends MainPartialState {}


class MainUIState {
  bool pj;
  bool camera;
  int selectedIndex;

  MainUIState(this.pj,
    this.camera,
    this.selectedIndex );
}

