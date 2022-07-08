import 'package:lsr/domain/models/Roll.dart';

import '../../../domain/models/Character.dart';

class HealSheetState {
  bool showLoading;
  Character? healer;
  List<Roll>? rollList;
  String? error;
  late HealSheetUIState uiState;

  HealSheetState({
    this.showLoading = true,
    this.healer,
    this.error,
    this.rollList}) {
    this.uiState = HealSheetUIState();
  }

  HealSheetState copy(HealSheetPartialState partialState) {
    switch (partialState.runtimeType) {
      case HealSheetLoaded:
        showLoading = false;
        error = null;
          healer = (partialState as HealSheetLoaded).healer;
          rollList = (partialState).rollList;
        break;
      case HealLoaded:
        showLoading = false;
        error = null;
          healer = (partialState as HealLoaded).heal;
        break;
      case RollListLoaded:
        showLoading = false;
        error = null;
          rollList = (partialState as RollListLoaded).rollList;
        break;
      case HealSheetFailed:
        showLoading = false;
        error = 'Unable to load heal';
        break;
      case HealSheetLoading:
        showLoading = true;
        error = null;
        break;
      case HealSheetUIUpdated:
        uiState = (partialState as HealSheetUIUpdated).state;
        break;
      default:
        break;
    }
    return this;
  }

  @override
  String toString() {
    return 'HealState {showLoading: $showLoading, healer: $healer, rollList: $rollList, error: $error}';
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is HealSheetState &&
            showLoading == other.showLoading &&
            healer == other.healer &&
            error == other.error &&
            rollList == other.rollList;
  }

  @override
  int get hashCode =>
      showLoading.hashCode ^ healer.hashCode ^ error.hashCode;



}


class HealSheetUIState {
  bool secret;
  bool power;
  bool proficiency;
  bool help;
  bool focus;
  int benediction;
  int malediction;

  HealSheetUIState({this.secret = false,
    this.power = false,
    this.proficiency = false,
    this.focus = false,
    this.help = false,
    this.benediction = 0,
    this.malediction = 0});
}

abstract class HealSheetPartialState {}

class HealSheetLoaded extends HealSheetPartialState {
  Character healer;
  List<Roll> rollList;

  HealSheetLoaded(this.healer, this.rollList);
}

class HealLoaded extends HealSheetPartialState {
  Character heal;

  HealLoaded(this.heal);
}

class RollListLoaded extends HealSheetPartialState {
  List<Roll> rollList;

  RollListLoaded(this.rollList);
}

class HealSheetFailed extends HealSheetPartialState {
  String error;

  HealSheetFailed(this.error);
}

class HealSheetUIUpdated extends HealSheetPartialState {
  HealSheetUIState state;

  HealSheetUIUpdated(this.state);
}

class HealSheetLoading extends HealSheetPartialState {}
