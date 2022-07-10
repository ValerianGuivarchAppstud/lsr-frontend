import 'dart:async';

import 'package:dio/dio.dart';
import 'package:lsr/domain/models/Settings.dart';
import '../../../domain/providers/ISettingsProvider.dart';
import '../../../utils/api/NetworkingConfig.dart';
import 'dart:developer' as developer;

class SettingsProvider implements ISettingsProvider {
  final NetworkingConfig _networkingConfig;

  SettingsProvider(this._networkingConfig);

  @override
  Future<Settings> get(String? playerName) async{
    developer.log("------------");
    Response response = await _networkingConfig.dio.get('settings?playerName=' + (playerName ?? ''));
    developer.log(response.toString());
    Settings settings = Settings.fromJson(response.data);
    developer.log(settings.toString());

    return settings;
  }
}
