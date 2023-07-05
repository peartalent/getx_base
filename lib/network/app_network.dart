import 'package:base_flutter_getx/core/logger/app_logger.dart';
import 'package:dio/dio.dart';

class AppNetwork {
  final String url;
  String? accessToken;
  final dio = Dio();

  AppNetwork(this.url, this.accessToken) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('http')) {
        options.path = url + options.path;
      }
      options.connectTimeout = 3000;
      options.receiveTimeout = 3000;
      if (accessToken != null) {
        options.headers['Authorization'] = "Bearer $accessToken";
      }
      logger.i("================================ onRequest");
      logger.v(options.data);
      handler.next(options);
    }, onResponse: (Response response, handler) {
      // Do something with response data
      logger.i("================================ response");
      logger.d(response.data);
      return handler.next(response);
    }, onError: (DioError error, handler) async {
      logger.e(error);
      return handler.next(error);
    }));
  }
}
