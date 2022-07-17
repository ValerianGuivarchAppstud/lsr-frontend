

class CallState {
  bool showLoading;
  String? error;
  String? token;

  CallState({
    this.showLoading = true,
    this.token,
    this.error});

  CallState copy(CallPartialState partialState) {
    switch (partialState.runtimeType) {
      case CallLoaded:
        showLoading = false;
        error = null;
          token = (partialState as CallLoaded).token;
        break;
      case CallFailed:
        showLoading = false;
        error = 'Unable to open call';
        break;
      case CallLoading:
        showLoading = true;
        error = null;
        break;
    }
    return this;
  }


}


abstract class CallPartialState {}

class CallLoaded extends CallPartialState {
  String token;

  CallLoaded(this.token);
}

class CallFailed extends CallPartialState {
  String error;

  CallFailed(this.error);
}

class CallLoading extends CallPartialState {}
