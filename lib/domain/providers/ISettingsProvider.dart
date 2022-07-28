import 'package:lsr/domain/models/Settings.dart';

import '../models/Visio.dart';

abstract class ISettingsProvider {
  Future<Settings> get(String? playerName);

  Future<Visio> getVisio();
  Future<String> getToken();

  void join(String name, int uid);
}