import 'dart:async';
import 'dart:developer';

import 'package:lsr/domain/models/Roll.dart';
import 'package:lsr/domain/providers/IRollProvider.dart';
import 'package:universal_html/html.dart';

import '../../../domain/models/RollType.dart';
import '../../../utils/api/ErrorHandlerTransformer.dart';
import '../../../utils/api/NetworkingConfig.dart';
import '../sse.dart';
import 'entities/SendRollRequest.dart';
import 'dart:developer' as developer;

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
    required int malediction,
    required String? characterToHelp,
    String empirique = ''
  }) {
    developer.log(rollType.toString());
    SendRollRequest sendRollRequest = new SendRollRequest(rollerName: rollerName,
        rollType: rollType,
        secret: secret,
        focus: focus,
        power: power,
        proficiency: proficiency,
        benediction: benediction,
        malediction: malediction,
        characterToHelp: characterToHelp,
        empiriqueRoll: empirique);

    _networkingConfig.dio.post('roll', data: sendRollRequest.toJson());
  }

  @override
  Stream getRolList() {
    return Sse.connect(
      uri: Uri.parse(
          'http://192.168.1.177:8080/api/v1/sse'),
      closeOnError: true,
      withCredentials: false,
    ).stream;
  }
}
