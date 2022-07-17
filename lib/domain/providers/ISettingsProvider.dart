import 'package:lsr/domain/models/Settings.dart';

abstract class ISettingsProvider {
  Future<Settings> get(String? playerName);

  Future<String> getVisioToken();
}