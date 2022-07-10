abstract class IStorageProvider {
  Future<String?> getCharacterName();
  Future<String?> setCharacterName(String characterName);
  Future<String?> getPlayerName();
  Future<String?> setPlayerName(String characterName);
}