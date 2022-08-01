import 'dart:async';

import '../models/Roll.dart';
import '../models/RollType.dart';

abstract class IRollProvider {
  Future<Roll> send(
      {required String rollerName,
      required RollType rollType,
      required bool secret,
      required bool focus,
      required bool power,
      required bool proficiency,
      required int benediction,
      required int malediction,
      required String? characterToHelp,
      required String? resistRoll,
      String empirique});
}
