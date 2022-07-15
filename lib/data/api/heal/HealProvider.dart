import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/HealSheet.dart';

import '../../../domain/models/HealSheet.dart';
import '../../../domain/providers/IHealProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';

class HealProvider implements IHealProvider {
  final NetworkingConfig _networkingConfig;

  HealProvider(this._networkingConfig);

  @override
  Future<HealSheet> get(String name) async{
    Response response = await _networkingConfig.dio.get('heal?name=' + name);
    HealSheet healSheet = HealSheet.fromJson(response.data);
    return healSheet;
  }
}
