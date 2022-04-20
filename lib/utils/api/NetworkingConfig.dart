import 'package:dio/dio.dart';
import 'package:lsr/config/config_reader.dart';

class NetworkingConfig {
  static final NetworkingConfig _singleton = NetworkingConfig._init();

  late Dio dio;

  factory NetworkingConfig() {
    return _singleton;
  }

  NetworkingConfig._init() {
    dio = Dio(BaseOptions(
            baseUrl: ConfigReader.getBaseUrl(),
          ///  headers: {HttpHeaders.userAgentHeader: 'dio', 'common-header': 'xx'},
           ));
    _addInterceptors(dio);
  }

  static _addInterceptors(Dio dio) {
    dio.interceptors.add(LogInterceptor());
  }
}