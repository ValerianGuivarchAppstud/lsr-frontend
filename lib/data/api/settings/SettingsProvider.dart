import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Settings.dart';

import '../../../domain/providers/ISettingsProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';

class SettingsProvider implements ISettingsProvider {
  final NetworkingConfig _networkingConfig;

  SettingsProvider(this._networkingConfig);

  @override
  Future<Settings> get(String? playerName) async{
    Response response = await _networkingConfig.dio.get('settings?playerName=' + (playerName ?? ''));
    Settings settings = Settings.fromJson(response.data);

    return settings;
  }

  @override
  Future<String> getVisioToken() async{
    Response response = await _networkingConfig.dio.get('token');
    String visioToken = response.data;

    return visioToken;
  }
}
