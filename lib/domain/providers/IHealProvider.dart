import '../models/HealSheet.dart';

abstract class IHealProvider {
  Future<HealSheet> get(String name);
}
