import 'dart:async';

import 'package:lsr/domain/models/Roll.dart';
import 'package:lsr/domain/providers/IRollProvider.dart';

import '../../../utils/api/ErrorHandlerTransformer.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'entities/SendRollRequest.dart';

class RollProvider implements IRollProvider {
  final NetworkingConfig _networkingConfig;

  RollProvider(this._networkingConfig);

  @override
  Stream<Set<Roll>> send(Roll roll) {
    SendRollRequest sendRollRequest = new SendRollRequest(roll: roll);

    return Stream.fromFuture(_networkingConfig.dio.put('roll', data: sendRollRequest.toJson()))
        .transform(ErrorHandlerTransformer()).map((result) => {
      Roll.fromJson(result.data)
    });
  }
}
