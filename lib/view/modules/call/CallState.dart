import 'package:lsr/domain/models/Character.dart';

import '../../../utils/view/Const.dart';

class CallState {
  bool showLoading;
  String? error;
  String? token;
  List<Character>? charactersUid;
  int? currentUid;
  List<int> connectedUsersUid = [];
  late CallUIState uiState;

  CallState(
      {this.showLoading = true, this.token, this.charactersUid, this.error}) {
    this.uiState = CallUIState();
  }

  CallState copy(CallPartialState partialState) {
    switch (partialState.runtimeType) {
      case TokenLoaded:
        showLoading = false;
        error = null;
        token = (partialState as TokenLoaded).token;
        break;
      case CallLoaded:
        showLoading = false;
        error = null;
        charactersUid = (partialState as CallLoaded).charactersUid;
        break;
      case CallFailed:
        showLoading = false;
        error = 'Unable to open call';
        break;
      case CallLoading:
        showLoading = true;
        error = null;
        break;
      case CallUIUpdated:
        uiState = (partialState as CallUIUpdated).state;
        break;
    }
    return this;
  }
}

class CallUIState {
  bool pjDisplay;
  bool joined;
  int? uid;

  CallUIState(
      {this.pjDisplay = INITIAL_STATE_PJ,
      this.joined = false,
      this.uid = null});
}

abstract class CallPartialState {}

class CallLoaded extends CallPartialState {
  List<Character>? charactersUid;

  CallLoaded(this.charactersUid);
}

class TokenLoaded extends CallPartialState {
  String token;

  TokenLoaded(this.token);
}

class CallFailed extends CallPartialState {
  String error;

  CallFailed(this.error);
}

class CallLoading extends CallPartialState {}

class CallUIUpdated extends CallPartialState {
  CallUIState state;

  CallUIUpdated(this.state);
}
