import 'dart:async';

import 'package:lsr/domain/providers/IStorageProvider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider implements IStorageProvider {

  @override
  Future<String?> getCharacterName() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString('characterName');
  }

  @override
  Future<String?> setCharacterName(String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('characterName', characterName);
    return prefs.getString('characterName');

  }

  @override
  Future<String?> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString('playerName');
  }

  @override
  Future<String?> setPlayerName(String playerName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('playerName', playerName);
    return prefs.getString('playerName');

  }
}
