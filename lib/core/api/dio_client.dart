import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient(String baseUrl, String token)
      : dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // final accessToken = read(accessTokenProvider).state;
          final accessToken = token;

          if (accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // 에러 로깅 혹은 재시도 로직 등을 추가할 수 있습니다.
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String endpoint) async {
    return await dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return await dio.post(endpoint, data: data);
  }

// 필요에 따라 put, delete 등의 메서드도 추가할 수 있습니다.
}