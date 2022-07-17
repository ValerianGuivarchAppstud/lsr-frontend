class MainState {
  bool pj;
  bool camera;
  int selectedIndex;

  bool showLoading;
  String? error;


  MainState({
    this.showLoading = true,
    this.error,
    this.pj = false,
    this.camera = false,
  this.selectedIndex = 0});

  MainState copy(MainPartialState partialState) {
    switch (partialState.runtimeType) {
      case MainLoaded:
        showLoading = false;
        error = null;
        print(pj);
        print(selectedIndex);
        print((partialState as MainLoaded).selectedIndex);
        print((partialState as MainLoaded).pj);
        pj = (partialState as MainLoaded).pj;
        print("lol3");
        print(pj);
          camera = (partialState).camera;
          selectedIndex = (partialState).selectedIndex;
        break;
      case MainFailed:
        showLoading = false;
        error = 'Unable to load app';
        break;
      case MainLoading:
        showLoading = true;
        error = null;
        break;
    }
    return this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainState &&
          runtimeType == other.runtimeType &&
          pj == other.pj &&
          camera == other.camera &&
          selectedIndex == other.selectedIndex &&
          showLoading == other.showLoading &&
          error == other.error;

  @override
  int get hashCode =>
      pj.hashCode ^
      camera.hashCode ^
      selectedIndex.hashCode ^
      showLoading.hashCode ^
      error.hashCode;
}

abstract class MainPartialState {}

class MainLoaded extends MainPartialState {
  bool pj;
  bool camera;
  int selectedIndex;

  MainLoaded(this.pj, this.camera, this.selectedIndex);
}

class MainFailed extends MainPartialState {
  String error;

  MainFailed(this.error);
}

class MainLoading extends MainPartialState {}
