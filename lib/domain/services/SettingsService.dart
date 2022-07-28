import 'package:lsr/domain/models/Settings.dart';
import 'package:lsr/domain/providers/ISettingsProvider.dart';
import 'package:lsr/domain/providers/IStorageProvider.dart';

import '../models/Visio.dart';


class SettingsService {
  IStorageProvider storageProvider;
  ISettingsProvider settingsProvider;

  SettingsService({required this.storageProvider, required this.settingsProvider});

  Future<String?> getCharacterName() => storageProvider.getCharacterName();
  Future<String?> setCharacterName(String characterName) => storageProvider.setCharacterName(characterName);

  Future<String?> getPlayerName() => storageProvider.getPlayerName();
  Future<String?> setPlayerName(String playerName) => storageProvider.setPlayerName(playerName);



  Future<Settings> getSettings() async {
    String? currentPlayer = await this.getPlayerName();
    String? currentCharacter = await this.getCharacterName();
    Settings settings = await this.settingsProvider.get(currentPlayer);
    if(!settings.playersName.contains(currentPlayer)) {
      await this.setPlayerName('');
      settings.currentPlayer = null;
    } else {
      settings.currentPlayer = currentPlayer;
    }
    if(!settings.charactersName.contains(currentCharacter)) {
      await this.setCharacterName('');
      settings.currentCharacter = null;
    } else {
      settings.currentCharacter = currentCharacter;
    }
    return settings;
  }

  Future<Visio> getVisio() async {
    return this.settingsProvider.getVisio();
  }

  Future<String> getToken() async {
    return this.settingsProvider.getToken();
  }

  void join(String name, int uid) {
    this.settingsProvider.join(name, uid);
  }

}
