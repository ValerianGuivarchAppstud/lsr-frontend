import '../../../domain/models/Settings.dart';

class SettingsState {
  bool showLoading;
  Settings? settings;
  String? error;
  late SettingsUIState uiState;

  SettingsState({this.showLoading = true, this.settings, this.error}) {
    this.uiState = SettingsUIState(false);
  }

  SettingsState copy(SettingsPartialState partialState) {
    switch (partialState.runtimeType) {
      case SettingsLoaded:
        showLoading = false;
        error = null;
        settings = (partialState as SettingsLoaded).settings;
        break;
      case SettingsMainLoaded:
        break;
      case SettingsUIUpdated:
        uiState = (partialState as SettingsUIUpdated).state;
        break;
      case SettingsFailed:
        showLoading = false;
        error = 'Unable to load characters list';
        break;
      case SettingsLoading:
        showLoading = true;
        error = null;
        break;
      default:
        break;
    }
    return this;
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is SettingsState &&
            showLoading == other.showLoading &&
            settings == other.settings &&
            error == other.error;
  }

  @override
  int get hashCode => showLoading.hashCode ^ settings.hashCode ^ error.hashCode;
}

abstract class SettingsPartialState {}

class SettingsLoaded extends SettingsPartialState {
  Settings settings;

  SettingsLoaded(this.settings);
}

class SettingsMainLoaded extends SettingsPartialState {
  bool pj;

  SettingsMainLoaded(this.pj);
}

class SettingsFailed extends SettingsPartialState {
  String error;

  SettingsFailed(this.error);
}

class SettingsLoading extends SettingsPartialState {}

class SettingsUIUpdated extends SettingsPartialState {
  SettingsUIState state;

  SettingsUIUpdated(this.state);
}

class SettingsUIState {
  bool pj;

  SettingsUIState(this.pj);
}
