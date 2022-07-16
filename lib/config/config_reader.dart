import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  final String baseURL;
  final bool isStub;

  Config(this.baseURL, this.isStub);

  Config.fromJson(Map<String, dynamic> json) :
        baseURL = json['baseUrl'],
        isStub = json['isStub'];
}

abstract class ConfigReader {

  static Config? config;

  static Future<void> initialize(String env) async {
    // TODO check why it's not working
    final configString = await rootBundle.loadString('configs/app_config_$env.json');
    final configJson = json.decode(configString) as Map<String, dynamic>;
    config = Config.fromJson(configJson);
  }

  static String getBaseUrl() {
    return config?.baseURL ?? "https://l7r.fr/api/v1/";
  }

  static bool isStub() {
    return config?.isStub ?? false;
  }
}