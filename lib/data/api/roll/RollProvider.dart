import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Roll.dart';
import 'package:lsr/domain/providers/IRollProvider.dart';

import '../../../domain/models/RollType.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'entities/SendRollRequest.dart';

class RollProvider implements IRollProvider {
  final NetworkingConfig _networkingConfig;

  RollProvider(this._networkingConfig);

  @override
  Future<Roll> send({
    required String rollerName,
    required RollType rollType,
    required bool secret,
    required bool focus,
    required bool power,
    required bool proficiency,
    required int benediction,
    required int malediction,
    required String? characterToHelp,
    required String? resistRoll,
    String empirique = ''
  }) async {
    SendRollRequest sendRollRequest = new SendRollRequest(rollerName: rollerName,
        rollType: rollType,
        secret: secret,
        focus: focus,
        power: power,
        proficiency: proficiency,
        benediction: benediction,
        malediction: malediction,
        characterToHelp: characterToHelp,
        empiriqueRoll: empirique,
        resistRoll: resistRoll);

    Response response = await _networkingConfig.dio.post('roll', data: sendRollRequest.toJson());
    return Roll.fromJson(response.data);
  }
}
