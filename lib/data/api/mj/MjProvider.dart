import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Character.dart';

import '../../../domain/models/MjSheet.dart';
import '../../../domain/providers/IMjProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'entities/SendCreateWithTemplateRequest.dart';
import 'entities/SendCreateWithTemplateResponse.dart';

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

  @override
  Future<List<Character>> addCharacterWithTemplate(String templateName, String customName, int level, int number) async{
    SendCreateWithTemplateRequest request = SendCreateWithTemplateRequest(templateName:templateName, customName:templateName, level:level, number:number);
    Response response = await _networkingConfig.dio.put('mj/template', data: request.toJson());
    SendCreateWithTemplateResponse templateNewCharacters = await SendCreateWithTemplateResponse.fromJson(response.data);
    return templateNewCharacters.templateNewCharacters;
  }

  @override
  deleteRolls() {
    _networkingConfig.dio.delete('rolls');
  }

}
