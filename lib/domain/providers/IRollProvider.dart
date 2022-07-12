import 'package:lsr/domain/models/Roll.dart';

import '../models/RollType.dart';

abstract class IRollProvider {
  send({
    required String rollerName,
    required RollType rollType,
    required bool secret,
    required bool focus,
    required bool power,
    required bool proficiency,
    required int benediction,
    required int malediction,
    required String? characterToHelp,
    String empirique
  });

  Stream getRolList();
}