import 'dart:async';

import 'package:lsr/domain/models/Roll.dart';
import 'package:lsr/domain/providers/IRollProvider.dart';

import '../../../domain/models/RollType.dart';
import '../../../utils/api/ErrorHandlerTransformer.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'entities/SendRollRequest.dart';

class RollProvider implements IRollProvider {
  final NetworkingConfig _networkingConfig;

  RollProvider(this._networkingConfig);

  @override
  send({
    required String rollerName,
    required RollType rollType,
    required bool secret,
    required bool focus,
    required bool power,
    required bool proficiency,
    required int benediction,
    required int malediction
  }) {
    SendRollRequest sendRollRequest = new SendRollRequest(rollerName: rollerName,
        rollType: rollType,
        secret: secret,
        focus: focus,
        power: power,
        proficiency: proficiency,
        benediction: benediction,
        malediction: malediction);

    _networkingConfig.dio.post('roll', data: sendRollRequest.toJson());
  }
}
