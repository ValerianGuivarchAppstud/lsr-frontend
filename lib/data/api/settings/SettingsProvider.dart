import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Settings.dart';
import 'package:lsr/domain/models/Visio.dart';

import '../../../domain/providers/ISettingsProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';

class SettingsProvider implements ISettingsProvider {
  final NetworkingConfig _networkingConfig;

  SettingsProvider(this._networkingConfig);

  @override
  Future<Settings> get(String? playerName) async {
    Response response = await _networkingConfig.dio
        .get('settings?playerName=' + (playerName ?? ''));
    Settings settings = Settings.fromJson(response.data);

    return settings;
  }

  @override
  Future<Visio> getVisio() async {
    Response response = await _networkingConfig.dio.get('visio');
    Visio visio = Visio.fromJson(response.data);
    return visio;
  }

  @override
  Future<String> getToken() async {
    Response response = await _networkingConfig.dio.get('token');
    String visioToken = response.data;
    return visioToken;
  }

  @override
  void join(String name, int uid) {
    _networkingConfig.dio.put(
        'uid?characterName=' + name + '&uid=' + uid.toString(),
        data: '{}');
  }
}
