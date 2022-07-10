import 'dart:async';

import 'package:dio/dio.dart';

import '../../../domain/models/MjSheet.dart';
import '../../../domain/providers/IMjProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';

class MjProvider implements IMjProvider {
  final NetworkingConfig _networkingConfig;

  MjProvider(this._networkingConfig);

  @override
  Future<MjSheet> get(List<String> pj, List<String> pnj) async{
    final params = <String, dynamic>{
      'pj': pj,
      'pnj': pnj,
    };
    Response response = await _networkingConfig.dio.get('character', queryParameters: params);
    MjSheet mjSheet = MjSheet.fromJson(response.data);
//    developer.log(MjSheet.character.picture ?? 'nooop');

    return mjSheet;
  }
}
