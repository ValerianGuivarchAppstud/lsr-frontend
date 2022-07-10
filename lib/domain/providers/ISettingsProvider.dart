import 'package:lsr/domain/models/Character.dart';
import 'package:lsr/domain/models/Settings.dart';

import '../models/CharacterSheet.dart';

abstract class ISettingsProvider {
  Future<Settings> get(String? playerName);
}