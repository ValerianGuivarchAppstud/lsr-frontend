import 'dart:async';

import 'package:dio/dio.dart';

import '../../../domain/models/MjSheet.dart';
import '../../../domain/providers/IMjProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';

class MjProvider implements IMjProvider {
  final NetworkingConfig _networkingConfig;

  MjProvider(this._networkingConfig);

  @override
  Future<MjSheet> get() async{
    Response response = await _networkingConfig.dio.get('mj');
    MjSheet mjSheet = MjSheet.fromJson(response.data);
    return mjSheet;
  }


  @override
  Future<MjSheet> addCharacterList(String characterName) async{
    Response response = await _networkingConfig.dio.put('mj/character?characterName=' + (characterName), data: '{}');
    MjSheet mjSheet = MjSheet.fromJson(response.data);
    return mjSheet;
  }

  @override
  Future<MjSheet> removeCharacterList(String characterName) async{
    Response response = await _networkingConfig.dio.delete('mj/character?characterName=' + (characterName));
    MjSheet mjSheet = MjSheet.fromJson(response.data);
    return mjSheet;
  }
}
