import 'package:lsr/domain/models/Character.dart';

abstract class ICharacterProvider {
  Stream<Set<Character>> get(String name);
  Stream<Set<Character>> update(Character character);
}